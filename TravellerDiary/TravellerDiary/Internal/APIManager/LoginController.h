#import <Foundation/Foundation.h>

@interface LoginController : NSObject

+ (void)saveHash:(NSString *)hash;
+ (NSString *)hash;
+ (BOOL)isLogined;
+ (void)logout;

@end
