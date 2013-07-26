//
//  CurrentUserManager.h
//  p2pShare
//
//  Created by jacob on 23/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentUserManager : NSObject <CLLocationManagerDelegate>

//@property (nonatomic,strong) CLLocation         *bestEffortAtLocation;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString           *openUDID;
@property (nonatomic,strong) NSString           *nickName;
@property (nonatomic,strong) NSString           *city;
@property (nonatomic,strong) NSString           *address;
@property (nonatomic,strong) NSString           *area;

+(CurrentUserManager *)sharedInstance;
-(void)updateLocation;

- (double)getUserLatitude;
- (double)getUserLongitude;

-(NSString *)getLocationCombineString;

@end
