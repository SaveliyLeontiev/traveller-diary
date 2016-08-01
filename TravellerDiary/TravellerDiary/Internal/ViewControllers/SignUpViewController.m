#import "SignUpViewController.h"
#import "LoginAPIManager.h"

@interface SignUpViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, strong) NSArray<UITextField *> *sortedTextFields;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SignUpViewController

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sortedTextFields = [self.textFields sortedArrayUsingComparator:^NSComparisonResult(UITextField *obj1, UITextField *obj2) {
        return [@(obj1.tag) compare:@(obj2.tag)];
    }];
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

- (IBAction)signUpButtonTouched:(id)sender
{
#warning SAVELIY TODO: signUpButton
    if (![self.sortedTextFields[3].text isEqual:self.sortedTextFields[4].text]) {
        [self allertWithMessage:NSLocalizedString(@"SignUpErrorMessageWithEqualPasswords", )];
    }
    else {
        [[LoginAPIManager sharedInstance]
    signUpWithFirstName:self.sortedTextFields[0].text
    lastName:self.sortedTextFields[1].text
    email:self.sortedTextFields[2].text
    password:self.sortedTextFields[3].text
    success:^{
        [self.delegate newUserRegistred:self];
    }
    failure:^(NSString *errorMassage) {
        [self allertWithMessage:errorMassage];
    }];
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

#pragma mark - Allerts

- (void) allertWithMessage:(NSString *)message
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle", )
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([str isEqualToString:@""]) {
        self.signUpButton.enabled = NO;
    }
    else {
        self.signUpButton.enabled = YES;
        for (UITextField *obj in self.textFields) {
            if (obj != textField && [obj.text isEqualToString:@""]) {
                self.signUpButton.enabled = NO;
                break;
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 4) {
        [self.view endEditing:YES];
    }
    else {
        [self.sortedTextFields[textField.tag + 1] becomeFirstResponder];
    }
    return YES;
}

@end
