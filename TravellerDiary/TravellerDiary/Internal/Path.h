#import <Realm/Realm.h>
#import "LocationCoordinate.h"

@interface Path : RLMObject

@property NSInteger id;
@property NSString *name;
@property NSString *comment;
@property RLMArray<LocationCoordinate *> *coordinates;
@property NSDate *createdAt;
@property NSDate *updatedAt;
@property BOOL shared;
@property NSInteger duration;
@property NSInteger distance;

@end

RLM_ARRAY_TYPE(Path)