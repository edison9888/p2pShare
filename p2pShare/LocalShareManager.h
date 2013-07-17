//
//  LocalShareManager.h
//  p2pShare
//
//  Created by jacob on 17/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalShareManager : NSObject<NSNetServiceBrowserDelegate,NSNetServiceDelegate>
{
    NSNetServiceBrowser     *_domainBrowser;
    NSMutableArray          *_tmpServices;
    NSMutableArray          *_services;
    // Keeps track of available domains
    NSMutableArray          *_domains;
    
    // Keeps track of search status
    BOOL _searching;
}
@property (nonatomic,strong) NSNetServiceBrowser     *domainBrowser;


-(void)browseLocalLanServices;

+(LocalShareManager *)sharedInstance;

@end
