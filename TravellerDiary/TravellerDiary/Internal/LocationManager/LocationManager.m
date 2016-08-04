#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic) INTULocationManager *locationManager;
@property (assign, nonatomic) INTULocationRequestID locationRequestID;
@property (nonatomic) BOOL lowEnergyMode;

@end

@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lowEnergyMode = NO;
        _desiredAccuracy = INTULocationAccuracyCity;
    }
    return self;
}

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
    if (status == INTULocationStatusTimedOut) {
        return @"Location request timed out.";
    }
    return @"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)";
}

- (void)startSingleLocationRequest
{
    __weak __typeof(self) weakSelf = self;
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    self.locationRequestID = [locMgr requestLocationWithDesiredAccuracy:self.desiredAccuracy
                                                                timeout:5.0
                                                   delayUntilAuthorized:YES
                                                                  block:
                              ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                  __typeof(weakSelf) strongSelf = weakSelf;
                                  
                                  if (status == INTULocationStatusSuccess) {
                                      [strongSelf.delegate location:currentLocation];
                                  }
                                  else {
                                      [strongSelf.delegate monitoringSignificantLocationChangesFailedWithError:[strongSelf getLocationErrorDescription:status]];
                                  }
                                  strongSelf.locationRequestID = NSNotFound;
                              }];
}

- (void)startMonitoringSignificantLocationChanges
{
    if (self.lowEnergyMode) {
        __weak __typeof(self) weakSelf = self;
        self.locationManager = [INTULocationManager sharedInstance];
        
        self.locationRequestID = [self.locationManager subscribeToSignificantLocationChangesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
            __typeof(weakSelf) strongSelf = weakSelf;
            
            if (status == INTULocationStatusSuccess) {
                [strongSelf.delegate didChangeLocation:currentLocation];
            }
            else {
                [strongSelf.delegate monitoringSignificantLocationChangesFailedWithError:[strongSelf getLocationErrorDescription:status]];
            }
        }];
    } else {
        __weak __typeof(self) weakSelf = self;
        self.locationManager = [INTULocationManager sharedInstance];
        
        self.locationRequestID = [self.locationManager subscribeToLocationUpdatesWithDesiredAccuracy:self.desiredAccuracy block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
            __typeof(weakSelf) strongSelf = weakSelf;
            
            if (status == INTULocationStatusSuccess) {
                [strongSelf.delegate didChangeLocation:currentLocation];
            }
            else {
                [strongSelf.delegate monitoringSignificantLocationChangesFailedWithError:[strongSelf getLocationErrorDescription:status]];
            }
        }];
    }
}

- (void)stopMonitoringSignificantLocationChanges
{
    [self.locationManager cancelLocationRequest:self.locationRequestID];
}


@end
