#import <Realm.h>
#import "DatabaseProvider.h"
#import "LocationCoordinate.h"
#import "Path.h"
#import "User.h"

@interface DatabaseProvider ()

@end

@implementation DatabaseProvider

+ (instancetype)sharedInstance
{
    static DatabaseProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseProvider alloc] init];
    });
    return sharedInstance;
}

- (void)saveData:(NSDictionary *)data
{
    
#warning SERGEY TO DO: save Data haven't done yet
    
    dispatch_async(dispatch_queue_create("queue", 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        Path *path = [[Path alloc] init];
        path.name = [data valueForKey:@"name"];
        path.comment = [data valueForKey:@"comment"];
        path.coordinates = [data valueForKey:@"points"];
        
//                route.duration = [data valueForKey:@"duration"];
        
        [realm commitWriteTransaction];
    });
}

- (void)addObject:(RLMObject *)object
{
    if ([object isKindOfClass:[LocationCoordinate class]]) {
        dispatch_async(dispatch_queue_create("queue", 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:(LocationCoordinate *)object];
            [realm commitWriteTransaction];
        });
    }
    
    if ([object isKindOfClass:[Path class]]) {
        dispatch_async(dispatch_queue_create("queue", 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:(Path *)object];
            [realm commitWriteTransaction];
        });
    }
    
    if ([object isKindOfClass:[User class]]) {
        dispatch_async(dispatch_queue_create("queue", 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:(User *)object];
            [realm commitWriteTransaction];
        });
    }
    
    else {
        // Failed
    }
}

- (void)updateObject:(RLMObject *)object
{
    
}

- (void)removeObject:(RLMObject *)object
{
    
}

- (RLMObject *)userByFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName == %@ AND lastName == %@", firstName, lastName];
    User *user = [[User objectsWithPredicate:predicate] firstObject];
    return user;
}

- (NSArray *)users
{
    RLMResults * allUsers = [User allObjects];
    NSMutableArray * users = [NSMutableArray array];
    for (User *user in allUsers) {
        [users addObject:user];
    }
    return [users copy];
}

- (RLMObject *)pathByName:(NSString *)name
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    Path *path = [[Path objectsWithPredicate:predicate] firstObject];
    return path;
}

- (NSArray *)paths
{
    RLMResults * allPaths = [Path allObjects];
    NSMutableArray * paths = [NSMutableArray array];
    for (Path *path in allPaths) {
        [paths addObject:path];
    }
    return [paths copy];
}

@end
