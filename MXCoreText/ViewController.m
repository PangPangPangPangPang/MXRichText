//
//  ViewController.m
//  MXCoreText
//
//  Created by Max on 16/1/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "ViewController.h"
#import "MXRichTextViewHeader.h"

@interface ViewController ()<UITextViewDelegate,MXRichTextViewDelegate>

@end

@implementation ViewController {
    MXRichTextView *view1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextView *textView = [UITextView new];
    [textView setFrame:CGRectMake(100, 100, 100, 100)];
    [textView setBackgroundColor:[UIColor yellowColor]];
    textView.delegate = self;
//    [self.view addSubview:textView];
    
    
    view1 = [MXRichTextView new];
    [view1.layer setBorderWidth:0.5];
    [view1.layer setBorderColor:[UIColor grayColor].CGColor];
    [view1 setFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 400)];
    [view1 setFont:[UIFont systemFontOfSize:20]];
    [view1 setLineSpace:10];
    [view1 setLineBreakMode:NSLineBreakByCharWrapping];
    view1.delegate = self;
    [self.view addSubview:view1];
    
    [view1 setText:@"哈哈哈哈啊四六级的飞教伐啦发【微笑】卡斯加发的啦丽景撒旦教伐啦发【舌头】卡斯加洒龙卷哈哈哈哈啊四六级的飞洒龙卷风的拉萨积分卡洛斯的疯狂撒了积分哈哈哈哈啊四六级的飞【酷】洒龙卷风的拉萨积分卡洛斯的疯狂撒了积分【哭泣】风的拉萨积分卡件【嘻嘻】莱卡即可水电费13269178024啥都可夫斯基额外13348695打飞机道哈"];

    UILabel *view2 = [UILabel new];
    [view2 setTextColor:[UIColor whiteColor]];
    [view2 setTextAlignment:NSTextAlignmentCenter];
    [view2 setFont:[UIFont systemFontOfSize:15]];
    [view2 setText:@"紫色"];
    [view2 setInset:UIEdgeInsetsMake(3, 4, 0, 4)];
    [view2 setSuppositionalSize:CGSizeMake(50, 30)];
    [view2 setBackgroundColor:[UIColor purpleColor]];
    [view2.layer setCornerRadius:5];
    view2.layer.masksToBounds = YES;
    [view1 insertNode:view2 atPosition:0];
    
    UILabel *view3 = [UILabel new];
    [view3 setTextColor:[UIColor whiteColor]];
    [view3 setTextAlignment:NSTextAlignmentCenter];
    [view3 setFont:[UIFont systemFontOfSize:15]];
    [view3 setText:@"绿帽子"];
    [view3 setInset:UIEdgeInsetsMake(3, 4, 0, 4)];
    [view3 setSuppositionalSize:CGSizeMake(66, 30)];
    [view3 setBackgroundColor:[UIColor greenColor]];
    [view3.layer setCornerRadius:5];
    view3.layer.masksToBounds = YES;
    [view1 insertNode:view3 atPosition:25];
    [view1 sizeToFit];
    
    UILabel *view4 = [UILabel new];
    [view4 setTextColor:[UIColor whiteColor]];
    [view4 setTextAlignment:NSTextAlignmentCenter];
    [view4 setFont:[UIFont systemFontOfSize:15]];
    [view4 setText:@"灰帽子"];
    [view4 setInset:UIEdgeInsetsMake(3, 4, 0, 4)];
    [view4 setSuppositionalSize:CGSizeMake(66, 30)];
    [view4 setBackgroundColor:[UIColor grayColor]];
    [view4.layer setCornerRadius:5];
    view4.layer.masksToBounds = YES;
    [view1 insertNode:view4 atPosition:0];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"DSC_3840.jpg"];
    [imageView setImage:image];
    [imageView setSuppositionalSize:CGSizeMake(200, 100)];
    [view1 insertNode:imageView atPosition:40];
    [view1 sizeToFit];
}

- (void)MXRichTextViewTriggerLink:(MXLinkNode *)node {
    if (node.type == telLink) {
        UIAlertController *con = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"要拨打电话 %@ 吗？",node.content] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [con addAction:confirm];
        [con addAction:cancel];
        [self presentViewController:con animated:YES completion:nil];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [view1 setText:textView.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
