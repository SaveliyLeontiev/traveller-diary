#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    if (hexString.length != 6) {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    uint baseColor;
    if ([scanner scanHexInt:&baseColor]) {
        CGFloat red   = ((baseColor & 0xFF0000) >> 16) / 255.0f;
        CGFloat green = ((baseColor & 0x00FF00) >>  8) / 255.0f;
        CGFloat blue  =  (baseColor & 0x0000FF) / 255.0f;
        return [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
    return nil;
}

+ (UIColor *)mainThemeColor
{
    return [UIColor colorWithHexString:@"FC8609"];
}

@end
