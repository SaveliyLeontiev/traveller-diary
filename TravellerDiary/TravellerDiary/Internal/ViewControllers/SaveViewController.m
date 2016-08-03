#import "SaveViewController.h"
#import "DatabaseProvider.h"
#import "Path.h"

@interface SaveViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) NSMutableArray<UIImage *> *images;
@property (nonatomic) DatabaseProvider *datebaseProvider;
@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic) BOOL shared;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) GMSPolyline *polyline;

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.polyline.map = nil;
    
    GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithPath:self.path];
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds];
    
    [self.mapView animateWithCameraUpdate:cameraUpdate];
    
    self.polyline = [GMSPolyline polylineWithPath:self.path];
    self.polyline.map = self.mapView;
    
    self.shared = YES;
    self.images = [NSMutableArray array];
    self.datebaseProvider = [DatabaseProvider sharedInstance];
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
    [self.images addObject:chosenImage];
    NSLog(@"Image: %@", chosenImage.description);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
