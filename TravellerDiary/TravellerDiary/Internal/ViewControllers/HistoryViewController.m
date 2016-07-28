#import "HistoryViewController.h"
#import "HistoryCell.h"

@interface HistoryViewController ()<UITableViewDataSource>

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell;
    return cell;
}

@end
