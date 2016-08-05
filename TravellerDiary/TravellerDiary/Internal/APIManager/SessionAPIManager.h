#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Path.h"
#import "LocationCoordinate.h"

@interface SessionAPIManager : NSObject

- (instancetype)initWithHash:(NSString *)hash NS_DESIGNATED_INITIALIZER;

- (void)updateHash:(NSString *)hash;
/*
 * Return -1009 in failure block if no conection with server
 */
- (void)logoutWithSuccess:(void(^)(void))success failure:(void(^)(NSInteger))failure;


/*
 * User methods
 */
- (void)getUserProfileWithSuccess:(void(^)(User *))success failure:(void(^)(NSInteger))failure;
- (void)getUserWithId:(NSInteger)userId
              success:(void(^)(User *))success
              failure:(void(^)(NSInteger))failure;

/*
 * Path methods
 */

- (void)getMyPathWithSuccess:(void(^)(NSArray<Path *> *))success failure:(void(^)(NSInteger))failure;
- (void)getPathWithId:(NSInteger)pathId
              success:(void(^)(Path *))success
              failure:(void(^)(NSInteger))failure;

- (void)createPath:(Path *)path success:(void(^)(NSInteger))success failure:(void(^)(NSInteger))failure;
- (void)deletePathWithId:(NSInteger)pathId
                 success:(void(^)(void))success
                 failure:(void(^)(NSInteger))failure;
- (void)getPopularPathWithSuccess:(void(^)(NSArray<Path *> *))success failure:(void(^)(NSInteger))failure;
- (void)getClosestPathToPoint:(LocationCoordinate *)point
                      success:(void(^)(NSArray<Path *> *))success
                      failure:(void(^)(NSInteger))failure;

/*
 * Point methods
 */

- (void)createPoint:(LocationCoordinate *)point
             pathId:(NSInteger)pathId
            success:(void(^)(void))success
            failure:(void(^)(NSInteger))failure;
- (void)getPointsWithPathId:(NSInteger)pathId
                   success:(void(^)(NSArray<LocationCoordinate *> *))success
                   failure:(void(^)(NSInteger))failure;
- (void)createPoints:(NSArray<LocationCoordinate *> *)points
              pathId:(NSInteger)pathId
             success:(void(^)(void))success
             failure:(void(^)(NSInteger))failure;

/*
 * Photo methods
 */

- (void)getPhotoWithImageURL:(NSURL *)imageURL
                     success:(void(^)(UIImage *))success
                     failure:(void(^)(NSInteger))failure;

- (void)uploadPhoto:(UIImage *)photo
         withPathId:(NSInteger)pathId
            pointId:(NSInteger)pointId
            success:(void(^)(void))success
            failure:(void(^)(NSInteger))failure;

@end
