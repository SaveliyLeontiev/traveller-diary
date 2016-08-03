#import "SessionAPIManager.h"
#import "AFNetworking.h"
#import "UserBuilder.h"
#import "PathBuilder.h"
#import "PointBuilder.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginAPIManager.h"

static NSString *const kAPIBaseURLString = @"http://api.photowalker.demo.school.noveogroup.com";
static NSString *const kAuthorizationHeader = @"Authorization";


@interface SessionAPIManager ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;
@property (nonatomic) UserBuilder *userBuilder;
@property (nonatomic) PathBuilder *pathBuilder;
@property (nonatomic) PointBuilder *pointBuilder;

@end

@implementation SessionAPIManager

- (instancetype)initWithHash:(NSString *)hash
{
    if (self = [super init]) {
        [LoginAPIManager sharedInstance];
        
        NSURL *APIBaseURL = [NSURL URLWithString:kAPIBaseURLString];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:APIBaseURL];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [_sessionManager.requestSerializer
            setValue:[NSString stringWithFormat:@"Bearer %@", hash]
            forHTTPHeaderField:kAuthorizationHeader];
        [_sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"User-Agent"];
        [_sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Accept-Language"];

        _userBuilder = [[UserBuilder alloc] init];
        _pathBuilder = [[PathBuilder alloc] init];
        _pointBuilder = [[PointBuilder alloc] init];
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

#pragma mark - Path requests

- (void)getMyPathWithSuccess:(void (^)(NSArray<Path *> *))success failure:(void (^)(NSInteger))failure
{
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        if (failure) {
            failure(NSURLErrorNotConnectedToInternet);
        }
    }
    else {
        NSURLSessionDataTask *task = [self.sessionManager
         GET:@"path/mypath"
         parameters:nil
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSArray *responseObject) {
             if (success) {
                 NSArray *pathes = [self.pathBuilder pathesWithArray:responseObject];
                 success(pathes);
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
}

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

#pragma mark - Point request

- (void)createPoint:(LocationCoordinate *)point
            success:(void (^)(void))success
            failure:(void (^)(NSInteger))failure
{
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        if (failure) {
            failure(NSURLErrorNotConnectedToInternet);
        }
        else {
            NSDictionary *data = @{kPointPathId: @(point.path.id),
                                   kPointLongitude: @(point.longitude),
                                   kPointLatitude: @(point.latitude)};
            [self.sessionManager
             POST:@"point/add"
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
    }
}

- (void)getPointsWithPathId:(NSInteger)pathId
                   success:(void (^)(NSArray<LocationCoordinate *> *))success
                   failure:(void (^)(NSInteger))failure
{
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        if (failure) {
            failure(NSURLErrorNotConnectedToInternet);
        }
    }
        else {
            [self.sessionManager
             GET:[NSString stringWithFormat:@"point/path/%i",pathId]
             parameters:nil
             progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, NSArray<NSDictionary *> *responseObject) {
                 if (success) {
                     success([self.pointBuilder pointsWithArray:responseObject]);
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
}

#pragma mark - Photo requests

- (void)getPhotoWithName:(NSString *)name
                 success:(void (^)(UIImage *))success
                 failure:(void (^)(NSInteger))failure
{
   
    [self.sessionManager
     GET:@"photo/get/1.png"
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __unused int i = 0;
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        UIImage *image = [UIImage imageWithData:data];
         __unused int i = 0;
    }];
}

@end
