#import "AppDelegate.h"
#import "UIColor+HexString.h"
#import <AFNetworking/AFNetworking.h>
#import "LoginController.h"
#import "TabBarController.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupAppearance];
    [GMSServices provideAPIKey:@"AIzaSyCgkgAovPuySt7M8m2zZ4fTRiSF1gPe6mo"];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    LoginController *loginController = [[LoginController alloc] init];
    if ([loginController isLogined]) {
        TabBarController *tabBarController =
        [[TabBarController alloc] initWithTabIconNames:@[@"Popular",
                                                         @"ClosestJourney",
                                                         @"NewJourney",
                                                         @"History",
                                                         @"Settings"]];
        [UIApplication sharedApplication].delegate.window.rootViewController = tabBarController;
    }
    else {
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil];
        UINavigationController *navigationController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginID"];
        [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
    }
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor mainThemeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

@end
