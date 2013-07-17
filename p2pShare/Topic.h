//
//  Topic.h
//  p2pShare
//
//  Created by jacob on 17/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Topic : NSManagedObject

@property (nonatomic, retain) NSString * openUDID;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSString * content;

@end
