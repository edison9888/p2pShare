//
//  ReceiveAndSendPackage.m
//  p2pShare
//
//  Created by jacob on 17/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "ReceiveAndSendPackage.h"
#import "Topic.h"
#import "NSDate-Utilities.h"

static ReceiveAndSendPackage *_sharedManagerInstance=nil;


@implementation ReceiveAndSendPackage

@synthesize fetchedResultsController,managedObjectContext;

+(ReceiveAndSendPackage *)sharedInstance
{
    if (!_sharedManagerInstance) {
        _sharedManagerInstance=[[ReceiveAndSendPackage alloc]init];
    }
    return _sharedManagerInstance;
}

-(void)addData:(NSData *)receiveData
{
    NSString* logdata;
    logdata = [[NSString alloc] initWithData:receiveData encoding:NSASCIIStringEncoding];
    NSLog(@"add Data :%@\n",logdata);
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:receiveData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonArray != nil && error == nil){
        for (NSDictionary *tmpDic in jsonArray) {
            if ([self isSameData:tmpDic]) {
                continue;
            }
            Topic *record=[NSEntityDescription insertNewObjectForEntityForName:@"Topic" inManagedObjectContext:self.managedObjectContext];
            record.lastUpdateTime=[self dateFromString:[tmpDic objectForKey:@"lastUpdateTime"]];
            record.openUDID=[tmpDic objectForKey:@"openUDID"];
            record.content=[tmpDic objectForKey:@"content"];
            if (![record.managedObjectContext save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MainViewReload" object:nil];
    }
}

-(BOOL)isSameData:(NSDictionary *)dic
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Topic" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSDate *lastUpdateTime=[self dateFromString:[dic objectForKey:@"lastUpdateTime"]];
    NSString *openUDID=[dic objectForKey:@"openUDID"];
    NSString *content=[dic objectForKey:@"content"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(openUDID==%@  AND lastUpdateTime == %@ AND  content==%@)", openUDID,lastUpdateTime,content];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if ([array count]>0) {
        NSLog(@"isSameData count:%d content:%@ openUDID:%@ lastUpdateTime:%@",[array count],content,openUDID,[self stringFromDate:lastUpdateTime] );
        return YES;
    }
    else
    return NO;
}

-(NSData *)dataForExchange
{
    NSData *result=nil;
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    NSArray *tmpArray=[fetchedResultsController fetchedObjects];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    
    for (Topic *item in tmpArray) {
        NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc]init];
        [tmpDic setObject:item.openUDID forKey:@"openUDID"];
        [tmpDic setObject:[self stringFromDate:item.lastUpdateTime] forKey:@"lastUpdateTime"];
        [tmpDic setObject:item.content forKey:@"content"];
        [arrayOfDicts addObject:tmpDic];
    }
    if ([arrayOfDicts count]>0) {
        result=[NSJSONSerialization dataWithJSONObject:arrayOfDicts options:NSJSONWritingPrettyPrinted error:nil];
    }
    NSLog(@"data to exchange :%@",result);
    return result;
}


#pragma mark Data remove
-(void)removeDataSince:(NSInteger)days
{
    NSDate *nowDate=[NSDate date];
    NSDate *beforeDaysDate=[nowDate dateBySubtractingDays:days];
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Topic" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(lastUpdateTime < %@ )", beforeDaysDate];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    for (NSManagedObject *tmp in array) {
        [tmp.managedObjectContext deleteObject:tmp];
        [tmp.managedObjectContext save:nil];
    }
    
}

#pragma mark date convert

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];

    return destDateString;
    
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Topic" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptorUpdate = [[NSSortDescriptor alloc] initWithKey:@"lastUpdateTime" ascending:YES];
        //        NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorUpdate, nil];//,sortDescriptorDate, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
    }
	
	return fetchedResultsController;
}

@end
