//
//  AddRecordViewController.m
//  p2pShare
//
//  Created by  jacob on 13-7-20.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "AddRecordViewController.h"
#import "OpenUDID.h"

@interface AddRecordViewController ()

@end

@implementation AddRecordViewController
@synthesize item,contentField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    UIBarButtonItem *sendButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Send", nil) style:UIBarButtonItemStyleDone target:self action:@selector(addRecord)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    self.navigationItem.rightBarButtonItem=sendButton;
    
    contentField=[[UITextView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:contentField];
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addRecord
{
    if (item) {
        item.content=contentField.text;
        item.lastUpdateTime=[NSDate date];
        item.openUDID=[OpenUDID value];
        NSError *error = nil;
        if (![item.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [self goBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
