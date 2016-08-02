#import "AppDelegate.h"
#import "UIColor+HexString.h"
#import <AFNetworking/AFNetworking.h>

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupAppearance];
    [GMSServices provideAPIKey:@"AIzaSyCgkgAovPuySt7M8m2zZ4fTRiSF1gPe6mo"];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor mainThemeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

@end
