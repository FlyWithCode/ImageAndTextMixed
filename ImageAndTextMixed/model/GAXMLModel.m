//
//  GAXMLModel.m
//  GroupAdvertiseComponent
//
//  Created by syc on 16/8/24.
//  Copyright © 2016年 ND. All rights reserved.
//

#import "GAXMLModel.h"

@implementation GAXMLModel

- (id)initWithContentText:(NSString *)text imageSrc:(NSString *)src imageMime:(NSString *)mime imageWidth:(NSString *)width imageHeight:(NSString *)height imageSize:(NSString *)size imageAlt:(NSString *)alt imageStyle:(NSString *)style{
    if (self = [super init]) {
        _text = [text copy];
        _src = [src copy];
        _mime = [mime copy];
        _width = [width copy];
        _height = [height copy];
        _size = [size copy];
        _alt = [alt copy];
        _style = [style copy];
    }
    return self;
}

+(id)getXMLModelWithContentText:(NSString *)text imageSrc:(NSString *)src imageMime:(NSString *)mime imageWidth:(NSString *)width imageHeight:(NSString *)height imageSize:(NSString *)size imageAlt:(NSString *)alt imageStyle:(NSString *)style{
    return [[self alloc]initWithContentText:text imageSrc:src imageMime:mime imageWidth:width imageHeight:height imageSize:size imageAlt:alt imageStyle:style];
}

@end
