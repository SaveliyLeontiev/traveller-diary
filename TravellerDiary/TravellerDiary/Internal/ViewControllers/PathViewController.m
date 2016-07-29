#import "PathViewController.h"
#import "PathCell.h"

@interface PathViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PathViewController

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"PathCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PathCellID"];
    self.tableView.estimatedRowHeight = 75.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
