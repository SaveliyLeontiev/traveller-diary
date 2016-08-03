#import "Path.h"
#import "LocationCoordinate.h"

@implementation Path


+ (NSString *)primaryKey
{
    return @"name";
}
//
//+ (NSDictionary *)defaultPropertyValues {
//    return @{@"id" : [[NSUUID UUID] UUIDString]};
//}

+ (NSDictionary *)linkingObjectsProperties
{
    return @{ @"coordinates": [RLMPropertyDescriptor descriptorWithClass:LocationCoordinate.class propertyName:@"path"] };
}

@end
