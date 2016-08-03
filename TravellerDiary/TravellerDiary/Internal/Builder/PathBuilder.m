#import "PathBuilder.h"
#import "Utility.h"

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
    path.id = [Utility intValueFromNum:dict[kPathId]];
    path.name = dict[kPathName];
    path.userId = [Utility intValueFromNum:dict[kPathUserId]];
    path.comment = dict[kPathComment];
    path.rating = [Utility intValueFromNum:dict[kPathRating]];
    path.createdAt = [self.dateFormater dateFromString:dict[kPathCreateAt]];
    path.updatedAt = [self.dateFormater dateFromString:dict[kPathUpdateAt]];
    path.shared = [Utility boolValueFromNum:dict[kPathShared]];
    path.duration = [Utility intValueFromNum:dict[kPathDuration]];
    path.distance = [Utility intValueFromNum:dict[kPathDistance]];
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
