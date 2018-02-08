//
//  UIImage+GAImage.h
//  GroupAdvertiseComponent
//
//  Created by syc on 16/8/16.
//  Copyright © 2016年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GAImage)

/**
 缩放图片
 
 @param size 缩放的size
 @return 缩放后的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 改变图片的透明度
 
 @param alpha 透明度
 @param image 图片
 @return 改变后的图片
 */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;
@end
