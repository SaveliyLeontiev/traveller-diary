#import "LocationCoordinate.h"
#import "Path.h"

@implementation LocationCoordinate

+ (NSString *)primaryKey
{
    return @"id";
}

+ (NSArray *)requiredProperties
{
    return @[@"date"];
}

+ (NSDictionary *)linkingObjectsProperties
{
    return @{ @"routes": [RLMPropertyDescriptor descriptorWithClass:Path.class propertyName:@"id"] };
}

@end