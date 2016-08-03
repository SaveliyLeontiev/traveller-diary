#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic) INTULocationManager *locationManager;
@property (assign, nonatomic) INTULocationRequestID locationRequestID;

@end

@implementation LocationManager

- (NSString *)getLocationErrorDescription:(INTULocationStatus)status
{
    if (status == INTULocationStatusServicesNotDetermined) {
        return @"Error: User has not responded to the permissions alert.";
    }
    if (status == INTULocationStatusServicesDenied) {
        return @"Error: User has denied this app permissions to access device location.";
    }
    if (status == INTULocationStatusServicesRestricted) {
        return @"Error: User is restricted from using location services by a usage policy.";
    }
    if (status == INTULocationStatusServicesDisabled) {
        return @"Error: Location services are turned off for all apps on this device.";
    }
    return @"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)";
}

- (void)startMonitoringSignificantLocationChanges
{
    __weak __typeof(self) weakSelf = self;
    weakSelf.locationManager = [INTULocationManager sharedInstance];
    
    self.locationRequestID = [weakSelf.locationManager subscribeToSignificantLocationChangesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __typeof(weakSelf) strongSelf = weakSelf;
        
        if (status == INTULocationStatusSuccess) {
            NSLog(@"%f, %f, %@", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, currentLocation.description);
            [strongSelf.delegate didChangeLocation:currentLocation];
        }
        else {
            [strongSelf.delegate monitoringSignificantLocationChangesFailedWithError:[strongSelf getLocationErrorDescription:status]];
        }
    }];
}

- (void)stopMonitoringSignificantLocationChanges
{
    [self.locationManager forceCompleteLocationRequest:self.locationRequestID];
}


@end
