#import "PathBuilder.h"
#import "Keys.h"

@interface PathBuilder ()

@property (nonatomic) NSDateFormatter *dateFormater;

@end

@implementation PathBuilder

- (instancetype)init
{
    if (self = [super init]) {
        _dateFormater = [[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _dateFormater.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    return self;
}

- (Path *)pathWithDictionary:(NSDictionary *)dict
{
    Path *path = [[Path alloc] init];
    path.id = [self intValueFromNum:dict[kPathId]];
    path.name = dict[kPathName];
    path.userId = [self intValueFromNum:dict[kPathUserId]];
    path.comment = dict[kPathComment];
    path.rating = [self intValueFromNum:dict[kPathRating]];
    path.createdAt = [self.dateFormater dateFromString:dict[kPathCreateAt]];
    path.updatedAt = [self.dateFormater dateFromString:dict[kPathUpdateAt]];
    path.shared = [self boolValueFromNum:dict[kPathShared]];
    path.duration = [self intValueFromNum:dict[kPathDuration]];
    path.distance = [self intValueFromNum:dict[kPathDistance]];
    return path;
}

- (NSArray *)pathesWithArray:(NSArray<NSDictionary *> *)array
{
    NSMutableArray *pathes = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [pathes addObject:[self pathWithDictionary:dict]];
    }
    return [pathes copy];
}

- (NSInteger)intValueFromNum:(NSNumber *)num;
{
    if (![num isEqual:[NSNull null]]) {
        return num.integerValue;
    }
    else {
        return 0;
    }
}

- (BOOL)boolValueFromNum:(NSNumber *)num
{
    if (![num isEqual:[NSNull null]]) {
        return num.boolValue;
    }
    else {
        return NO;
    }
}

@end
