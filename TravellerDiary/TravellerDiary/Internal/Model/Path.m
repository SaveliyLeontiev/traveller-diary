#import "Path.h"
#import "LocationCoordinate.h"

@implementation Path


+ (NSString *)primaryKey
{
    return @"id";
}

+ (NSDictionary *)linkingObjectsProperties
{
    return @{ @"coordinates": [RLMPropertyDescriptor descriptorWithClass:LocationCoordinate.class propertyName:@"path"] };
}

@end
