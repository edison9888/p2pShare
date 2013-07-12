//
//  ChooseViewController.m
//  p2pShare
//
//  Created by jacob on 12/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import "ChooseViewController.h"
#import "LocalNetworkViewController.h"

@interface ChooseViewController ()

@end

@implementation ChooseViewController

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
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)buttonClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            LocalNetworkViewController *localVC=[[LocalNetworkViewController alloc]init];
            [self.navigationController pushViewController:localVC animated:YES];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
