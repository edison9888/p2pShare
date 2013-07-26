//
//  ReceiveAndSendPackage.h
//  p2pShare
//
//  Created by jacob on 17/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveAndSendPackage : NSObject<NSFetchedResultsControllerDelegate>
{
@private
    NSFetchedResultsController  *fetchedResultsController;
    NSManagedObjectContext      *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


+(ReceiveAndSendPackage *)sharedInstance;


-(void)addData:(NSData *)receiveData;
-(NSData *)dataForExchange;

- (NSDate *)dateFromString:(NSString *)dateString;
- (NSString *)stringFromDate:(NSDate *)date;

-(void)removeDataSince:(NSInteger)days;

@end
