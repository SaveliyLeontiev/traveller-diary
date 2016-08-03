#import <Realm/Realm.h>
#import "Path.h"

@class Path;

@interface LocationCoordinate : RLMObject

//@property NSInteger id;
@property float longitude;
@property float latitude;
@property NSDate *date;
@property Path *path;

@end

RLM_ARRAY_TYPE(LocationCoordinate)
