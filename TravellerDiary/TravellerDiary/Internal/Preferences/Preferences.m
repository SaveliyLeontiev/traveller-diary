#import "Preferences.h"

static NSString *const kAccuracyType = @"AccuracyType";

@implementation Preferences

+ (AccuracyType)accuracyType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAccuracyType];
}

+ (void)setAccuracyTypeWithType:(AccuracyType)type
{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:kAccuracyType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
