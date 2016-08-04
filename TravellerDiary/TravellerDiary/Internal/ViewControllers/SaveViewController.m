#import "SaveViewController.h"
#import <Chameleon.h>
#import "DatabaseProvider.h"
#import "Path.h"
#import <ORStackView/ORStackScrollView.h>
#import <Masonry/Masonry.h>

#import "DeletableImageView.h"

#import "UIColor+HexString.h"


static const CGFloat kImagesContainerViewHeight = 60.0f;


@interface SaveViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) NSMutableArray<UIImage *> *images;
@property (nonatomic) DatabaseProvider *datebaseProvider;
@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) IBOutlet UIButton *addPhotoButton;
@property (nonatomic) IBOutlet UIButton *sharedButton;
@property (weak, nonatomic) IBOutlet UIView *buttonSubView;
@property (nonatomic) IBOutlet NSLayoutConstraint *imagesContainerViewHeightConstraint;

@property (nonatomic) BOOL shared;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet ORStackScrollView *imagesContainerView;
@property (nonatomic) GMSPolyline *polyline;

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight];

    if (!self.saveMode) {
        //  запросить маршрут и его точки
        
        self.nameTextField.userInteractionEnabled = NO;
        self.commentTextView.userInteractionEnabled = NO;
        
        self.buttonSubView.hidden = YES;
        self.addPhotoButton.hidden = YES;
    }
    
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:self.path];
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds];
    
    [self.mapView animateWithCameraUpdate:cameraUpdate];
    
    self.polyline = [GMSPolyline polylineWithPath:self.path];
    self.polyline.map = self.mapView;
    
    self.shared = YES;
    self.images = [NSMutableArray array];
    self.datebaseProvider = [DatabaseProvider sharedInstance];
    
    self.imagesContainerViewHeightConstraint.constant = 0.0f;
    self.imagesContainerView.stackView.direction = ORStackViewDirectionHorizontal;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                                                      withFrame:self.view.bounds
                                                      andColors:@[[UIColor mainThemeColor], [UIColor flatYellowColor]]];
}

- (IBAction)tapOnSaveButton:(id)sender
{
    Path *path = [[Path alloc] init];
    path.name = self.nameTextField.text;
    path.comment = self.commentTextView.text;
    path.createdAt = [[self.datebaseProvider currentPath] createdAt];
    path.updatedAt = [NSDate date];
    path.shared = self.shared;
    path.distance = self.distance;
    path.duration = self.duration;
    
    [self.datebaseProvider updateObject:path];
    [self.delegate didCloseViewController:self];
}

- (IBAction)tapOnCancelButton:(id)sender
{
    [self.delegate didCloseViewController:self];
}

- (IBAction)tapOnSharedButton:(id)sender
{
    self.shared = !self.shared;
    if (self.shared) {
        [self.sharedButton setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    }
    else {
        [self.sharedButton setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    }
}

- (IBAction)selectPhotos:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self addImageOnStackView:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addImageOnStackView:(UIImage *)image
{
    if (self.images.count == 0) {
        self.imagesContainerViewHeightConstraint.constant = kImagesContainerViewHeight;
    }
    
    [self.images addObject:image];
    
    DeletableImageView *imageView = [DeletableImageView instantiate];
    imageView.imageView.image = image;
    
    __weak typeof(self) wself = self;
    imageView.deleteBlock = ^(DeletableImageView *imageView) {
        [wself removeImageViewFromStack:imageView];
    };
    imageView.selectBlock = ^(DeletableImageView *imageView) {
        
    };
    
    [self.imagesContainerView.stackView addSubview:imageView withPrecedingMargin:0.0f sideMargin:0.0f];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kImagesContainerViewHeight));
        make.height.equalTo(@(kImagesContainerViewHeight));
    }];
}

- (void)removeImageViewFromStack:(DeletableImageView *)imageView
{
    [self.images removeObject:imageView.imageView.image];
    [self.imagesContainerView.stackView removeSubview:imageView];
    
    if (self.images.count == 0) {
        self.imagesContainerViewHeightConstraint.constant = 0.0f;
    }
}

@end
