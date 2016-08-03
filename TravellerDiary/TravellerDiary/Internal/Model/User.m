#import "User.h"

@implementation User

+ (NSString *)primaryKey
{
    return @"firstName";
}

+ (NSArray *)requiredProperties
{
    return @[@"firstName", @"lastName", @"email", @"password", @"file"];
}

@end
