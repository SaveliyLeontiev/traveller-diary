#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utility

+ (NSInteger)intValueFromNum:(NSNumber *)num
{
    if (![num isEqual:[NSNull null]]) {
        return num.integerValue;
    }
    else {
        return 0;
    }
}

+ (BOOL)boolValueFromNum:(NSNumber *)num
{
    if (![num isEqual:[NSNull null]]) {
        return num.boolValue;
    }
    else {
        return NO;
    }
}

+ (float)floatValueFromNum:(NSNumber *)num
{
    if (![num isEqual:[NSNull null]]) {
        return num.floatValue;
    }
    else {
        return NO;
    }
}

+ (NSString*)md5StringForData:(NSData *)data
{
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], [data length], md5);
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            md5[0], md5[1],
            md5[2], md5[3],
            md5[4], md5[5],
            md5[6], md5[7],
            md5[8], md5[9],
            md5[10], md5[11],
            md5[12], md5[13],
            md5[14], md5[15]
            ];
}

@end
