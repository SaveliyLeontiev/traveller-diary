#import "UINavigationItem+Inspectable.h"

@implementation UINavigationItem (Inspectable)

@dynamic localizedString;

- (void)setLocalizedString:(NSString *)localizedString
{
    self.title = NSLocalizedString(localizedString, );
}

@end
