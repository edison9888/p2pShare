//
//  CurrentUserManager.m
//  p2pShare
//
//  Created by jacob on 23/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "CurrentUserManager.h"
#import "OpenUDID.h"

static CurrentUserManager *_sharedManagerInstance=nil;

@implementation CurrentUserManager
@synthesize locationManager,openUDID;
@synthesize nickName=_nickName;
@synthesize city=_city;
@synthesize area=_area;
@synthesize address=_address;


+(CurrentUserManager *)sharedInstance
{
    if (!_sharedManagerInstance) {
        _sharedManagerInstance=[[CurrentUserManager alloc]init];
    }
    return _sharedManagerInstance;
}


-(id)init
{
    self=[super init];
    locationManager=[[CLLocationManager alloc]init];

    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    openUDID=[OpenUDID value];
    NSUserDefaults *defaultValue=[NSUserDefaults standardUserDefaults];
    _nickName=[defaultValue objectForKey:@"nickName"];
    if (_nickName==nil) {
        _nickName=NSLocalizedString(@"Super big", nil);
    }
    return self;
}

-(void)updateLocation
{
    // Once configured, the location manager must be "started".
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:20.0];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog( @"didUpdateLocation!");
    NSLog( @"latitude is %lf and longitude is %lf", [self getUserLatitude], [self getUserLongitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            _address = [placemark name];
            _city = [placemark locality]; // locality means "city"
            _area = [placemark administrativeArea]; // which is "state" in the U.S.A.
            
            NSLog( @"name is %@ and locality is %@ and administrative area is %@", _address, _city, _area );
        }
    }];
}

-(NSString *)getLocationCombineString
{
    if (_area) {
        return [NSString stringWithFormat:@"%@,%@,%@",_area,_city,_address];
    }
    else
        return NSLocalizedString(@"Test Location", nil);    
}

- (double)getUserLatitude
{
    return locationManager.location.coordinate.latitude;
}

- (double)getUserLongitude
{
    return locationManager.location.coordinate.longitude;
}

-(CLLocationManager*) getLocationManager
{
    return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    NSLog(@"locationManager didFailWithError error code :%d",[error code]);
}

-(void)setNickName:(NSString *)nickName
{
    _nickName=nickName;
    NSUserDefaults *defaultValue=[NSUserDefaults standardUserDefaults];
    [defaultValue setObject:self.nickName forKey:@"nickName"];
    [defaultValue synchronize];
}

- (void)stopUpdatingLocation {

    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}


@end
