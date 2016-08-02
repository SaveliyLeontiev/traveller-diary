#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol NewJourneyManagerDelegate <NSObject>

- (void)didChangeLocation:(CLLocation *)currentLocation;
- (void)monitoringSignificantLocationChangesFailedWithError:(NSString *)errorDescription;

@end
