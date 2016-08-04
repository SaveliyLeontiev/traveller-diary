#import <Foundation/Foundation.h>

@class SaveViewController;

@protocol SaveViewControllerDelegate <NSObject>

- (void)didCloseViewController:(SaveViewController *)saveViewController;

@end
