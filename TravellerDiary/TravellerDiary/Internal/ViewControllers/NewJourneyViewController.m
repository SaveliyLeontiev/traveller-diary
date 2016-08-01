#import "NewJourneyViewController.h"
#import "LocationManager.h"
#import "InteractorDelegate.h"
#import "Interactor.h"
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

const NSInteger kDelta = - 100; // subtraction of initialTopViewHeight from minimum topViewHeight

@interface NewJourneyViewController () <InteractorDelegate>

@property (nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *proportionalHeightConstraint;
@property (nonatomic) BOOL firstLayout;
@property (nonatomic) CGFloat initialTopViewHeight;
@property (nonatomic) CGFloat currentTopViewHeight;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) CGFloat delta; // currentPoint - startPoint

@property (nonatomic) IBOutlet UIView *topSubview;
@property (nonatomic) IBOutlet UIView *bottomSubview;

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic) GMSMapView *mapView;
@property (nonatomic) GMSCameraPosition *camera;
@property (nonatomic) GMSMutablePath *path;
@property (nonatomic) GMSPolyline *route;

@property (nonatomic) Interactor *interactor;
//@property (nonatomic) LocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocationCoordinate;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger timeSec;
@property (nonatomic) NSInteger timeMin;
@property (nonatomic) NSInteger timeHour;
@property (nonatomic) NSInteger timeDay;

@end

@implementation NewJourneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interactor = [[Interactor alloc] init];
    self.interactor.locationManager = [[LocationManager alloc] init];
    self.interactor.locationManager.delegate = self.interactor;
    self.interactor.databaseProvider = [[DatabaseProvider alloc] init];
    self.interactor.delegate = self;
    
    self.firstLayout = YES;
    self.camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:self.bottomSubview.bounds camera:self.camera];
    self.mapView.myLocationEnabled = YES;
    [self.bottomSubview addSubview:self.mapView];
    
    self.path = [GMSMutablePath path];
    self.route = [GMSPolyline polylineWithPath:self.path];
    
    // Timer Initialization
    self.timeSec = 0;
    self.timeMin = 0;
    self.timeHour = 0;
    self.timeDay = 0;
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
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
          
#warning SERGEY TO DO: update incorrectly
            
            self.mapView.bounds = self.bottomSubview.bounds;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            if (self.delta < kDelta) {
                self.currentTopViewHeight = 100;
            } else {
                self.currentTopViewHeight = self.initialTopViewHeight;
            }

#warning SERGEY TO DO: set alpha value

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
    self.timeSec++;
    
    if (self.timeSec == 60) {
        self.timeSec = 0;
        self.timeMin++;
    }
    
    NSString* timeNow = [NSString stringWithFormat:@"%02ld:%02ld", (long)self.timeMin, (long)self.timeSec];
    
    if (self.timeMin == 60) {
        self.timeMin = 0;
        self.timeHour++;
        timeNow = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)self.timeHour, (long)self.timeMin, (long)self.timeSec];
    }
    
    if (self.timeHour == 24) {
        self.timeHour = 0;
        self.timeDay++;
        timeNow = [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld", (long)self.timeDay, (long)self.timeHour, (long)self.timeMin, (long)self.timeSec];
    }
    
    self.timeLabel.text= timeNow;
}

#pragma mark - Action

- (IBAction)didTapOnButton:(UIButton *)sender
{
    if (sender.selected) {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.interactor startMonitoringSignificantLocationChanges];
    }
    else {
        [self.timer invalidate];
        [self.interactor stopMonitoringSignificantLocationChanges];
        
#warning SERGEY TO DO: save path to db
         
    }
}

#pragma mark - InteractorDelegate

- (void)didChangeLocation:(CLLocation *)currentLocation;
{
    self.currentLocationCoordinate = currentLocation.coordinate;
    [self.path addCoordinate:self.currentLocationCoordinate];
    self.camera = [GMSCameraPosition cameraWithLatitude:self.currentLocationCoordinate.latitude
                                              longitude:self.currentLocationCoordinate.longitude
                                                   zoom:15];
    
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setCamera:self.camera];
    [self.mapView moveCamera:cameraUpdate];
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

@end
