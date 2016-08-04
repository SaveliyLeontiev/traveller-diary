#import <Foundation/Foundation.h>
#import "LocationCoordinate.h"

@interface PointBuilder : NSObject

- (LocationCoordinate *)pointWithDict:(NSDictionary *)dict;
- (NSArray<LocationCoordinate *> *)pointsWithArray:(NSArray<NSDictionary *> *)array;

@end
