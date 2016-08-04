#import <UIKit/UIKit.h>
#import "SaveViewControllerDelegate.h"
@import GoogleMaps;

@interface SaveViewController : UIViewController

@property (nonatomic) id<SaveViewControllerDelegate> delegate;
@property (nonatomic) GMSMutablePath *path;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL saveMode;

@end
