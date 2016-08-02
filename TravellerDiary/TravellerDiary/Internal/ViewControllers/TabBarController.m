#import "TabBarController.h"
#import "PathViewController.h"
#import "UIColor+HexString.h"

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *pathTableStoryboard = [UIStoryboard storyboardWithName:@"PathTable" bundle:nil];
    UIStoryboard *newJourneyStoryboard = [UIStoryboard storyboardWithName:@"NewJourney" bundle:nil];
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    PathViewController *popularVC = [pathTableStoryboard instantiateViewControllerWithIdentifier:@"PathViewControllerID"];
    PathViewController *nearbyVC = [pathTableStoryboard instantiateViewControllerWithIdentifier:@"PathViewControllerID"];
    PathViewController *historyVC = [pathTableStoryboard instantiateViewControllerWithIdentifier:@"PathViewControllerID"];
    UIViewController *newJourneyVC = [newJourneyStoryboard instantiateViewControllerWithIdentifier:@"NewJourneyID"];
    UIViewController *settingsVC = [settingsStoryboard instantiateViewControllerWithIdentifier:@"SettingsID"];
    [self setViewController:[[UINavigationController alloc] initWithRootViewController:popularVC] atIndex:0];
    [self setViewController:[[UINavigationController alloc] initWithRootViewController:nearbyVC] atIndex:1];
    [self setViewController:newJourneyVC atIndex:2];
    [self setViewController:[[UINavigationController alloc] initWithRootViewController:historyVC] atIndex:3];
    [self setViewController:[[UINavigationController alloc] initWithRootViewController:settingsVC] atIndex:4];
    self.buttonsBackgroundColor = [UIColor whiteColor];
    self.selectedColor = [UIColor mainThemeColor];
    self.selectionIndicatorHeight = 3.0;
    self.separatorLineVisible = YES;
    self.separatorLineColor = [UIColor mainThemeColor];
    [self highlightButtonAtIndex:2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSelectedIndex:2 animated:YES];
}

@end
