#import <Realm.h>
#import "DatabaseProvider.h"
#import "LocationCoordinate.h"
#import "Path.h"
#import "User.h"

@interface DatabaseProvider ()

@property (nonatomic) dispatch_queue_t serialQueue;
@property (nonatomic) Path *path;

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

- (instancetype)init
{
    if (self = [super init]) {
        _serialQueue = dispatch_queue_create("travelller.DiaryDatabaseProvider.serialQueue", 0);
    }
    return self;
}

//- (void)currentPathCompletionBlock:(void (^)(Path *))completionBlock;
//{
//    dispatch_async(self.serialQueue, ^{
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updatedAt = 'NULL'"];
//        [realm beginWriteTransaction];
//        Path *path = [[Path objectsWithPredicate:predicate] firstObject];
//        [realm commitWriteTransaction];
//        if (completionBlock) {
//            completionBlock(path);
//        }
//    });
//}

- (Path *)currentPath
{
    dispatch_sync(self.serialQueue, ^{
                RLMRealm *realm = [RLMRealm defaultRealm];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updatedAt = %@", nil];
                [realm beginWriteTransaction];
                self.path = [[Path objectsWithPredicate:predicate] firstObject];
                [realm commitWriteTransaction];
            });
    
    return self.path;
    
    
//    return [[Path objectsWithPredicate:[NSPredicate predicateWithFormat:@"updatedAt = %@", nil]] firstObject];
}

//- (void)saveData:(NSDictionary *)data
//{
//    
//#warning SERGEY TO DO: save Data haven't done yet
//    
//    dispatch_async(self.serialQueue, ^{
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        Path *path = [[Path alloc] init];
//        path.name = [data valueForKey:@"name"];
//        path.comment = [data valueForKey:@"comment"];
//        path.coordinates = [data valueForKey:@"points"];
//        
////                route.duration = [data valueForKey:@"duration"];
//        
//        [realm commitWriteTransaction];
//    });
//}

- (void)addObject:(RLMObject *)object
{
//    if ([object isKindOfClass:[LocationCoordinate class]]) {
        dispatch_async(self.serialQueue, ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:object];
            [realm commitWriteTransaction];
        });
//    }
//    
//    if ([object isKindOfClass:[Path class]]) {
//        dispatch_async(dispatch_queue_create("queue", 0), ^{
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            [realm beginWriteTransaction];
//            [realm addObject:object];
//            [realm commitWriteTransaction];
//        });
//    }
//    
//    if ([object isKindOfClass:[User class]]) {
//        dispatch_async(dispatch_queue_create("queue", 0), ^{
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            [realm beginWriteTransaction];
//            [realm addObject:(User *)object];
//            [realm commitWriteTransaction];
//        });
//    }
//    
//    else {
//        // Failed
//    }
}

- (void)updateObject:(RLMObject *)object
{
    dispatch_async(self.serialQueue, ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:object];
        [realm commitWriteTransaction];
    });

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
