#import "AFNetworking/UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageDownloader.h"
#import "LoginController.h"
#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[UIImageView sharedImageDownloader].sessionManager.requestSerializer
     setValue:[NSString stringWithFormat:@"Bearer oFZyAmt9nozfitZoYWuCav9HgvtpXwgO"]  forHTTPHeaderField:@"Authorization"];
    
   
    
    NSURL *imageURL = [NSURL URLWithString:@"http://api.photowalker.demo.school.noveogroup.com/photo/get/Logo.png"];
    
     NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
    
    [self.image setImageWithURL:imageURL];
    
    [self.image setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    
}
- (IBAction)logout:(id)sender
{
    [LoginController logout];
}

@end
