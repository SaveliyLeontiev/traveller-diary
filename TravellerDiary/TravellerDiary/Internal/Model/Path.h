#import <Realm/Realm.h>
#import "LocationCoordinate.h"

@interface Path : RLMObject

@property NSInteger pathId;
@property NSInteger userId;
@property NSString *name;
@property NSString *comment;
@property NSInteger rating;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property BOOL shared;
@property NSInteger duration;
@property NSInteger distance;
@property RLMLinkingObjects *coordinates;

@end

RLM_ARRAY_TYPE(Path)
