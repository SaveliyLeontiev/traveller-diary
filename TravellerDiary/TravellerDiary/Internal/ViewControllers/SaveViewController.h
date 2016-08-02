#import <UIKit/UIKit.h>
#import "SaveViewControllerDelegate.h"

@interface SaveViewController : UIViewController

@property (nonatomic) id<SaveViewControllerDelegate> delegate;

@end
