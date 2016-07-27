#import "LogInViewController.h"
#import "UIColor+HexString.h"
#import "SignUpViewControllerDelegate.h"
#import "SignUpViewController.h"

@interface LogInViewController () <UITextFieldDelegate, SignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LogInViewController

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

- (IBAction)loginButtonTouched:(id)sender
{
#warning TODO:loginButton
    [self performSegueWithIdentifier:@"ShowTabBarID" sender:self];
}

- (IBAction)forgottenPasswordButtonTouched:(id)sender
{
#warning TODO:forgottenPassword
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignUpSegueID"]) {
        SignUpViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    CGRect scrollViewRect = self.scrollView.frame;
    
    CGRect hiddenScrollViewRect = CGRectIntersection(scrollViewRect, kbRect);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, hiddenScrollViewRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([str isEqualToString:@""]) {
        self.logInButton.enabled = NO;
    }
    else {
        if (textField == self.loginTextField) {
            if (![self.passwordTextField.text isEqualToString:@""]) {
                self.logInButton.enabled = YES;
            }
        }
        else {
            if (![self.loginTextField.text isEqualToString:@""]) {
                self.logInButton.enabled = YES;
            }
        }
    }
    return YES;
}

#pragma mark - SignUpViewControllerDelegate

- (void)newUserRegistred:(SignUpViewController *)signUpviewController
{
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
