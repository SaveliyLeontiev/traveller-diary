#import <Realm/Realm.h>

@class Path;
@class LocationCoordinate;

@interface Photo : RLMObject

@property NSInteger id;
@property NSString *name;
@property NSString *comment;
@property NSString *fileName;
@property LocationCoordinate *coordinate;
@property Path *path;
@property NSDate *createdAt;

@end
