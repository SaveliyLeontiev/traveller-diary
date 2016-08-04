#import <Foundation/Foundation.h>

@interface User : RLMObject

@property (nonatomic) NSInteger userId;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *avatar;
@property (nonatomic) NSDate *createDate;
@property (nonatomic) NSDate *updateDate;

@end
