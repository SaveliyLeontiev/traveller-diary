#import "User.h"

@implementation User

+ (NSString *)primaryKey
{
    return @"userId";
}

+ (NSArray *)requiredProperties
{
    return @[@"firstName", @"lastName", @"email", @"password", @"file"];
}

@end
