//
//  GAXMLModel.h
//  GroupAdvertiseComponent
//
//  Created by syc on 16/8/24.
//  Copyright © 2016年 ND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GAXMLModel : NSObject
/**
 *  内容文本text
 */
@property (nonatomic, copy) NSString *text;

/**
 * 内容图片地址src
 */
@property (nonatomic, copy) NSString *src;

/**
 *  内容图片类型mime
 */
@property (nonatomic, copy) NSString *mime;

/**
 *   内容图片宽width
 */
@property (nonatomic, copy) NSString *width;

/**
 *   内容图片高height
 */
@property (nonatomic, copy) NSString *height;

/**
 *   内容图片大小size
 */
@property (nonatomic, copy) NSString *size;

/**
 *  内容图片说明alt
 */
@property (nonatomic, copy) NSString *alt;
/**
 *  内容style
 */
@property (nonatomic, copy) NSString *style;

/**
 *  内容image
 */
@property (nonatomic, strong) UIImage *image;



/**
 获取XMLModel

 @param text 文本信息
 @param src 图片地址
 @param mimei 内容图片类型mime
 @param width 内容图片宽
 @param height 内容图片高
 @param size  内容图片大小size
 @param alt 内容图片说明alt
 @param style 内容style
 @return 内容image
 */
+(id)getXMLModelWithContentText:(NSString *)text
                       imageSrc:(NSString *)src
                      imageMime:(NSString *)mimei
                    imageWidth:(NSString *)width
                    imageHeight:(NSString *)height
                    imageSize:(NSString *)size
                    imageAlt:(NSString *)alt
                    imageStyle:(NSString *)style;
@end
