#import "UILabel+Inspectable.h"

@implementation UILabel (Inspectable)

@dynamic localizedString;

- (void)setLocalizedString:(NSString *)localizedString
{
    self.text = NSLocalizedString(localizedString, );
}

@end
