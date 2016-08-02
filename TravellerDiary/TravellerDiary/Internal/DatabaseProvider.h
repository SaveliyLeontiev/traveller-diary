#import <Foundation/Foundation.h>
@class Path;


@interface DatabaseProvider : NSObject

+ (instancetype)sharedInstance;

- (void)addObject:(RLMObject *)object;
- (void)updateObject:(RLMObject *)object;
- (void)removeObject:(RLMObject *)object;

- (RLMObject *)userByFirstName:(NSString *)firstName lastName:(NSString *)lastName;
- (NSArray *)users;

- (RLMObject *)pathByName:(NSString *)name;
- (NSArray *)paths;

- (void)currentPathCompletionBlock:(void (^)(Path *))completionBlock;
- (Path *)currentPath;

@end
