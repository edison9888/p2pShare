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
@synthesize locationManager,bestEffortAtLocation,openUDID,nickName;


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
    nickName=[defaultValue objectForKey:@"nickName"];
    return self;
}

-(void)updateLocation
{
    // Once configured, the location manager must be "started".
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:20.0];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSLog(@"Location update with longtitude:%f latitude%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    NSLog(@"locationManager didFailWithError error code :%d",[error code]);
}

-(void)setNickName:(NSString *)nickName
{
    self.nickName=nickName;
    NSUserDefaults *defaultValue=[NSUserDefaults standardUserDefaults];
    [defaultValue setObject:self.nickName forKey:@"nickName"];
    [defaultValue synchronize];
}

- (void)stopUpdatingLocation {

    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}


@end
