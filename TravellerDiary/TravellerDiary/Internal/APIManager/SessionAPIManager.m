#import "SessionAPIManager.h"
#import "AFNetworking.h"
#import "UserBuilder.h"
#import "PathBuilder.h"
#import "Keys.h"

static NSString *const kAPIBaseURLString = @"http://api.photowalker.demo.school.noveogroup.com";
static NSString *const kAuthorizationHeader = @"Authorization";


@interface SessionAPIManager ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;
@property (nonatomic) UserBuilder *userBuilder;
@property (nonatomic) PathBuilder *pathBuilder;

@end

@implementation SessionAPIManager

- (instancetype)initWithHash:(NSString *)hash
{
    if (self = [super init]) {
        NSURL *APIBaseURL = [NSURL URLWithString:kAPIBaseURLString];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:APIBaseURL];
        [_sessionManager.requestSerializer
            setValue:[NSString stringWithFormat:@"Bearer  %@", hash]
            forHTTPHeaderField:kAuthorizationHeader];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithHash:@""];
}

- (void)updateHash:(NSString *)hash
{
    [self.sessionManager.requestSerializer
        setValue:[NSString stringWithFormat:@"Bearer  %@", hash]
        forHTTPHeaderField:kAuthorizationHeader];
}

- (void)logoutWithSuccess:(void (^)(void))success failure:(void (^)(NSInteger))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self.sessionManager
         POST:@"user/logout"
         parameters:nil
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 NSHTTPURLResponse *response =
                 error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                 failure(response.statusCode);
             }
         }];
    }
    else if (failure) {
        failure(NSURLErrorNotConnectedToInternet);
    }

}

#pragma mark - User requests

- (void)getUserProfileWithSuccess:(void (^)(User *))success failure:(void (^)(NSInteger))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self.sessionManager
         GET:@"user/profile"
         parameters:nil
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *userProfile) {
             if (success) {
                 success([self.userBuilder userWithDictionary:userProfile]);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 NSHTTPURLResponse *response =
                 error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                 failure(response.statusCode);
             }
         }];
    }
    else if (failure) {
        failure(NSURLErrorNotConnectedToInternet);
    }
}

- (void)getUserWithId:(NSInteger)userId
              success:(void (^)(User *))success
              failure:(void (^)(NSInteger))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self.sessionManager
         GET:[NSString stringWithFormat:@"user/%i", userId]
         parameters:nil
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
             if (success) {
                 success([self.userBuilder userWithDictionary:responseObject]);
             }
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 NSHTTPURLResponse *response =
                 error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                 failure(response.statusCode);
             }
         }];
    }
    else if (failure) {
        failure(NSURLErrorNotConnectedToInternet);
    }
}

#pragma mark Path requests

- (void)getPathWithId:(NSInteger)pathId
              success:(void (^)(Path *))success
              failure:(void (^)(NSInteger))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self.sessionManager
         GET:[NSString stringWithFormat:@"path/%i",pathId]
         parameters:nil
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success([self.pathBuilder pathWithDictionary:responseObject]);
             }
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 NSHTTPURLResponse *response =
                 error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                 failure(response.statusCode);
             }
         }];
    }
    else if (failure) {
        failure(NSURLErrorNotConnectedToInternet);
    }
}

- (void)createPath:(Path *)path success:(void (^)(void))success failure:(void (^)(NSInteger))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        NSInteger sharedNum = path.shared ? 1:0;
        NSDictionary *data = @{kPathName: path.name,
                               kPathDistance: @(path.distance),
                               kPathDuration: @(path.duration),
                               kPathShared: @(sharedNum),
                               kPathRating: @(path.rating)};
        [self.sessionManager
         POST:@"path/create"
         parameters:data
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 NSHTTPURLResponse *response =
                 error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                 failure(response.statusCode);
             }
         }];
    }
    else if (failure) {
        failure(NSURLErrorNotConnectedToInternet);
    }
}

- (void)deletePathWithId:(NSInteger)pathId
                 success:(void (^)(void))success
                 failure:(void (^)(NSInteger))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self.sessionManager
         POST:@"path/delete"
         parameters:@{kPathId: @(pathId)}
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                NSHTTPURLResponse *response =
                error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                failure(response.statusCode);
            }
        }];
    }
    else if (failure) {
        failure(NSURLErrorNotConnectedToInternet);
    }
}

@end
