#import "Interactor.h"

@implementation Interactor

#pragma mark - DatabaseProvider delegate



#pragma mark - LocationManagerDelegate

- (void)didChangeLocation:(CLLocation *)currentLocation;
{
    [self.delegate didChangeLocation:currentLocation];
}

- (void)monitoringSignificantLocationChangesFailedWithError:(NSString *)errorDescription
{
    [self.delegate monitoringSignificantLocationChangesFailedWithError:errorDescription];
}

#pragma mark - Interactor Methods

- (void)startMonitoringSignificantLocationChanges
{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringSignificantLocationChanges
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)saveData:(NSDictionary *)data
{
    //    [self.databaseProvider saveData:(NSDictionary *)data];
}

@end
