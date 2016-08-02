#import <Foundation/Foundation.h>

@interface LoginAPIManager : NSObject

+ (LoginAPIManager *)sharedInstance;

- (void)logInWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void(^)(void))success
               failure:(void(^)(NSString *))failure;

- (void)signUpWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName
                      email:(NSString *)email
                   password:(NSString *)password
                    success:(void(^)(void))success
                    failure:(void(^)(NSString *))failure;

@end
