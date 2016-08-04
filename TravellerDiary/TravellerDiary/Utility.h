#import <Foundation/Foundation.h>

static NSString *const kUserId = @"id";
static NSString *const kUserFirstName = @"first_name";
static NSString *const kUserLastName = @"last_name";
static NSString *const kUserEmail = @"email";
static NSString *const kUserAvatar = @"avatar";
static NSString *const kUserCreatedAt = @"created_at";
static NSString *const kUserUpdatedAt = @"updated_at";

static NSString *const kPathId = @"id";
static NSString *const kPathName = @"name";
static NSString *const kPathUserId = @"user_id";
static NSString *const kPathComment = @"description";
static NSString *const kPathRating = @"rating";
static NSString *const kPathCreateAt = @"created_at";
static NSString *const kPathUpdateAt = @"updated_at";
static NSString *const kPathDistance = @"distance";
static NSString *const kPathDuration = @"duration";
static NSString *const kPathShared = @"shared";

static NSString *const kPointId = @"id";
static NSString *const kPointPathId = @"path_id";
static NSString *const kPointUserId = @"user_id";
static NSString *const kPointLongitude = @"longitude";
static NSString *const kPointLatitude = @"latitude";
static NSString *const kPointCreatedAt = @"created_at";

static NSString *const kPhotoFile = @"imageFiles";
static NSString *const kPhotoPathId = @"path_id";
static NSString *const kPhotoPointId = @"point_id";



@interface Utility : NSObject

+ (NSInteger)intValueFromNum:(NSNumber *)num;
+ (BOOL)boolValueFromNum:(NSNumber *)num;
+ (float)floatValueFromNum:(NSNumber *)num;

@end
