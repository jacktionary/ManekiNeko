#import <Foundation/Foundation.h>

@interface MNRSA : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
- (MNRSA *)initWithData:(NSData *)keyData;
- (MNRSA *)initWithPublicKey:(NSString *)publicKeyPath;

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSString *)content;

@end
