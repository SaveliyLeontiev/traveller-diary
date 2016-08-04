#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PathTableType)
{
    PopularPathTabelType,
    ClosestPathTabelType,
    HistoryPathTabelType
};

@interface PathViewController : UIViewController

@property (nonatomic) PathTableType pathTableType;

@end
