//
//  SettingViewController.m
//  p2pShare
//
//  Created by jacob on 23/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangeNameViewController.h"
#import "WebViewController.h"
#import "ReceiveAndSendPackage.h"
#import "CurrentUserManager.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Setting", nil);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        switch (indexPath.section) {
            case 0:
            {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];                
            }
                break;
            case 1:
            {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
                break;
            case 2:
            {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
                break;
            default:
                break;
        }
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text=NSLocalizedString(@"Name", nil);
            cell.detailTextLabel.text=[CurrentUserManager sharedInstance].nickName;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=NSLocalizedString(@"Follow us", nil);
                    break;
                case 1:
                    cell.textLabel.text=NSLocalizedString(@"Rate us", nil);
                    break;
                case 2:
                    cell.textLabel.text=NSLocalizedString(@"About", nil);
                    break;
                default:
                    break;
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            cell.textLabel.text=NSLocalizedString(@"Clear records", nil);
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.backgroundColor=[UIColor redColor];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
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
    switch (indexPath.section) {
        case 0:
        {
            ChangeNameViewController *nameVC=[[ChangeNameViewController alloc]init];
            [self.navigationController pushViewController:nameVC animated:YES];
        }
            break;
        case 1:
        {
            WebViewController *webVC=[[WebViewController alloc]init];
            switch (indexPath.row) {
                case 0:
                {
                    webVC.urlString=@"http://weibo.com/jacobjiangwei";
                    webVC.title=NSLocalizedString(@"Weibo", nil);
                }
                    break;
                case 1:
                {
                    webVC.urlString=@"http://weibo.com/jacobjiangwei";
                    webVC.title=NSLocalizedString(@"App Store", nil);
                }
                    break;
                case 2:
                {
                    webVC.urlString=@"http://jacobjiangwei.duapp.com";
                    webVC.title=NSLocalizedString(@"Author Website", nil);
                }
                    break;
                default:
                    break;
            }
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Delete N days before", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"All", nil) otherButtonTitles:NSLocalizedString(@"7 days", nil),NSLocalizedString(@"3 days", nil), nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
        }
            break;
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[ReceiveAndSendPackage sharedInstance] removeDataSince:0];
    }else if (buttonIndex == 1) {
        [[ReceiveAndSendPackage sharedInstance] removeDataSince:7];
    }else if(buttonIndex == 2) {
        [[ReceiveAndSendPackage sharedInstance] removeDataSince:3];
    }else if(buttonIndex == 3) {
        
    }
}

@end
