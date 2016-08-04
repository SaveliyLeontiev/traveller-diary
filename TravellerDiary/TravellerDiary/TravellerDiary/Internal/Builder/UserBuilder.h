#import <Foundation/Foundation.h>
#import "User.h"

@interface UserBuilder : NSObject

- (User *)userWithDictionary:(NSDictionary *)dict;

@end
