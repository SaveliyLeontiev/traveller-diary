#import "UIButton+Inspectable.h"

@implementation UIButton (Inspectable)

@dynamic localizedString;
@dynamic cornerRadius;

- (void)setLocalizedString:(NSString *)localizedString
{
    [self setTitle:NSLocalizedString(localizedString, ) forState:UIControlStateNormal];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

@end
