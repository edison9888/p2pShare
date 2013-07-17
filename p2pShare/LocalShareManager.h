//
//  LocalShareManager.h
//  p2pShare
//
//  Created by jacob on 17/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface LocalShareManager : NSObject<NSNetServiceBrowserDelegate,NSNetServiceDelegate,ASIHTTPRequestDelegate>
{
    NSNetServiceBrowser     *_domainBrowser;
    NSMutableArray          *_tmpServices;
    NSMutableArray          *_services;
    // Keeps track of available domains
    NSMutableArray          *_domains;
    ASINetworkQueue         *_trackQueue;
    // Keeps track of search status
    BOOL _searching;
}
@property (nonatomic,strong) NSNetServiceBrowser     *domainBrowser;


-(void)browseLocalLanServices;
-(void)exchangeWithHost:(NSString *)address port:(UInt16)port;


+(LocalShareManager *)sharedInstance;

@end
