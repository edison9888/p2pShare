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
#import "CurrentUserManager.h"
#import <QuartzCore/QuartzCore.h>


@interface AddRecordViewController ()

@end

@implementation AddRecordViewController
@synthesize item;
@synthesize textView=_textView;
@synthesize titleLabel=_titleLabel;


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
    self.title=@"fuck you \n haha";
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    UIBarButtonItem *sendButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Send", nil) style:UIBarButtonItemStyleDone target:self action:@selector(addRecord)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    self.navigationItem.rightBarButtonItem=sendButton;
    
    [self registerForKeyboardNotifications];
    
    _scollView =[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scollView.scrollEnabled=YES;
    _scollView.showsHorizontalScrollIndicator=YES;
    _scollView.showsVerticalScrollIndicator=NO;
    _scollView.delegate=self;
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width ,  self.view.frame.size.height*1.2);
    [_scollView setContentSize:newSize];
    [self.view addSubview:_scollView];
    
    _textView = [[SZTextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.returnKeyType = UIReturnKeyGo; //just as an example
	_textView.font = [UIFont systemFontOfSize:15.0f];
	_textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled=YES;
    _textView.userInteractionEnabled=YES;
    _textView.layer.borderColor = [UIColor clearColor].CGColor;
    _textView.layer.borderWidth =1.0;//该属性显示外边框
    _textView.layer.cornerRadius = 6.0;//通过该值来设置textView边角的弧度
    _textView.layer.masksToBounds = YES;
    _textView.placeholder=NSLocalizedString(@"Share interesting things", nil);
//    NSAttributedString *attribute=[[NSAttributedString alloc]initWithString:@"Letterpress" attributes:@{NSTextEffectsAttributeName:NSTextEffectsLetterpressStyle}];
    
    [_scollView addSubview:_textView];
    self.navigationItem.titleView=[self titleView];
}

-(UIView *)titleView
{
    if (!_titleLabel) {
        NSString *title=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Write post", nil),[CurrentUserManager sharedInstance].nickName];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        int titleLength=title.length;
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,10)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11,titleLength-11)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:15.0] range:NSMakeRange(0, 11)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0] range:NSMakeRange(11,titleLength-11)];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont boldSystemFontOfSize: 14.0f];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.attributedText=str;
    }

    return _titleLabel;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_textView becomeFirstResponder];
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
    if (_textView.text.length<10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"At least input 10 letters", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (item) {
        item.content=[ContentFormat newThreadWithContent:_textView.text];
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

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_textView resignFirstResponder];
    [_scollView scrollRectToVisible:_textView.bounds animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSLog(@"self.view frame set to size :%f %f , origin :%f %f",self.view.frame.size.width,self.view.frame.size.height,self.view.frame.origin.x,self.view.frame.origin.y);

    NSDictionary* info = [aNotification userInfo];
    CGPoint kbPoint = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;

    NSLog(@"contentInsex y:%f",kbPoint.y);
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navigationbarRect=self.navigationController.navigationBar.bounds;
    [_textView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, kbPoint.y-navigationbarRect.size.height-statusRect.size.height)];
    NSLog(@"textview frame set to size :%f %f , origin :%f %f",_textView.frame.size.width,_textView.frame.size.height,_textView.frame.origin.x,_textView.frame.origin.y);
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_textView setFrame:self.view.bounds];
    _textView.contentInset = UIEdgeInsetsZero;
    _textView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
