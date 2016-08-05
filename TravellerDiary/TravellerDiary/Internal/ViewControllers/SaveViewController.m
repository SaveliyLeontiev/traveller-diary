#import "SaveViewController.h"
#import <Chameleon.h>
#import "DatabaseProvider.h"
#import "Path.h"
#import <ORStackView/ORStackScrollView.h>
#import <Masonry/Masonry.h>

#import "DeletableImageView.h"

#import "UIColor+HexString.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageDownloader.h"
#import "PathManager.h"

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



@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet ORStackScrollView *imagesContainerView;
@property (nonatomic) GMSPolyline *polyline;

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic) PathManager *pathManager;

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pathManager = [[PathManager alloc] init];
    self.view.backgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight];
    self.pathRating = 0;
    self.images = [NSMutableArray array];

    if (!self.saveMode) {
        
        self.nameTextField.userInteractionEnabled = NO;
        self.commentTextView.userInteractionEnabled = NO;
        
        self.buttonSubView.hidden = YES;
        self.addPhotoButton.hidden = YES;
        for (UIButton *button in self.buttons) {
            button.enabled = NO;
        }
        self.nameTextField.text = self.pathName;
        self.commentTextView.text = self.comment;
        self.pathRating = self.pathCurrentrating;
        
        [self.pathManager getPathToMapWithPathId:self.pathId success:^(NSArray<LocationCoordinate *> *points) {
            self.path = [GMSMutablePath path];
            for (int i = 0; i < points.count; i++) {
                [self.path addLatitude:points[i].latitude longitude:points[i].longitude];
            }
            GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:self.path];
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds];
            
            [self.mapView animateWithCameraUpdate:cameraUpdate];
            
            self.polyline.path = self.path;
            dispatch_group_t group = dispatch_group_create();
            for (NSString *photoName in self.photoNames) {
                dispatch_group_enter(group);
                NSString *imageURL = [NSString stringWithFormat:@"http://api.photowalker.demo.school.noveogroup.com/photo/get/%@",photoName];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
                [[[UIImageView alloc] init] setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
                 {

                     [self addImageOnStackView:image];
                      dispatch_group_leave(group);
                     
                 } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                     __unused NSInteger i=0;
                     
                 }];
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    
                });
            }
        } failure:^(NSString *errorMessage) {
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle", )
                                                message:errorMessage
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
    
    if (self.shared) {
        [self.sharedButton setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    }
    else {
        [self.sharedButton setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    }
    
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:self.path];
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds];
    
    [self.mapView animateWithCameraUpdate:cameraUpdate];
    
    self.polyline = [GMSPolyline polylineWithPath:self.path];
    self.polyline.strokeWidth = 5;
    self.polyline.map = self.mapView;
    
    self.shared = NO;
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

- (void)setPathRating:(float)pathRating
{
    _pathRating = pathRating;
    NSArray <UIImageView *> *sortedStars = [self.stars sortedArrayUsingComparator:^NSComparisonResult(UITextField *obj1, UITextField *obj2) {
        return [@(obj1.tag) compare:@(obj2.tag)];
    }];
    for (NSInteger i = 0; i < 5; i++) {
        if (pathRating >= 1) {
            sortedStars[i].image = [UIImage imageNamed:@"starWithFrame"];
        }
        else {
            sortedStars[i].image = [UIImage imageNamed:@"star_gray"];
        }
        pathRating--;
    }
}

- (IBAction)tapOnStar:(id)sender
{
    UIButton *star = sender;
    self.pathRating = star.tag + 1;
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
    path.rating = self.pathRating;
    
    [self.datebaseProvider updateObject:path];
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.path.count; i++) {
        LocationCoordinate *locationCoordinate = [[LocationCoordinate alloc] init];
        locationCoordinate.latitude = [self.path coordinateAtIndex:i].latitude;
        locationCoordinate.longitude = [self.path coordinateAtIndex:i].longitude;
        locationCoordinate.path = path;
        locationCoordinate.date = [NSDate date];
        [points addObject:locationCoordinate];
//        [self.datebaseProvider updateObject:locationCoordinate];
    }
    
    [self.pathManager postPath:path points:[points copy] photos:self.images success:^{
        [self.delegate didCloseViewController:self];
    } failure:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

- (IBAction)tapOnCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.delegate didCloseViewController:self];
}

- (IBAction)tapOnSharedButton:(id)sender
{
    if (self.shared) {
        [self.sharedButton setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        self.shared = NO;
    }
    else {
        [self.sharedButton setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
        self.shared = YES;
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
