//
//  AddRecordViewController.m
//  p2pShare
//
//  Created by  jacob on 13-7-20.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "AddRecordViewController.h"
#import "OpenUDID.h"
#import "ContentFormat.h"
#import <QuartzCore/QuartzCore.h>


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
    
    contentField=[[SZTextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    contentField.placeholder=NSLocalizedString(@"Share interesting things", nil);
    contentField.font=[UIFont fontWithName:@"Courier" size:15.0];
    contentField.layer.borderColor = [UIColor grayColor].CGColor;
    contentField.layer.borderWidth =1.0;//该属性显示外边框
    contentField.layer.cornerRadius = 6.0;//通过该值来设置textView边角的弧度
    contentField.layer.masksToBounds = YES;
//    NSAttributedString *attribute=[[NSAttributedString alloc]initWithString:@"Letterpress" attributes:@{NSTextEffectsAttributeName:NSTextEffectsLetterpressStyle}];
    
    contentField.delegate=self;
    [self.view addSubview:contentField];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [contentField becomeFirstResponder];
}

-(void)goBack
{
    
	[item.managedObjectContext deleteObject:item];
    
	NSError *error = nil;
	if (![item.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addRecord
{
    if (contentField.text.length<10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"At least input 10 letters", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (item) {
        item.content=[ContentFormat newThreadWithContent:contentField.text];
        NSDate *now=[NSDate date];
        NSTimeInterval number=[now timeIntervalSince1970];
        int intNumber=(int)number;
        item.lastUpdateTime=[NSNumber numberWithInt:intNumber];
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextview Delegate

- (void)textViewDidChange:(UITextView *)textView
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
