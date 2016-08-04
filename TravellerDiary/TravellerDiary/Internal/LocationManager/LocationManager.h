#import <INTULocationManager/INTULocationManager.h>
#import "LocationManagerDelegate.h"


@interface LocationManager : INTULocationManager

@property (nonatomic) id<LocationManagerDelegate> delegate;
@property (assign, nonatomic) INTULocationAccuracy desiredAccuracy;

- (void)startMonitoringSignificantLocationChanges;
- (void)stopMonitoringSignificantLocationChanges;

- (void)startSingleLocationRequest;


@end
