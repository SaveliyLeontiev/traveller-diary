#import <UIKit/UIKit.h>

@interface PathCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *cover;

@property (nonatomic) CGFloat rate;

@end
