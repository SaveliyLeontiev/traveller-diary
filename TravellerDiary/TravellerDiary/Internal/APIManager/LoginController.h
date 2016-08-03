#import <Foundation/Foundation.h>

@interface LoginController : NSObject

+ (void)saveHash:(NSString *)hash Email:(NSString *)email password:(NSString *)password;
+ (NSString *)hash;
+ (NSString *)email;
+ (NSString *)password;
+ (BOOL)isLogined;
+ (void)logout;

@end
