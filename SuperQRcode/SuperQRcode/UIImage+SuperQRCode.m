//
//  UIImage+SuperQRCode.m
//  Wifi
//
//  Created by xuchao on 2016/12/21.
//  Copyright © 2016年 xuchao. All rights reserved.
//

#import "UIImage+SuperQRCode.h"

@implementation UIImage (SuperQRCode)

+ (UIImage *)createQRCode:(NSString *)string andSize:(CGSize)size andColor:(UIColor *)color andLogoImageName:(NSString *)imageName{
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:string] withSize:size];
    /**
     *此方法只适用于RGB颜色空间，UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
     如果是非RGB颜色空间 [UIColor grayColor]就不能用这个方法了！
     */
    const CGFloat *_components = CGColorGetComponents(color.CGColor);
    CGFloat red = _components[0] * 255.f;
    CGFloat green = _components[1] * 255.f;
    CGFloat blue = _components[2] * 255.f;
    return [self imageBlackToTransparent:qrcode withRed:red andGreen:green andBlue:blue anLogoImage:imageName];
}

+ (void)setImageViewShadow:(UIImageView *)view {
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 2;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5;
    view.backgroundColor = [UIColor clearColor];
}

#pragma mark - 创建灰度图，只有灰度图才能改变颜色
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    //    iOS不支持设备依赖颜色空间或通用颜色空间。iOS应用程序必须使用设备颜色空间
    //    设备颜色空间主要用于IOS应用程序，因为其它颜色空间无法在IOS上使用。大多数情况下，Mac OS X应用程序应使用通用颜色空间，而不使用设备颜色空间。
    //    CGColorSpaceCreateDeviceGray：创建设备依赖灰度颜色空间
    //    CGColorSpaceCreateDeviceRGB：创建设备依赖RGB颜色空间
    //    CGColorSpaceCreateDeviceCMYK：创建设备依赖CMYK颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();//这个是改变二维码颜色的主要属性，必须是灰度空间，作用是将UIImage转变成了灰度图
    
    CGContextRef bitmapRef = CGBitmapContextCreate(NULL, width, height, 8, 0, cs, kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions:NULL];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationHigh);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 创建二维码的主要代码
+ (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

#pragma mark - 改变二维码的颜色
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue anLogoImage:(NSString *)imageName{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 开启绘图, 获取图片 上下文<图片大小>
    UIGraphicsBeginImageContext(resultUIImage.size);
    // 将二维码图片画上去
    if (imageName) {
        [resultUIImage drawInRect:CGRectMake(0, 0, resultUIImage.size.width, resultUIImage.size.height)];
        // 将小图片画上去
        UIImage *smallImage = [UIImage imageNamed:imageName];
        CGFloat smallScore = MIN(resultUIImage.size.height, resultUIImage.size.width);
        smallScore = smallScore /5;
        [smallImage drawInRect:CGRectMake((resultUIImage.size.width - smallScore) / 2, (resultUIImage.size.width - smallScore) / 2, smallScore, smallScore)];
        // 获取最终的图片
        resultUIImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();

    }
    
    
    return resultUIImage;
}


@end
