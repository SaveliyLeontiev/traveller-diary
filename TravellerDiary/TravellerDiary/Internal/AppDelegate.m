#import "AppDelegate.h"

#import "UIColor+HexString.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupAppearance];
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor mainThemeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

@end
