//
//  ContentFormat.h
//  p2pShare
//
//  Created by  jacob on 13-7-26.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentFormat : NSObject

+(ContentFormat *)sharedInstance;
+(NSString *)newThreadWithContent:(NSString *)content;
+(NSString *)updateThreadContent:(NSString *)oldContent WithNewContent:(NSString *)newContent;


@end
