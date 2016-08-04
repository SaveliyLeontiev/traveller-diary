#import <UIKit/UIKit.h>


@interface DeletableImageView : UIView

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, copy) void(^deleteBlock)(DeletableImageView *imageView);
@property (nonatomic, copy) void(^selectBlock)(DeletableImageView *imageView);

+ (instancetype)instantiate;

@end
