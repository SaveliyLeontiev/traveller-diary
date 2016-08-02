#import <Foundation/Foundation.h>

@interface LoginController : NSObject

- (void)saveHash:(NSString *)hash;
- (BOOL)isLogined;
- (void)logout;

@end
