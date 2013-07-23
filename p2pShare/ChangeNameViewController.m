//
//  ChangeNameViewController.m
//  p2pShare
//
//  Created by jacob on 23/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "CurrentUserManager.h"

@interface ChangeNameViewController ()

@end

@implementation ChangeNameViewController

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
    self.title=NSLocalizedString(@"Edit Name", nil);
    CGRect rect=[UIScreen mainScreen].bounds;
    UITextField *nameField=[[UITextField alloc]initWithFrame:CGRectMake(20, 20, rect.size.width-40, 60)];
    nameField.delegate=self;
    if ([CurrentUserManager sharedInstance].nickName) {
        nameField.text=[CurrentUserManager sharedInstance].nickName;
    }
    else
        nameField.placeholder=NSLocalizedString(@"Input your name", nil);
    [nameField becomeFirstResponder];
    
    [self.view addSubview:nameField];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
