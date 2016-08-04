#import <Realm.h>
#import "DatabaseProvider.h"
#import "LocationCoordinate.h"
#import "Path.h"
#import "User.h"

@interface DatabaseProvider ()

@property (nonatomic) dispatch_queue_t serialQueue;
//@property (nonatomic) Path *path;

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
//        _path = [[Path alloc] init];
    }
    return self;
}

- (Path *)currentPath
{
    RLMResults<Path *> *currentPath = [[Path objectsWithPredicate:[NSPredicate predicateWithFormat:@"updatedAt = nil"]] sortedResultsUsingProperty:@"createdAt" ascending:YES];
    return [currentPath firstObject];
//    return self.path;
}

- (void)addObject:(RLMObject *)object
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:object];
    }];
}

- (void)updateObject:(RLMObject *)object
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:object];
    }];
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
