//
//  ContentFormat.m
//  p2pShare
//
//  Created by  jacob on 13-7-26.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "ContentFormat.h"
#import "CurrentUserManager.h"


static ContentFormat *_sharedManagerInstance=nil;


@implementation ContentFormat



+(ContentFormat *)sharedInstance
{
    if (!_sharedManagerInstance) {
        _sharedManagerInstance=[[ContentFormat alloc]init];
    }
    return _sharedManagerInstance;
}

+(NSString *)newThreadWithContent:(NSString *)content
{
    NSData * resultData=nil;
    NSString *result=nil;
    NSString *longtitude=[NSString stringWithFormat:@"%lf",[[CurrentUserManager sharedInstance] getUserLongitude]];
    NSString *latitude=[NSString stringWithFormat:@"%lf",[[CurrentUserManager sharedInstance] getUserLatitude]];
    NSString *address=[[CurrentUserManager sharedInstance] getLocationCombineString];
    NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc]init];
    [tmpDic setObject:longtitude forKey:@"longtitude"];
    [tmpDic setObject:latitude forKey:@"latitude"];
    [tmpDic setObject:address forKey:@"address"];
    [tmpDic setObject:content forKey:@"content"];
    NSMutableArray *tmpArray=[[NSMutableArray alloc]initWithObjects:tmpDic, nil];
    resultData=[NSJSONSerialization dataWithJSONObject:tmpArray options:NSJSONWritingPrettyPrinted error:nil];
    result=[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"newThreadWithContent %@",result);
    return result;
}


+(NSString *)updateThreadContent:(NSString *)oldContent WithNewContent:(NSString *)newContent
{
    
}



@end
