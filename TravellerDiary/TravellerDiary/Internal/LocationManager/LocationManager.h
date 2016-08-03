#import <INTULocationManager/INTULocationManager.h>
#import "LocationManagerDelegate.h"


@interface LocationManager : INTULocationManager

@property (nonatomic) id<LocationManagerDelegate> delegate;

- (void)startMonitoringSignificantLocationChanges;
- (void)stopMonitoringSignificantLocationChanges;

@end
