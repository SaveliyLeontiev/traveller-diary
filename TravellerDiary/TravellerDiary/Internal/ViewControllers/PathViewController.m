#import "PathViewController.h"
#import "PathCell.h"
#import "PathData.h"
#import "PathManager.h"
#import "SessionAPIManager.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageDownloader.h"
#import "SaveViewController.h"
#import "SaveViewControllerDelegate.h"


static NSString *const kSectionTitle = @"Title";
static NSString *const kNumberOfRow = @"RowNumber";

@interface PathViewController ()<UITableViewDataSource, UITableViewDelegate, SaveViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) PathData *pathData;
@property (nonatomic) NSDateFormatter *dateFormater;

@end

@implementation PathViewController

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"PathCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PathCellID"];
    self.tableView.estimatedRowHeight = 75.f;
    self.dateFormater = [[NSDateFormatter alloc] init];
    [self.dateFormater setDateFormat:@"dd/MM/yy"];

}

- (void)viewWillAppear:(BOOL)animated
{
    PathManager *pathManager = [[PathManager alloc] init];
    if (self.pathTableType == PopularPathTabelType) {
        [pathManager
         getPathDataForPopularWithSuccess:^(PathData *pathData) {
             self.pathData = pathData;
             [self.tableView reloadData];
         }
         failure:^(NSString *errorMessage) {
             UIAlertController *alert =
             [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle", )
                                                 message:errorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction =
             [UIAlertAction actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }];
        self.navigationItem.title = NSLocalizedString(@"PopularJourneyNavigationItemTitle", );
    }
    else if (self.pathTableType == ClosestPathTabelType) {
        //Load nearby pathes in data
        self.navigationItem.title = NSLocalizedString(@"ClosestJourneyNavigationItemTitle", );
    }
    else {
        [pathManager
         getPathDataForHistoryWithSuccess:^(PathData *pathData) {
             self.pathData = pathData;
             [self.tableView reloadData];
         }
         failure:^(NSString *errorMessage) {
             UIAlertController *alert =
             [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle", )
                                                 message:errorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction =
             [UIAlertAction actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }];
        self.navigationItem.title = NSLocalizedString(@"HistoryNavigationItemTitle", );
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.pathData.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pathData.pathesInSectrion[section] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.pathData.sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCellID" forIndexPath:indexPath];
    Path *path = self.pathData.pathesInSectrion[indexPath.section][indexPath.row];
    cell.title.text = path.name;
    cell.date.text =  [self.dateFormater stringFromDate:path.createdAt];
    cell.rate = path.rating;
    cell.cover.image = [UIImage imageNamed:@"Image.jpg"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.photowalker.demo.school.noveogroup.com/photo/get/Logo.png"]];
//    [cell.cover setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
//    {
//        cell.cover.image = image;
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        __unused NSInteger i=0;
//        
//    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Path *path = self.pathData.pathesInSectrion[indexPath.section][indexPath.row];
    UIStoryboard *newJourneyStoryboard = [UIStoryboard storyboardWithName:@"NewJourney" bundle:nil];
    SaveViewController *saveVC = [newJourneyStoryboard instantiateViewControllerWithIdentifier:@"saveViewContollerID"];
    saveVC.delegate = self;
    saveVC.pathId = path.id;
    saveVC.pathName = path.name;
    saveVC.comment = path.comment;
    saveVC.saveMode = NO;
    [self.navigationController pushViewController:saveVC animated:YES];
}




@end
