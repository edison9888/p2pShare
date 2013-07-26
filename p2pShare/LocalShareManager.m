//
//  LocalShareManager.m
//  p2pShare
//
//  Created by jacob on 17/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "LocalShareManager.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import "AFJSONRequestOperation.h"
#import "AFAppDotNetAPIClient.h"
#import "ReceiveAndSendPackage.h"
#import "ASIFormDataRequest.h"


static LocalShareManager *_sharedManagerInstance=nil;

@implementation LocalShareManager

@synthesize domainBrowser=_domainBrowser;
@synthesize serviceCount=_serviceCount;

+(LocalShareManager *)sharedInstance
{
    if (!_sharedManagerInstance) {
        _sharedManagerInstance=[[LocalShareManager alloc]init];
    }
    return _sharedManagerInstance;
}

-(id)init
{
    self=[super init];
    _domains = [[NSMutableArray alloc] init];
    _searching = NO;
    _tmpServices=[[NSMutableArray alloc]init];
    _trackQueue =[[ASINetworkQueue alloc]init];
    [_trackQueue reset];
    [_trackQueue setMaxConcurrentOperationCount:1];
    return self;
}

-(void)browseLocalLanServices
{
    [[self domainBrowser] searchForServicesOfType:@"_p2pShare._tcp" inDomain:@""];
    [self performSelector:@selector(stopBrowsingLocalServices) withObject:nil afterDelay:10.0];
}

-(void)stopBrowsingLocalServices
{
    NSLog(@"stopBrowsingLocalServices");
    [[self domainBrowser] stop];
    [_tmpServices removeAllObjects];
}

-(void)startResolvingServices
{
    for (NSNetService *tmpService in _tmpServices) {
        tmpService.delegate=self;
        [tmpService resolveWithTimeout:5.0];
    }
}

-(void)exchangeWithHost:(NSString *)address port:(UInt16)port
{
    NSLog(@"exchange with addr:%@ port:%d",address,port);
    NSString *urlString=[NSString stringWithFormat:@"http://%@:%d/post",address,port];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url];
    [request setTimeOutSeconds:15.0];
    request.delegate=self;
    NSData *bodyData=[[ReceiveAndSendPackage sharedInstance] dataForExchange];
    [request appendPostData:bodyData];
    [_trackQueue addOperation:request];
    [_trackQueue go];
}

-(NSNetServiceBrowser *)domainBrowser
{
    if (!_domainBrowser) {
        _domainBrowser = [[NSNetServiceBrowser alloc] init];
        [_domainBrowser setDelegate:self];
    }
    return _domainBrowser;
}

#pragma mark NSNetserviceBrowser Delegate
// NSNetServiceBrowser delegate methods for domain browsing
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    _searching = YES;
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    _searching = NO;
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict
{
    _searching = NO;
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode]];
    if ([_tmpServices count]>0) {
        NSLog(@"netServiceBrowser didNotSearch while _tmpServices>0 , search again");
        [_tmpServices removeAllObjects];
        [self browseLocalLanServices];
    }
    
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"name:%@ port:%d type:%@",[netService name],[netService port],[netService type]);
    [_tmpServices addObject:netService];
    if (!moreServicesComing) {
        _serviceCount=[_tmpServices count];
        NSLog(@"found service count :%d",_serviceCount);
        [[self domainBrowser] stop];
        [self startResolvingServices];
    }
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

#pragma mark netService Resolve Delegate
// resolve nsnetservice
- (void)netServiceDidResolveAddress:(NSNetService *)netService
{
    NSLog(@"netServiceDidResolveAddress");
    NSArray *addresses=[netService addresses];
    for (NSData *addressData in addresses) {
        NSLog(@"for in 1");
        NSString *address = [self getStringFromAddressData:addressData];
        NSLog(@"checking IP is : %@",address);
        if ([address hasPrefix:@"127"] || [address hasPrefix:@"0."]) {
            continue;
        }
        if ([address isEqualToString:[self localIPAddress]]) {
            continue;
        }
        // Make sure [netService addresses] contains the
        // necessary connection information
        NSLog(@"resolved name:%@ ip:%@  port:%d type:%@",[netService name],address,[netService port],[netService type]);
        //add task to share information with this IP
        [self exchangeWithHost:address port:[netService port]];
    }
//    for (int i=0; i<[_tmpServices count]; i++) {
//        NSLog(@"for in 3");
//        NSNetService *tmp=[_tmpServices objectAtIndex:i];
//        if (tmp==netService) {
//            [_tmpServices removeObjectAtIndex:i];
//            NSLog(@"delete object tmp");
//        }
//    }

    
    for (NSNetService *tmp in _tmpServices) {
        NSLog(@"for in 2");
        if (tmp==netService) {
            [_tmpServices removeObject:tmp];
            NSLog(@"delete object tmp");
            break;
        }
    }
}

// Sent if resolution fails
- (void)netService:(NSNetService *)netService
     didNotResolve:(NSDictionary *)errorDict
{
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode] withService:netService];
    for (NSNetService *tmp in _tmpServices) {
        if (tmp==netService) {
            [_tmpServices removeObject:tmp];
        }
    }
}

// Error handling code
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service
{
    NSLog(@"An error occurred with service %@.%@.%@, error code = %d",
          [service name], [service type], [service domain], [error intValue]);
    // Handle error here
}


#pragma mark IP addr function
- (NSString *)getStringFromAddressData:(NSData *)dataIn {
    struct sockaddr_in  *socketAddress = nil;
    NSString            *ipString = nil;
    
    socketAddress = (struct sockaddr_in *)[dataIn bytes];
    ipString = [NSString stringWithFormat: @"%s",
                inet_ntoa(socketAddress->sin_addr)];  ///problem here
    return ipString;
}

// return IP Address
- (NSString *)hostname
{
    char baseHostName[256];
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if !TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#else
    return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}

- (NSString *)localIPAddress
{
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    NSLog(@"local IP :%@",[NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding]);
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}


// Error handling code
- (void)handleError:(NSNumber *)error
{
    NSLog(@"Netservice An error occurred. Error code = %@", error);
    // Handle error here
}

// UI update code //not necessary any more
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

#pragma ASIHttpRequest Delegate

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    [[ReceiveAndSendPackage sharedInstance]addData:responseData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}


@end
