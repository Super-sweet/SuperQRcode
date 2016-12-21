//
//  UIImage+SuperQRCode.h
//  Wifi
//
//  Created by xuchao on 2016/12/21.
//  Copyright © 2016年 xuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SuperQRCode)

/**
 二维码生成器

 @param string 要生成的二维码字符
 @param size   生成的二维码size
 @param color  二维码的颜色 用RGB格式
 @param imageName 中间logo的图片名称
 @return QRCode
 */
+ (UIImage *)createQRCode:(NSString *)string andSize:(CGSize)size andColor:(UIColor *)color andLogoImageName:(NSString *)imageName;


/**
 给图片添加阴影

 @param view imageView
 */
+ (void)setImageViewShadow:(UIImageView *)view;
@end
