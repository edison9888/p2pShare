//
//  AddRecordViewController.h
//  p2pShare
//
//  Created by  jacob on 13-7-20.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "SZTextView.h"

@interface AddRecordViewController : UIViewController<UITextViewDelegate,UIScrollViewDelegate>


@property(nonatomic,strong)     UILabel *titleLabel;
@property(nonatomic,strong)     UIScrollView *scollView;
@property(nonatomic,strong)     SZTextView *textView;
@property(nonatomic, strong)     Topic *item;


-(void)addRecord;
@end
