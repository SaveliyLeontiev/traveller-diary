#import <Foundation/Foundation.h>
#import "NewJourneyManagerDelegate.h"
#import "LocationManagerDelegate.h"
#import "LocationManager.h"
#import "DatabaseProvider.h"

@interface NewJourneyManager : NSObject <LocationManagerDelegate>

@property (nonatomic) id<NewJourneyManagerDelegate> delegate;
@property (nonatomic) LocationManager *locationManager;
@property (nonatomic) NSDate *startDate;

- (void)startMonitoringSignificantLocationChanges;
- (void)stopMonitoringSignificantLocationChanges;
- (void)currentLocation;

@end
