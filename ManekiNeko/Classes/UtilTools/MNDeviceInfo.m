//
//  DeviceInfo.m
//  CyouSDK
//
//  Created by Alien Wang on 14-8-22.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import "MNDeviceInfo.h"
#import "sys/utsname.h"

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "JCIOKitNodeInfo.h"
#import "JCIOKitDumper.h"

@implementation MNDeviceInfo

+ (float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/*
 *  获取当前时间
 */
+(NSString *)getDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyy-MM-dd HH:mm:ss";
    NSString * userDate =[formatter stringFromDate:[NSDate date]];
    
    //日期特殊情况处理
    NSArray *dateArr = [NSArray arrayWithObjects:@"AM", @"PM", @"上午", @"下午", @"午前", @"午后", nil];
    
    //PM,下午和午,时间＋12
    for (int i = 1; i < dateArr.count; i+=2) {
        if ([userDate rangeOfString:[dateArr objectAtIndex:i]].length) {
            NSRange range = [userDate rangeOfString:@":"];
            NSString *hourStr = [userDate substringWithRange:NSMakeRange(range.location-2, 2)];
            int hourInt = [hourStr intValue] + 12;
            hourStr = [NSString stringWithFormat:@"%d",hourInt];
            userDate = [userDate stringByReplacingCharactersInRange:NSMakeRange(range.location-2, 2) withString:hourStr];
        }
    }
    
    //删除汉字和AM\PM,防止无法入库的风险
    for (NSString *dateStr in dateArr) {
        if ([userDate rangeOfString:dateStr].length) {
            userDate = [userDate stringByReplacingOccurrencesOfString:dateStr withString:@""];
        }
    }
    
    return userDate;
}

+(NSString *)deviceID{
    
    NSString *uid;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    }else if ([[[UIDevice currentDevice]systemVersion]floatValue] <= 5.0)
    {
        uid = [NSString stringWithString:[MNDeviceInfo macAddress]];
        
    } else {
        uid = [NSString stringWithString:[MNDeviceInfo macAddress]];
        if (uid == nil || [uid isEqualToString:@""]) {
            uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
    }
    
    return uid;
}

+(NSString *)bundleID
{
    NSDictionary * dicInfo =[[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [dicInfo objectForKey:@"CFBundleIdentifier"];
    return bundleId;
}

/*
 *  获取MAC地址 唯一表示
 */
+(NSString *)macAddress
{
    //设置参数
    //Mac地址为6组共12个字符，格式为：XX:XX:XX:XX:XX:XX
    int mib[6];
    size_t len;
    char  *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    /*
     设置信息资源库
     */
    //请求网络子系统
    mib[0]=CTL_NET;
    //路由表信息
    mib[1]=AF_ROUTE;
    mib[2]=0;
    //链路层信息
    mib[3]=AF_LINK;
    //配置端口信息
    mib[4]=NET_RT_IFLIST;
    //判断En0地址是否存在，除联通3GS太监外，都存在
    if ((mib[5]=if_nametoindex("en0"))==0) {
        
        return NULL;
        
    }
    //获取数据的大小
    if (sysctl(mib, 6, NULL, &len, NULL, 0)<0) {
        
        return NULL;
        
    }
    //分配内存的基础上调用
    if ((buf=malloc(len))==NULL) {
        
        return NULL;
        
    }
    //获取系统信息，存储在缓冲区
    if ((sysctl(mib, 6, buf, &len, NULL, 0))<0) {
        
        free(buf);
        
        return NULL;
        
    }
    //获取接口电气性结构
    ifm=(struct if_msghdr *)buf;
    sdl=(struct sockaddr_dl *)(ifm+1);
    ptr=(unsigned char *)LLADDR(sdl);
    //获取Mac地址信息：读取字符数组到一个字符串对象，设置为传统的Mac地址，即XX:XX:XX:XX:XX:XX
    NSString *outString=[NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                         *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    //返回Mac地址信息
    return outString;
    
}

/*
 *  获取操作系统类型
 */
+(NSString *)systemName
{
    NSString * sysName = [[UIDevice currentDevice] systemName];
    sysName = [sysName stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
    return sysName;
}

+ (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

/*
 * 获取设备类型
 */
+(NSString *)deviceModelName
{    
    NSString * deviceName = [MNDeviceInfo platformString];
    
    return deviceName;
}

/*
 * 获取设备分辨率
 */
+(NSString *)resolution
{
    CGRect rectscreen = [[UIScreen mainScreen] bounds];
    CGSize rectsize = rectscreen.size;
    CGFloat rect_width = rectsize.width;
    CGFloat rect_height = rectsize.height;
    NSString * strwidth =[NSString stringWithFormat:@"%f",rect_width];
    NSString * strheight =[NSString stringWithFormat:@"%f",rect_height];
    NSString * width = [strwidth substringToIndex:3];
    NSString * height =[strheight substringToIndex:4];
    NSArray * SeparatorArray = [height componentsSeparatedByString:@"."];
    NSString * hight = [SeparatorArray objectAtIndex:0];
    NSMutableString *resolution =[[NSMutableString alloc] init];
    [resolution appendString:hight];
    [resolution appendString:@"*"];
    [resolution appendString:width];
    return resolution;
}

/*
 * 获取运营商标示
 */
+(NSString *)carrier
{
    NSString *ret = [[NSString alloc]init];
    ret = @"0";
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        return @"0";
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code isEqualToString:@"0"] ) {
        return @"0";
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        ret = @"移动";
    }
    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"联通";
    }
    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"电信";;
    }
    
    return ret;
    
}

/*
 * 判断设备是否越狱
 */

+(NSString *)checkJailBroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    NSString * jlbroken =[NSString stringWithFormat:@"%i",jailbroken];
    return jlbroken;
}

/*
 *  获取当前联网方式。
 *  wifi/3g/nonetwork
 */
+(NSString *)checkNetWoriking
{
    return @"";
}

/*
 *  检查是否连接到网络
 */
+(BOOL) isConnectedToNetwork
{
    return NO;
}

+ (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China Model)";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad mini 4 (Cellular)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro (WiFi)";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro (Cellular)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

+ (NSString *)getLaunchSystemTime
{
    NSTimeInterval timer_ = [NSProcessInfo processInfo].systemUptime;
    NSDate *currentDate = [NSDate new];
    
    NSDate *startTime = [currentDate dateByAddingTimeInterval:(-timer_)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *startTimeString = [formatter stringFromDate:startTime];
    
    return startTimeString;
}

+ (NSNumber *)diskSpaceTotal
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *)diskSpaceAvaliable
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

+ (double)batteryAvaliable
{
    // 本函数以5%递变，准确率稍低。
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double batteryAvaliable = [UIDevice currentDevice].batteryLevel;
    
    return batteryAvaliable;
}

+ (NSArray *)allApplications
{
    Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    NSArray *applications = [workspace performSelector:@selector(allApplications)];
    
    NSMutableArray *bundleNameList = [[NSMutableArray alloc] init];
    
    for (NSObject *item in applications) {
        [bundleNameList addObject:[item performSelector:@selector(applicationIdentifier)]];
    }
    
    return bundleNameList;
}

+ (NSArray *)runningProcesses
{
#if !(TARGET_OS_SIMULATOR)
    if ([MNDeviceInfo systemVersion] >= 9.0) {
        return [MNDeviceInfo runningProcessesGraterOrEqualiOS9];
    } else {
        return [MNDeviceInfo runningProcessesLessThaniOS9];
    }
#else
    return @[@"simulator"];
#endif
}

+ (NSArray *)runningProcessesLessThaniOS9
{
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess){
            if (process){
                free(process);
            }
            return nil;
        }
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess){
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = nprocess - 1; i >= 0; i--){
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];

                    /*
                     *  只保留process name
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
                    [array addObject:dict];
                     */
                    
                    [array addObject:processName];
                }
                free(process);
                return array;
            }
        }
    }
    
    return nil;
}

+ (NSArray *)runningProcessesGraterOrEqualiOS9
{
    JCIOKitDumper *_dumper = [JCIOKitDumper new];
    JCIOKitNodeInfo *root = [_dumper dumpIOKitTree];
    
    root = [root children][0];
    
    NSArray *trailPathArr = @[@"IOResources",
                              @"IOCoreSurfaceRoot"];
    
    [trailPathArr count];
    
    int depth = 0;
    NSString *keyWord = [trailPathArr objectAtIndex:depth];
    
    [keyWord length];
    
    for (int i = 0; i < (int)[[root children] count]; i++) {
        if ([[(JCIOKitNodeInfo *)[root children][i] name] isEqualToString:keyWord]) {
            root = [root children][i];
            i = 0;
            
            depth++;
            if (depth >= (int)[trailPathArr count]) {
                break;
            }
            keyWord = [trailPathArr objectAtIndex:depth];
            
        }
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [[root children] count]; i++) {
        if ([[[root children][i] properties] count] > 0) {
            NSString *property = [(NSArray *)[[root children][i] properties] objectAtIndex:0];
            
            property = [property stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSArray *componentsArr = [property componentsSeparatedByString:@","];
            
            if ([componentsArr count] > 1) {
                NSString *pname = [[property componentsSeparatedByString:@","] objectAtIndex:1];
                
                [array addObject:pname];
            }
        }
    }
    
    return array;
}

static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

+(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *desktopApps = [NSMutableArray array];
    
    for (NSString *appKey in dictionary)
    {
        [desktopApps addObject:appKey];
    }
    return desktopApps;
}

+(NSArray *)installedApp
{
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir)
    {
        NSMutableDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
        NSDictionary *system = [cacheDict objectForKey:@"System"];
        NSMutableArray *installedApp = [NSMutableArray arrayWithArray:[self desktopAppsFromDictionary:system]];
        
        NSDictionary *user = [cacheDict objectForKey:@"User"];
        [installedApp addObjectsFromArray:[self desktopAppsFromDictionary:user]];
        
        return installedApp;
    }
    
    return nil;
}

@end
