//
//  NetworkViewController.m
//  p2pShare
//
//  Created by  jacob on 13-7-22.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "NetworkViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface NetworkViewController ()

@end

@implementation NetworkViewController

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
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.rightBarButtonItem=doneButton;
}

-(void)done
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.55;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionFromBottom];
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
