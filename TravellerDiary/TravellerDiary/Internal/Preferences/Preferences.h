#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AccuracyType) {
    kCityAccuracyType = 0,
    kNeighborhoodAccuracyType = 1,
    kBlockAccuracyType = 2,
    kHomeAccuracyType = 3,
    kRoomAccuracyType = 4
};

@interface Preferences : NSObject

+ (AccuracyType)accuracyType;
+ (void)setAccuracyTypeWithType:(AccuracyType)type;

@end
