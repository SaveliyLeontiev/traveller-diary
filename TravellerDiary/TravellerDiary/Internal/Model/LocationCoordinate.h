#import <Realm/Realm.h>

@interface LocationCoordinate : RLMObject

@property NSInteger id;
@property float longitude;
@property float latitude;
@property NSDate *date;
@property (readonly) RLMLinkingObjects *paths;

@end

RLM_ARRAY_TYPE(LocationCoordinate)
