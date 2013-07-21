//
//  MainViewController.h
//  p2pShare
//
//  Created by  jacob on 13-7-20.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface MainViewController : UITableViewController<NSFetchedResultsControllerDelegate,EGORefreshTableHeaderDelegate>
{
    NSString        *_sortPropertyName;
    NSPredicate     *_predicate;
    
}

@property(nonatomic,strong) NSString *entityName;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong)    EGORefreshTableHeaderView   *refreshHeaderView;
@property (nonatomic,assign)    BOOL                        reloading;

- (id)initWithEntityName:(NSString*)entityName predicateBy:(NSString *)sectionID sortBy:(NSString*)sortPropertyName context:(NSManagedObjectContext*)managedObjectContext;
- (id)initWithEntityName:(NSString*)entityName predicateBy:(NSString *)sectionID sortBy:(NSString*)sortPropertyName context:(NSManagedObjectContext*)managedObjectContext andStyle:(UITableViewStyle)style;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;



@end