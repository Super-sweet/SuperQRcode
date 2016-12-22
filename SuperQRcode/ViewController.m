//
//  ViewController.m
//  SuperQRcode
//
//  Created by xuchao on 2016/12/21.
//  Copyright © 2016年 xuchao. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+SuperQRCode.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //设置图片和RGB值
    self.imageView1.image = [UIImage createQRCode:@"http://www.baidu.com" andSize:CGSizeMake(200, 200) andColor:[UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:1] andLogoImageName:@"123"];
    //如果不生成logo 图片传入nil
    self.imageView2.image = [UIImage createQRCode:@"http://www.baidu.com" andSize:CGSizeMake(200, 200) andColor:[UIColor colorWithRed:0.5 green:0.8 blue:0 alpha:1] andLogoImageName:@"123"];
    //给图片添加阴影效果
    [UIImage setImageViewShadow:_imageView1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
