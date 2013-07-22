//
//  CoreDataTableViewController.m
//  iBaby
//
//  Created by jacob on 3/7/13.
//  Copyright (c) 2013年 Jacob QQ:110773265. All rights reserved.
//

#import "MainViewController.h"
#import "Topic.h"
#import "LocalShareManager.h"
#import "AddRecordViewController.h"
#import "NetworkViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize reloading=_reloading;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize entityName=_entityName;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEntityName:(NSString*)entityName predicateBy:(NSString *)sectionID sortBy:(NSString*)propertyName context:(NSManagedObjectContext*)managedObjectContext {
    
    //Call Designated Initializer with Grouped Style
    self = [self initWithEntityName:entityName predicateBy:sectionID sortBy:propertyName context:managedObjectContext andStyle:UITableViewStylePlain];
    
    return self;
}

- (id)initWithEntityName:(NSString*)entityName predicateBy:(NSString *)sectionID sortBy:(NSString*)sortPropertyName context:(NSManagedObjectContext*)managedObjectContext andStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //Setup Properties
        self.entityName = entityName;
        self.managedObjectContext = managedObjectContext;
        if (sectionID) {
            _predicate = [NSPredicate predicateWithFormat:@"sectionID == %@", sectionID];
        }
        self.reloading=NO;
        //Setup Instance Variables
        _sortPropertyName = sortPropertyName;
        [self.tableView addSubview:[self refreshHeaderView]];
        [_refreshHeaderView refreshLastUpdatedDate];
        [self refreshData];
    }
    return self;
}

- (void)refreshData{
    
    //Create Fetch Request with Entity Provided
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    
    //Add Sort-By Property
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:_sortPropertyName ascending:YES]];
    if (_predicate) {
        [fetchRequest setPredicate:_predicate];
    }
    
    //Create FetchResults Controller with FetchRequest
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    //Assign Delegate
    _fetchedResultsController.delegate = self;
    
    //Execute Fetch
    [_fetchedResultsController performFetch:nil];
    
    //Refresh Data
    [self.tableView reloadData];
    
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addRecord)];
    UIBarButtonItem *settingButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem=settingButton;
    self.navigationItem.rightBarButtonItem=addButton;
}

-(void)setting
{
    NetworkViewController *netVC=[[NetworkViewController alloc]init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromBottom;
    [transition setType:kCATransitionFromBottom];
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:netVC animated:NO];
}

-(void)addRecord
{
    AddRecordViewController *addVC=[[AddRecordViewController alloc]init];
    Topic *item=[NSEntityDescription insertNewObjectForEntityForName:@"Topic" inManagedObjectContext:self.managedObjectContext];
    addVC.item=item;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Pulls Data out of DB and refreshed TableView
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create Cell Identifer
    static NSString *CellIdentifier = @"Cell";
    
    //Try to Deqeue Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //If no dequeued cells, then create one with cell Identifer
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //Configure the Cell
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    Topic *item=(Topic *)[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.numberOfLines=3;
    cell.textLabel.text=item.content;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[[LocalShareManager sharedInstance] browseLocalLanServices];
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark - Getter Setter

-(EGORefreshTableHeaderView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
    }
    return _refreshHeaderView;
}

@end
