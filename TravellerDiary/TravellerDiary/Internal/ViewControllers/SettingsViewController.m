#import "AFNetworking/UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageDownloader.h"
#import "LoginController.h"
#import "SettingsViewController.h"
#import "Preferences.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSIndexPath *currentCellIndexPath;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                                                      withFrame:self.view.bounds
                                                      andColors:@[[UIColor mainThemeColor], [UIColor flatYellowColor]]];
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (![indexPath isEqual:self.currentCellIndexPath]) {
        UITableViewCell *currentCell =
        [self.tableView cellForRowAtIndexPath:self.currentCellIndexPath];
        currentCell.accessoryType = UITableViewCellAccessoryNone;
        self.currentCellIndexPath = indexPath;
        [Preferences setAccuracyTypeWithType:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"SettingsAccuracySectionTitle", );
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const kAccuracyCity = NSLocalizedString(@"SettingsAccuracyCity", );
    NSString *const kAccuracyNeighborhood = NSLocalizedString(@"SettingsAccuracyNeighborhood", );
    NSString *const kAccuracyBlock = NSLocalizedString(@"SettingsAccuracyBlock", );
    NSString *const kAccuracyHouse = NSLocalizedString(@"SettingsAccuracyHouse", );
    NSString *const kAccuracyRoom = NSLocalizedString(@"SettingsAccuracyRoom", );
    
    NSArray *labels = @[kAccuracyCity,
                        kAccuracyNeighborhood,
                        kAccuracyBlock,
                        kAccuracyHouse,
                        kAccuracyRoom];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    cell.textLabel.text = labels[indexPath.row];
    if (indexPath.row == [Preferences accuracyType]) {
        self.currentCellIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Action

- (IBAction)logout:(id)sender
{
    [LoginController logout];
}

@end
