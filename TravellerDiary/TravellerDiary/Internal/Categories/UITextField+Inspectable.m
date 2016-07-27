#import "UITextField+Inspectable.h"

@implementation UITextField (Inspectable)

@dynamic localizedString;

- (void)setLocalizedString:(NSString *)localizedString
{
    self.placeholder = NSLocalizedString(localizedString,);
}

@end
