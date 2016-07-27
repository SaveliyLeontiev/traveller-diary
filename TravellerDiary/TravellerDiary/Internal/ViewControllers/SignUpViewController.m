#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SignUpViewController

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

- (IBAction)signUpButtonTouched:(id)sender
{
#warning TODO: signUpButton
    [self.delegate newUserRegistred:self];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([str isEqualToString:@""]) {
        self.signUpButton.enabled = NO;
    }
    else {
        self.signUpButton.enabled = YES;
        for (UITextField *obj in self.textFields) {
            if (obj != textField) {
                if ([obj.text isEqualToString:@""]) {
                    self.signUpButton.enabled = NO;
                    break;
                }
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSMutableArray *mutableTextFields = [NSMutableArray arrayWithArray:self.textFields];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedTextFields = [mutableTextFields sortedArrayUsingDescriptors:sortDescriptors];
    
    if (textField.tag == 4) {
        [self.view endEditing:YES];
    }
    else {
        [sortedTextFields[textField.tag +1] becomeFirstResponder];
    }
    return YES;
}

@end
