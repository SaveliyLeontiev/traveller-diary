#import <Foundation/Foundation.h>
#import "PathData.h"

@interface PathManager : NSObject

- (void)getPathDataForHistoryWithSuccess:(void(^)(PathData *))success
                                 failure:(void(^)(NSString *))failure;

- (void)getPathDataForPopularWithSuccess:(void(^)(PathData *))success
                                 failure:(void(^)(NSString *))failure;

@end
