#import "NewJourneyViewController.h"
#import "LocationManager.h"
#import "NewJourneyManagerDelegate.h"
#import "NewJourneyManager.h"
#import "SaveViewController.h"
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

const NSInteger kDelta = - 100; // subtraction of initialTopViewHeight from minimum topViewHeight

@interface NewJourneyViewController () <NewJourneyManagerDelegate, SaveViewControllerDelegate>

@property (nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *proportionalHeightConstraint;
@property (nonatomic) BOOL firstLayout;
@property (nonatomic) CGFloat initialTopViewHeight;
@property (nonatomic) CGFloat currentTopViewHeight;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) CGFloat delta; // currentPoint - startPoint

@property (nonatomic) IBOutlet UIView *topSubview;

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) GMSCameraPosition *camera;
@property (nonatomic) GMSCameraUpdate *cameraUpdate;
@property (nonatomic) GMSMutablePath *path;
@property (nonatomic) GMSPolyline *polyline;

@property (nonatomic) NewJourneyManager *journeyManager;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;
@property (nonatomic) CLLocation* previousLocation;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) SaveViewController *saveViewController;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSDate *startDate;
@end

@implementation NewJourneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.journeyManager = [[NewJourneyManager alloc] init];
    self.journeyManager.delegate = self;
    
    self.firstLayout = YES;
    
//    self.camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:0];
//    self.mapView.camera = self.camera;
//    self.mapView.myLocationEnabled = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.firstLayout) {
        self.firstLayout = NO;
        
        self.proportionalHeightConstraint.priority = UILayoutPriorityDefaultLow;
        self.initialTopViewHeight = self.topSubview.bounds.size.height;
        self.topViewHeightConstraint.priority = UILayoutPriorityDefaultHigh + 1;
        self.topViewHeightConstraint.constant = self.initialTopViewHeight;
        self.currentTopViewHeight = self.initialTopViewHeight;
    }
}

- (IBAction)panGestureRecognigezrDidChange:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.startPoint = [sender locationInView:sender.view];
            break;
            
        case UIGestureRecognizerStateChanged:
            self.currentPoint = [sender locationInView:sender.view];
            self.delta = self.currentPoint.y - self.startPoint.y;
            self.topViewHeightConstraint.constant = self.currentTopViewHeight;
            
            self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + self.delta;
          
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            if (self.delta < kDelta) {
                self.currentTopViewHeight = 100;
            } else {
                self.currentTopViewHeight = self.initialTopViewHeight;
            }

            [UIView animateWithDuration:0.3 animations:^{
                self.topViewHeightConstraint.constant = self.currentTopViewHeight;
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)handleTimer:(NSTimer *)timer
{
    self.duration = [[NSDate date] timeIntervalSinceDate:self.startDate];
    
    NSInteger days = self.duration / 60 / 60 / 24;
    NSInteger hours = self.duration / 60 / 60;
    NSInteger minutes = self.duration / 60;
    NSInteger seconds = (NSInteger)self.duration % 60;
    
    NSString *timeString;
    
    if (days != 0) {
        timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld",
                   (long)days, (long)hours, (long)minutes, (long)seconds];
    }
    else if (hours != 0) {
        timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                      (long)hours, (long)minutes, (long)seconds];
    }
    else {
        timeString = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    
    self.timeLabel.text = timeString;
}

#pragma mark - Action

- (IBAction)didTapOnButton:(UIButton *)sender
{
    if (sender.highlighted) {
        [sender setSelected:!sender.selected];
        if (sender.selected) {
//            [self default];
            
//            self.mapView.camera = self.camera;
            self.mapView.myLocationEnabled = YES;
//            self.polyline = nil;
//
            self.path = [GMSMutablePath path];
            self.polyline = [GMSPolyline polylineWithPath:self.path];
            self.polyline.strokeWidth = 5;
            self.polyline.map = self.mapView;
            
//            self.duration = 0;
//            self.previousLocation = 0;
            
            self.startDate = [NSDate date];
            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            [self.journeyManager startMonitoringSignificantLocationChanges];
        }
        else {
//            self.timeLabel.text = @"00:00";
//            self.distanceLabel.text = @"0.00 m";
            
            [self.timer invalidate];
            [self.journeyManager stopMonitoringSignificantLocationChanges];
//            self.polyline.map = nil;
            
            self.saveViewController = (SaveViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"saveViewContollerID"];
            self.saveViewController.delegate = self;
            self.saveViewController.path = self.path;
            self.saveViewController.distance = self.distance;
            self.saveViewController.duration = self.duration;
            
//            self.path = nil;
//            self.distance = 0;
            
//            [self default];
//            [super dealloc];

            [self presentViewController:self.saveViewController animated:YES completion:nil];
        }
    }
}

#pragma mark - NewJourneyManagerDelegate

- (void)didChangeLocation:(CLLocation *)currentLocation;
{
    self.currentLocationCoordinate = currentLocation.coordinate;
    [self.path addCoordinate:self.currentLocationCoordinate];
    self.polyline.path = self.path;
//    self.polyline = [GMSPolyline polylineWithPath:self.path];
    self.polyline.map = self.mapView;
//    [self.polyline setPath:self.path];
    self.camera = [GMSCameraPosition cameraWithLatitude:self.currentLocationCoordinate.latitude
                                              longitude:self.currentLocationCoordinate.longitude
                                                   zoom:15];
    
    self.cameraUpdate = [GMSCameraUpdate setCamera:self.camera];
    [self.mapView moveCamera:self.cameraUpdate];
    [self countCurrentDistance:(CLLocation *)currentLocation];
    self.previousLocation = currentLocation;

}

- (void)monitoringSignificantLocationChangesFailedWithError:(NSString *)errorDescription
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {}];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)countCurrentDistance:(CLLocation *)currentLocation
{
    self.distance += [currentLocation distanceFromLocation:self.previousLocation];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f m", self.distance];
}

#pragma mark - SaveViewControllerDelegate

- (void)didCloseViewController:(SaveViewController *)saveViewController
{
//    self.polyline.map = nil;
//    self.polyline = nil;
//    self.path = nil;
//    self.camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:0];
//    self.mapView.camera = self.camera;
//    self.mapView.myLocationEnabled = YES;
    [self default];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)default
{
    self.timeLabel.text = @"00:00";
    self.distanceLabel.text = @"0.00 m";
    self.path = nil;
    self.polyline.map = nil;
    self.polyline = nil;
    self.mapView = nil;
    self.camera = nil;
    self.cameraUpdate = nil;
    self.previousLocation = nil;
    self.distance = 0;
}

@end
