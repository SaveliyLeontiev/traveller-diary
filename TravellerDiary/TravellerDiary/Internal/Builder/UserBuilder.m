#import "UserBuilder.h"
#import "Keys.h"

@interface UserBuilder ()

@property (nonatomic) NSDateFormatter *dateFormater;

@end

@implementation UserBuilder

- (instancetype)init
{
    if (self = [super init]) {
        _dateFormater = [[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _dateFormater.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    return self;
}

- (User *)userWithDictionary:(NSDictionary *)dict
{
    User *user = [[User alloc] init];
    NSNumber *obj = dict[kUserId];
    user.userId = obj.intValue;
    user.firstName = dict[kUserFirstName];
    user.lastName = dict[kUserLastName];
    user.email = dict[kUserEmail];
    user.avatar = dict[kUserAvatar];
    user.createDate = [self.dateFormater dateFromString:dict[kUserCreatedAt]];
    user.updateDate = [self.dateFormater dateFromString:dict[kUserUpdatedAt]];
    return user;
}

@end
