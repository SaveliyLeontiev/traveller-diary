#import <Foundation/Foundation.h>
#import "Path.h"

@interface PathData : NSObject

@property (nonatomic) NSArray<NSString *> *sectionTitles;
@property (nonatomic) NSArray<NSArray<Path *> *> *pathesInSectrion;

@end
