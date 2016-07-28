#import "UITabBarItem+Inspectable.h"

@implementation UITabBarItem (Inspectable)

@dynamic localizedString;

- (void)setLocalizedString:(NSString *)localizedString
{
    self.title = NSLocalizedString(localizedString, );
}

@end
