#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PathTableType)
{
    PopularPathType,
    ClosestPathType,
    HistoryPathType
};

@interface PathViewController : UIViewController

@property (nonatomic) PathTableType pathType;

@end
