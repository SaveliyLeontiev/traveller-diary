#import "Utility.h"

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

@end
