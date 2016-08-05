#import "PathManager.h"
#import "SessionAPIManager.h"
#import "LoginController.h"
#import "LocationManager.h"

@interface PathManager ()

@property (nonatomic) SessionAPIManager *sessionAPIManager;
@property (nonatomic) NSDateFormatter *dateFormater;

@end

@implementation PathManager

- (instancetype)init
{
    if (self = [super init]) {
        _sessionAPIManager = [[SessionAPIManager alloc] initWithHash:[LoginController hash]];
        _dateFormater = [[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"dd/MM/yy"];
    }
    return self;
}

- (void)getPathDataForHistoryWithSuccess:(void (^)(PathData *))success
                                 failure:(void (^)(NSString *))failure
{
    [self.sessionAPIManager
     getMyPathWithSuccess:^(NSArray<Path *> *pathes) {
         [self.sessionAPIManager getPhotoWithImageURL:[NSURL URLWithString:@"http://api.photowalker.demo.school.noveogroup.com/photo/get/Logo.png"] success:nil failure:nil];
         PathData *pathData = [[PathData alloc] init];
         pathes = [pathes sortedArrayUsingComparator:^NSComparisonResult(Path *obj1, Path *obj2) {
             return [obj2.createdAt compare: obj1.createdAt];
         }];
         if ([pathes count] == 0) {
             pathData.sectionTitles = @[@""];
             pathData.pathesInSectrion = @[@[]];
         }
         else {
             NSCalendar *calendar = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
             NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
             NSString *firstSectionTitle = [self.dateFormater stringFromDate:pathes[0].createdAt];
             NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithArray:@[firstSectionTitle]];
             NSMutableArray *pathesInSection = [[NSMutableArray alloc] init];
             NSMutableArray *pathesInCurrentSection = [NSMutableArray arrayWithObject:pathes[0]];
             for (NSInteger i = 1; i<[pathes count]; i++) {
                 NSDateComponents *date1 = [calendar components:units fromDate:pathes[i-1].createdAt];
                 NSDateComponents *date2 = [calendar components:units fromDate:pathes[i].createdAt];
                 if (([date1 day] == [date2 day]) && ([date1 year] == [date2 year])) {
                     [pathesInCurrentSection addObject:pathes[i]];
                 }
                 else {
                     [pathesInSection addObject:[pathesInCurrentSection copy]];
                     [sectionTitles addObject:[self.dateFormater stringFromDate:pathes[i].createdAt]];
                     pathesInCurrentSection = [NSMutableArray arrayWithObject:pathes[i]];
                 }
             }
             [pathesInSection addObject:[pathesInCurrentSection copy]];
             pathData.sectionTitles = [sectionTitles copy];
             pathData.pathesInSectrion = [pathesInSection copy];
         }
         success(pathData);
     }
     failure:^(NSInteger errorCode) {
         if (errorCode == 401) {
             [LoginController logout];
         }
         else {
             failure(NSLocalizedString(@"errorTitle", ));
         }
     }];
}

- (void)getPathDataForPopularWithSuccess:(void (^)(PathData *))success
                                 failure:(void (^)(NSString *))failure
{
    [self.sessionAPIManager
     getPopularPathWithSuccess:^(NSArray<Path *> *pathes) {
         PathData *pathData = [[PathData alloc] init];
         pathData.sectionTitles = @[@""];
         pathData.pathesInSectrion = @[pathes];
         success(pathData);
    }
     failure:^(NSInteger errorCode) {
         if (errorCode == 401) {
             [LoginController logout];
         }
         else {
             failure(NSLocalizedString(@"errorTitle", ));
         }
     }];
}

- (void)getPathDataForNearestWithSuccess:(void (^)(PathData *))success
                                 failure:(void (^)(NSString *))failure
{
    LocationCoordinate *point;
    [self.sessionAPIManager getClosestPathToPoint:point
    success:^(NSArray<Path *> *pathes) {
        PathData *pathData = [[PathData alloc] init];
        pathData.sectionTitles = @[@""];
        pathData.pathesInSectrion = @[pathes];
    }
    failure:^(NSInteger errorCode) {
        if (errorCode == 401) {
            [LoginController logout];
        }
        else {
            failure(NSLocalizedString(@"errorTitle", ));
        }
    }];
}

- (void)postPath:(Path *)path
          points:(NSArray<LocationCoordinate *> *)points
          photos:(NSArray<UIImage *> *)photos
         success:(void (^)(void))success
         failure:(void (^)(NSString *))failure
{
    void(^errorBlock)(NSInteger) = ^void(NSInteger errorCode) {
        switch (errorCode) {
            case 401:
                [LoginController logout];
                break;
            case NSURLErrorNotConnectedToInternet:
                failure(NSLocalizedString(@"ErrorNoInternetConnection", ));
            default:
                failure(NSLocalizedString(@"errorTitle", ));
                break;
        }
    };
    
    [self.sessionAPIManager
     createPath:path
     success:^(NSInteger pathId){
         [self.sessionAPIManager createPoints:points pathId:pathId
          success:^{
              dispatch_group_t group = dispatch_group_create();
              __block NSString *errorMessage;
              for (UIImage *photo in photos) {
                  dispatch_group_enter(group);
                  [self.sessionAPIManager uploadPhoto:photo withPathId:pathId pointId:0
                    success:^{
                      dispatch_group_leave(group);
                  } failure:^(NSInteger errorCode) {
                      switch (errorCode) {
                          case NSURLErrorNotConnectedToInternet:
                              errorMessage = NSLocalizedString(@"ErrorNoInternetConnection", );
                          default:
                              errorMessage = NSLocalizedString(@"errorTitle", );
                              break;
                      }
                      dispatch_group_leave(group);
                  }];
              }
              dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                  if (errorMessage) {
                      failure(errorMessage);
                  }
                  else {
                      success();
                  }
              });
         }
          failure:errorBlock];
     }
     failure:errorBlock];
}


@end
