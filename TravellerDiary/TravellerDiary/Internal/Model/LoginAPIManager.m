#import "LoginAPIManager.h"
#import "AFNetworking.h"

static NSString *const kAPIBaseURLString = @"http://demo7081002.mockable.io";

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
               success:(void(^)(NSString *))success
               failure:(void(^)(NSString *))failure
{
    NSDictionary *data = @{@"email": email,
                           @"password": password};
    [self.sessionManager
     POST:@"user/login"
     parameters:data
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *hash) {
         if (success) {
             success([self parseHash:hash]);
         }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSHTTPURLResponse *response =
         error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
         switch (response.statusCode) {
             case 404:
                 failure(NSLocalizedString(@"LoginAPIManagerErrorUserNotFound", ));
             default:
                 failure(@"Error");
                 break;
         }
     }];

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

- (void)resetPasswordWithEmail:(NSString *)email
                       success:(void (^)(void))success
                       failure:(void (^)(NSString *))failure
{
    NSDictionary *data = @{@"email": email};
    [self.sessionManager
     POST:@"user/forgot"
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

@end
