#import <Foundation/Foundation.h>

@interface DatabaseProvider : NSObject

+ (instancetype)sharedInstance;

- (void)saveData:(NSDictionary *)data;

- (void)addObject:(RLMObject *)object;
- (void)updateObject:(RLMObject *)object;
- (void)removeObject:(RLMObject *)object;

- (RLMObject *)userByFirstName:(NSString *)firstName lastName:(NSString *)lastName;
- (NSArray *)users;

- (RLMObject *)pathByName:(NSString *)name;
- (NSArray *)paths;

@end
