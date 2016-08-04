#import "LoginController.h"
#import <UIKit/UIKit.h>

static NSString *const kHash = @"hash";
static NSString *const kEmail = @"email";
static NSString *const kPassword = @"password";

@implementation LoginController

+ (void)saveHash:(NSString *)hash Email:(NSString *)email password:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:hash forKey:kHash];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)hash
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHash];
}

+ (NSString *)email
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEmail];
}

+ (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
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
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil];
    UINavigationController *navigationController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginID"];
    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}

@end
