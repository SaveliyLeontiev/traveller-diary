#import "AppDelegate.h"
#import "UIColor+HexString.h"
#import <AFNetworking/AFNetworking.h>
#import "TabBarController.h"
#import "LoginAPIManager.h"
#import "LoginController.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupAppearance];
    [GMSServices provideAPIKey:@"AIzaSyCIJ_snk-Zs7hFmzEIOVn4wasDdP91wpLI"];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if ([LoginController isLogined]) {
        [[LoginAPIManager sharedInstance] logInWithEmail:[LoginController email] password:[LoginController password] success:^{
        } failure:nil];
        TabBarController *tabBarController =
        [[TabBarController alloc] initWithTabIconNames:@[@"Popular",
                                                         @"ClosestJourney",
                                                         @"NewJourney",
                                                         @"History",
                                                         @"Settings"]];
        [UIApplication sharedApplication].delegate.window.rootViewController = tabBarController;
    }
    
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor mainThemeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

@end
