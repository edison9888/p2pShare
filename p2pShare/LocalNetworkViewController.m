//
//  LocalNetworkViewController.m
//  p2pShare
//
//  Created by jacob on 12/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "LocalNetworkViewController.h"

@interface LocalNetworkViewController ()
{
    NSNetService            *_service;
    NSNetServiceBrowser     *_domainBrowser;
    NSNetService            *_tmpService;
    NSMutableArray          *_services;
    // Keeps track of available domains
    NSMutableArray *_domains;
    
    // Keeps track of search status
    BOOL _searching;
}
@end

@implementation LocalNetworkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor grayColor];
    _domainBrowser = [[NSNetServiceBrowser alloc] init];
    [_domainBrowser setDelegate:self];
    [_domainBrowser searchForServicesOfType:@"_http._tcp" inDomain:@""];
    _domains = [[NSMutableArray alloc] init];
    _searching = NO;

    
}

-(void)browserService
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSNetserviceBrowser Delegate
// NSNetServiceBrowser delegate methods for domain browsing
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    _searching = YES;
    [self updateUI];
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    _searching = NO;
    [self updateUI];
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict
{
    _searching = NO;
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode]];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"name:%@ port:%d type:%@",[netService name],[netService port],[netService type]);
    _tmpService=netService;
    _tmpService.delegate=self;
    [_tmpService resolveWithTimeout:5.0];
}

// Sent when a domain appears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
            didFindDomain:(NSString *)domainString
               moreComing:(BOOL)moreComing
{
    NSLog(@"find domain %@",domainString);
    [_domains addObject:domainString];
    if(!moreComing)
    {
        [self updateUI];
    }
}

// Sent when a domain disappears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
          didRemoveDomain:(NSString *)domainString
               moreComing:(BOOL)moreComing
{
    [_domains removeObject:domainString];
    
    if(!moreComing)
    {
        [self updateUI];
    }
}

// resolve nsnetservice

// Sent when addresses are resolved

// Verifies [netService addresses]
- (BOOL)addressesComplete:(NSArray *)addresses
           forServiceType:(NSString *)serviceType
{
    // Perform appropriate logic to ensure that [netService addresses]
    // contains the appropriate information to connect to the service
    return YES;
}

// Error handling code
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service
{
    NSLog(@"An error occurred with service %@.%@.%@, error code = %d",
          [service name], [service type], [service domain], [error intValue]);
    // Handle error here
}

- (void)netServiceDidResolveAddress:(NSNetService *)netService
{
    // Make sure [netService addresses] contains the
    // necessary connection information
    if ([self addressesComplete:[netService addresses]
                 forServiceType:[netService type]]) {
        [_services addObject:netService];
        NSLog(@"resolved name:%@ port:%d type:%@",[netService name],[netService port],[netService type]);
    }
}

// Sent if resolution fails
- (void)netService:(NSNetService *)netService
     didNotResolve:(NSDictionary *)errorDict
{
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode] withService:netService];
    [_services removeObject:netService];
}

// Error handling code
- (void)handleError:(NSNumber *)error
{
    NSLog(@"An error occurred. Error code = %@", error);
    // Handle error here
}

// UI update code
- (void)updateUI
{
    if(_searching)
    {
        // Update the user interface to indicate searching
        // Also update any UI that lists available domains
    }
    else
    {
        // Update the user interface to indicate not searching
    }
}

@end
