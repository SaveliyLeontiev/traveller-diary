#import <UIKit/UIKit.h>
#import "SignUpViewControllerDelegate.h"

@interface SignUpViewController : UIViewController

@property (nonatomic) id<SignUpViewControllerDelegate> delegate;

@end
