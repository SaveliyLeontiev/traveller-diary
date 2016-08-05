#import <UIKit/UIKit.h>
#import "SaveViewControllerDelegate.h"

@import GoogleMaps;

@interface SaveViewController : UIViewController

@property (nonatomic) id<SaveViewControllerDelegate> delegate;
@property (nonatomic) GMSMutablePath *path;
@property (nonatomic) NSInteger pathId;
@property (nonatomic) NSString *pathName;
@property (nonatomic) float pathRating;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSInteger distance;
@property (nonatomic) NSString *comment;
@property (nonatomic) BOOL shared;
@property (nonatomic) BOOL saveMode;

@end
