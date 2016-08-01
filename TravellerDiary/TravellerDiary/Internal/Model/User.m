#import "User.h"

@implementation User

+ (NSString *)primaryKey
{
    return @"id";
}

+ (NSArray *)requiredProperties
{
    return @[@"firstName", @"lastName", @"email", @"password", @"file"];
}

@end
