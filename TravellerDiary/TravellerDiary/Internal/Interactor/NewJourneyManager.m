#import "NewJourneyManager.h"
#import "Path.h"
#import "LocationManager.h"

@interface NewJourneyManager ()

@property (nonatomic) Path *currentPath;
@property (nonatomic) DatabaseProvider *databaseProvider;


@end

@implementation NewJourneyManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[LocationManager alloc] init];
        _locationManager.delegate = self;
        _databaseProvider = [[DatabaseProvider alloc] init];
        _currentPath = [self.databaseProvider currentPath];
    }
    return self;
}

- (void)saveCurrentLocation:(CLLocation *)currentLocation
{
    LocationCoordinate *locationCoordinate = [[LocationCoordinate alloc] init];
    locationCoordinate.longitude = currentLocation.coordinate.longitude;
    locationCoordinate.latitude = currentLocation.coordinate.latitude;
    locationCoordinate.date = [NSDate date];
    
    if (self.currentPath) {
        locationCoordinate.path = self.currentPath;
        [self.databaseProvider addObject:locationCoordinate];
//        [self.databaseProvider updateObject:self.currentPath];
    } else {
        self.currentPath = [[Path alloc] init];
        self.currentPath.createdAt = [NSDate date];
        locationCoordinate.path = self.currentPath;
        [self.databaseProvider addObject:locationCoordinate];
        [self.databaseProvider addObject:self.currentPath];
    }
}

#pragma mark - LocationManagerDelegate

- (void)didChangeLocation:(CLLocation *)currentLocation;
{
//    [self saveCurrentLocation:currentLocation];
    [self.delegate didChangeLocation:currentLocation];
}

- (void)monitoringSignificantLocationChangesFailedWithError:(NSString *)errorDescription
{
    [self.delegate monitoringSignificantLocationChangesFailedWithError:errorDescription];
}

#pragma mark - NewJourneyManager Methods

- (void)startMonitoringSignificantLocationChanges
{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringSignificantLocationChanges
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

@end