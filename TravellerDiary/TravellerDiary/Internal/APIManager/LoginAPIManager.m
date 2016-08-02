#import "LoginAPIManager.h"
#import "AFNetworking.h"
#import "LoginController.h"

static NSString *const kAPIBaseURLString = @"http://api.photowalker.demo.school.noveogroup.com";

@interface LoginAPIManager ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation LoginAPIManager

+ (LoginAPIManager *)sharedInstance
{
    static LoginAPIManager *_sharedInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[LoginAPIManager alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSURL *APIBaseURL = [NSURL URLWithString:kAPIBaseURLString];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:APIBaseURL];
    }
    return self;
}

- (void)logInWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void(^)(void))success
               failure:(void(^)(NSString *))failure
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        NSDictionary *data = @{@"email": email,
                               @"password": password};
        [self.sessionManager
         POST:@"user/login"
         parameters:data
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *hashDict) {
             [LoginController saveHash:[self parseHash:hashDict]];
             if (success) {
                 success();
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSHTTPURLResponse *response =
             error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
             switch (response.statusCode) {
                 case 404:
                     failure(NSLocalizedString(@"LoginAPIManagerErrorUserNotFound", ));
                 default:
                     failure(NSLocalizedString(@"ErrorTitle", ));
                     break;
             }
         }];
    }
    else if (failure) {
        failure(NSLocalizedString(@"ErrorNoInternetConnection", ));
    }

}

- (NSString *)parseHash:(NSDictionary *)hash
{
    return hash[@"hash"];
}


- (void)signUpWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName
                      email:(NSString *)email
                   password:(NSString *)password
                    success:(void (^)(void))success
                    failure:(void (^)(NSString *))failure
{
    NSDictionary *data = @{@"email": email,
                           @"password": password,
                           @"first_name": firstName,
                           @"last_name": lastName};
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self.sessionManager
         POST:@"user/register"
         parameters:data
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSHTTPURLResponse *response =
             error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
             switch (response.statusCode) {
                 default:
                     failure(@"Error");
                     break;
             }
         }];
    }
    else if (failure) {
        failure(NSLocalizedString(@"ErrorNoInternetConnection", ));
    }
}

@end
