#import "LoginController.h"
#import <UIKit/UIKit.h>

static NSString *const kHash = @"hash";

@implementation LoginController

+ (void)saveHash:(NSString *)hash
{
    [[NSUserDefaults standardUserDefaults] setObject:hash forKey:kHash];
}

+ (NSString *)hash
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHash];
}

+ (BOOL)isLogined
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kHash]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kHash];
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login.storyboard" bundle:nil];
    UINavigationController *navigationController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginID"];
    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}

@end
