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

@synthesize nameField;

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
    self.view.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Done)];
    self.navigationItem.rightBarButtonItem=doneButton;
    
    
    CGRect rect=[UIScreen mainScreen].bounds;
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(20, 20, rect.size.width-40, 60)];
    nameField.delegate=self;
    nameField.borderStyle=UITextBorderStyleRoundedRect;
    nameField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    if ([CurrentUserManager sharedInstance].nickName) {
        nameField.text=[CurrentUserManager sharedInstance].nickName;
    }
    else
        nameField.placeholder=NSLocalizedString(@"Input your name", nil);
    [nameField becomeFirstResponder];
    
    [self.view addSubview:nameField];
    
}

-(void)Done
{
    [CurrentUserManager sharedInstance].nickName=nameField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [textField resignFirstResponder];//查一下resign这个单词的意思就明白这个方法了
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
