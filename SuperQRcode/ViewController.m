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
  
    
    self.imageView1.image = [UIImage createQRCode:@"http://www.baidu.com" andSize:CGSizeMake(200, 200) andColor:[UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:1] andLogoImageName:@"123"];
    
    self.imageView2.image = [UIImage createQRCode:@"http://www.baidu.com" andSize:CGSizeMake(200, 200) andColor:[UIColor colorWithRed:0.5 green:0.8 blue:0 alpha:1] andLogoImageName:@"123"];
    [UIImage setImageViewShadow:_imageView1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
