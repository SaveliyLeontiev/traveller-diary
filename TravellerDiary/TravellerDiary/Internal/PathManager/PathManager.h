#import <Foundation/Foundation.h>
#import "PathData.h"

@interface PathManager : NSObject

- (void)getPathDataForHistoryWithSuccess:(void(^)(PathData *))success
                                 failure:(void(^)(NSString *))failure;

- (void)getPathDataForPopularWithSuccess:(void(^)(PathData *))success
                                 failure:(void(^)(NSString *))failure;

- (void)getPathDataForNearestWithSuccess:(void(^)(PathData *))success
                                 failure:(void(^)(NSString *))failure;

- (void)postPath:(Path *)path
          points:(NSArray<LocationCoordinate *> *)points
          photos:(NSArray<UIImage *> *)photos
         success:(void(^)(void))success
         failure:(void(^)(NSString *))failure;

- (void)getPathToMapWithPathId:(NSInteger)pathId success:(void(^)(NSArray<LocationCoordinate *> *))success failure:(void(^)(NSString *))failure;

@end
