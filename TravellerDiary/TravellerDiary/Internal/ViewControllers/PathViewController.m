#import "PathViewController.h"
#import "PathCell.h"

static NSString *const kSectionTitle = @"Title";
static NSString *const kNumberOfRow = @"RowNumber";

@interface PathViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *data;
@property (nonatomic) NSMutableArray<NSDictionary *> *sections;

@end

@implementation PathViewController

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"PathCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PathCellID"];
    self.tableView.estimatedRowHeight = 75.f;
    self.sections = [[NSMutableArray alloc] init];
    switch (self.pathTableType) {
        case PopularPathTabelType:
            //Load popular pathes in data
            self.navigationItem.title = NSLocalizedString(@"PopularJourneyNavigationItemTitle", );
            [self.sections addObject:@{kSectionTitle: @"",
                                       kNumberOfRow: @10}];
            break;
        case ClosestPathTabelType:
            //Load nearby pathes in data
            self.navigationItem.title = NSLocalizedString(@"ClosestJourneyNavigationItemTitle", );
            [self.sections addObject:@{kSectionTitle: @"",
                                       kNumberOfRow: @1}];
            break;
        case HistoryPathTabelType:
            //Load pathes from user history
            self.navigationItem.title = NSLocalizedString(@"HistoryNavigationItemTitle", );
            
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (int)[self.sections[section] objectForKey:kNumberOfRow];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (self.pathTableType) {
        case PopularPathTabelType:
            return @"";
            break;
        case ClosestPathTabelType:
            return @"";
            break;
        case HistoryPathTabelType:
            return @"Date";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCellID"];
    cell.title.text = @"Title";
    cell.date.text =  @"28/08/16";
    cell.rate = 3.5;
    cell.cover.image = [UIImage imageNamed:@"Image.jpg"];
    return cell;
}

@end
