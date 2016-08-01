#import <Foundation/Foundation.h>
#import "InteractorDelegate.h"
#import "LocationManagerDelegate.h"
#import "LocationManager.h"
#import "DatabaseProvider.h"

@interface Interactor : NSObject <LocationManagerDelegate>

@property (nonatomic) id<InteractorDelegate> delegate;
@property (nonatomic) LocationManager *locationManager;
@property (nonatomic) DatabaseProvider *databaseProvider;

- (void)startMonitoringSignificantLocationChanges;
- (void)stopMonitoringSignificantLocationChanges;
- (void)saveData:(NSDictionary *)data; // dict contains array 'paths', 'time', 'distance', 'photo_url' (in future)

@end
