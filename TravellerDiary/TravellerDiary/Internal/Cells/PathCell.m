#import "PathCell.h"

@interface PathCell ()

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;

@end

@implementation PathCell

- (void)setRate:(CGFloat)rate
{
    _rate = rate;
    NSArray <UIImageView *> *sortedStars = [self.stars sortedArrayUsingComparator:^NSComparisonResult(UITextField *obj1, UITextField *obj2) {
        return [@(obj1.tag) compare:@(obj2.tag)];
    }];
    for (NSInteger i = 0; i<5; i++) {
        if (rate >= 1) {
            sortedStars[i].image = [UIImage imageNamed:@"star_orange.png"];
        }
        else if (rate >= 0.5) {
            sortedStars[i].image = [UIImage imageNamed:@"half_star.png"];
        }
        else {
            sortedStars[i].image = [UIImage imageNamed:@"star_gray.png"];
        }
        rate--;
    }
}

@end
