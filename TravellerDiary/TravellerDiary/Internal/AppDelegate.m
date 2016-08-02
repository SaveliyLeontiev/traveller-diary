#import "AppDelegate.h"
#import "UIColor+HexString.h"
@import GoogleMaps;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyCIJ_snk-Zs7hFmzEIOVn4wasDdP91wpLI"];
    [self setupAppearance];
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor mainThemeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

@end
