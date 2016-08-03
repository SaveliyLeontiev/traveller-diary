#import <Realm/Realm.h>
#import "LocationCoordinate.h"

@class LocationCoordinate;

@interface Path : RLMObject

@property NSInteger id;
@property NSInteger userId;
@property NSString *name;
@property NSString *comment;
@property NSInteger rating;
@property (readonly) RLMLinkingObjects *coordinates;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property BOOL shared;
@property NSInteger duration;
@property NSInteger distance;

@end

RLM_ARRAY_TYPE(Path)
