#import "PointBuilder.h"
#import "Utility.h"

@implementation PointBuilder

- (LocationCoordinate *)pointWithDict:(NSDictionary *)dict
{
    LocationCoordinate *point = [[LocationCoordinate alloc] init];
    point.id = [Utility intValueFromNum:dict[kPointId]];
    point.longitude = [Utility intValueFromNum:dict[kPointLongitude]];
    point.latitude = [Utility intValueFromNum:dict[kPointLatitude]];
    return point;
}

- (NSArray<LocationCoordinate *> *)pointsWithArray:(NSArray<NSDictionary *> *)array
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [points addObject:[self pointWithDict:dict]];
    }
    return points;
}

@end
