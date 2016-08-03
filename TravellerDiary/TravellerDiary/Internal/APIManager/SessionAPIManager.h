#import <Foundation/Foundation.h>
#import "User.h"
#import "Path.h"

@interface SessionAPIManager : NSObject

- (instancetype)initWithHash:(NSString *)hash NS_DESIGNATED_INITIALIZER;

- (void)updateHash:(NSString *)hash;
/*
 * Return -1009 in failure block if no conection with server
 */
- (void)logoutWithSuccess:(void(^)(void))success failure:(void(^)(NSInteger))failure;

- (void)getUserProfileWithSuccess:(void(^)(User *))success failure:(void(^)(NSInteger))failure;
- (void)getUserWithId:(NSInteger)userId
              success:(void(^)(User *))success
              failure:(void(^)(NSInteger))failure;

- (void)getMyPathWithSuccess:(void(^)(NSArray<Path *> *))success failure:(void(^)(NSInteger))failure;
- (void)getPathWithId:(NSInteger)pathId
              success:(void(^)(Path *))success
              failure:(void(^)(NSInteger))failure;

- (void)createPath:(Path *)path success:(void(^)(void))success failure:(void(^)(NSInteger))failure;
- (void)deletePathWithId:(NSInteger)pathId
                 success:(void(^)(void))success
                 failure:(void(^)(NSInteger))failure;
@end
