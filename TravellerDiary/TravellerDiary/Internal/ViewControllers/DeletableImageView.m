#import "DeletableImageView.h"


@interface DeletableImageView ()

@property (nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation DeletableImageView

+ (instancetype)instantiate
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DeletableImageView class]) owner:self options:nil];
    DeletableImageView *view = [subviewArray objectAtIndex:0];
    return view;
}

- (IBAction)deleteButtonTapped:(id)sender
{
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

- (IBAction)imageViewTapped:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(self);
    }
}

@end
