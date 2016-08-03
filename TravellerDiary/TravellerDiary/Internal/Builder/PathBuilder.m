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
    NSNumber *numValue = dict[kPathId];
    path.id = numValue.integerValue;
    path.name = dict[kPathName];
    numValue = dict[kPathUserId];
    path.userId = numValue.integerValue;
    path.comment = dict[kPathComment];
    //numValue = dict[kPathRating];
    //path.rating = numValue.integerValue;
    path.createdAt = [self.dateFormater dateFromString:dict[kPathCreateAt]];
    path.updatedAt = [self.dateFormater dateFromString:dict[kPathUpdateAt]];
    numValue = dict[kPathShared];
    path.shared = numValue.boolValue;
    //numValue = dict[kPathDuration];
    //path.duration = numValue.integerValue;
    //numValue = dict[kPathDistance];
    //path.distance = numValue.integerValue;
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

@end
