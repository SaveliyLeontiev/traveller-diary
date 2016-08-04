#import <Foundation/Foundation.h>
#import "Path.h"

@interface PathBuilder : NSObject

- (Path *)pathWithDictionary:(NSDictionary *)dict;
- (NSArray *)pathesWithArray:(NSArray<NSDictionary *> *)array;

@end
