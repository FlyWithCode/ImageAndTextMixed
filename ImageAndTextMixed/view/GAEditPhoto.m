//
//  GAEditPhoto.m
//  GroupAdvertiseComponent
//
//  Created by syc on 16/8/16.
//  Copyright © 2016年 ND. All rights reserved.
//
#define LodingViewHeight 2
#define DeleButtonW_H 30
#define UpfailButtonW_H 50
#define UpfailSpace 6
#define ImageOffset 40
#define ImageUPOffset 20
#define ImageBottomOffset 20
#define LoadImageW_H  45

#import "GAEditPhoto.h"
#import <Masonry/Masonry.h>
#import <libextobjc/EXTScope.h>
@interface GAEditPhoto ()
@property (nonatomic,assign)  CGFloat width;
@end
@implementation GAEditPhoto
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}
- (void)creatImageViewWith:(UIImage *)image andWidth:(CGFloat)width{
    _width = width;
    [self addSubview:self.addImageView];
     @weakify(self);
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(_width);
    }];
    self.addImageView.userInteractionEnabled = YES;
    self.addImageView.image = image;
    self.addImage = image;
   
}

- (void)showLoadingView{
    self.maskView.hidden = NO;
    self.loadingView.hidden = NO;
}

- (void)hideLoadingView{
    self.maskView.hidden = YES;
    self.loadingView.hidden = YES;

}
- (void)addingLoadingView{
    [self addSubview:self.maskView];
    [self addSubview:self.loadingView];
    [self.loadingView addSubview:self.lodingImageView];
    @weakify(self);
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(_width);
    }];
    [self.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(10);
        make.width.mas_equalTo(LoadImageW_H);
        make.height.mas_equalTo(LoadImageW_H);
    }];
    [self.lodingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.loadingView);
        make.leading.equalTo(self.loadingView);
        make.trailing.equalTo(self.loadingView);
        make.height.mas_equalTo(LoadImageW_H);
    }];
//    self.lodingImageView.image = GAComponentImage(@"general_load_medium_special.png");
}

//暂时未用
- (void)addingLineLoadingView{
    [self addSubview:self.loadingView];
    [self addSubview:self.lodingImageView];
    @weakify(self);
    [self.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.height.mas_equalTo(LodingViewHeight);
    }];
    [self.lodingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.loadingView);
        make.leading.equalTo(self.loadingView);
        make.trailing.equalTo(self.loadingView);
        make.height.mas_equalTo(LodingViewHeight);
    }];
}

- (void)addingDeleButton{
    [self addSubview:self.deleButton];
    @weakify(self);
    [self.deleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top).offset(LodingViewHeight);
        make.trailing.equalTo(self.mas_trailing).offset(-LodingViewHeight);
        make.height.mas_equalTo(DeleButtonW_H);
        make.width.mas_equalTo(DeleButtonW_H);
    }];
    
}

//暂时未用
- (void)setPhtoDeleButton{
    [self.addImageView addSubview:self.phtoDeleButton];
    @weakify(self);
    [self.phtoDeleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.addImageView.mas_top).offset(LodingViewHeight+ImageUPOffset);
        make.trailing.equalTo(self.addImageView.mas_trailing).offset(-LodingViewHeight);
        make.height.mas_equalTo(DeleButtonW_H);
        make.width.mas_equalTo(DeleButtonW_H);
    }];
}

-(void)hideUpfailView{
    self.maskView.hidden = YES;
    self.upFailView.hidden = YES;
}

-(void)showUpfailView{
    self.maskView.hidden = NO;
    self.upFailView.hidden = NO;
    
}


- (void)addingUpfailView{
    [self addSubview:self.maskView];
    [self addSubview:self.upFailView];
    [self.upFailView addSubview:self.upFailButton];
    [self.upFailView addSubview:self.upFailLable];
    CGSize textSize = [self.upFailLable.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:10.0] }];
    CGFloat upFailViewHeight = textSize.height + UpfailButtonW_H + UpfailSpace;
    CGFloat upFailViewWidth = textSize.width ;
    CGFloat upLableHeight = textSize.height;
    @weakify(self);
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(_width);
    }];
    [self.upFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(10);
        make.width.mas_equalTo(upFailViewWidth);
        make.height.mas_equalTo(upFailViewHeight);
    }];
    [self.upFailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.upFailView);
        make.centerX.equalTo(self.upFailView.mas_centerX);
        make.height.mas_equalTo(UpfailButtonW_H);
        make.width.mas_equalTo(UpfailButtonW_H);
    }];

    [self.upFailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.upFailButton.mas_bottom).offset(UpfailSpace);
        make.centerX.equalTo(self.upFailView.mas_centerX);
        make.height.mas_equalTo(upLableHeight);
        make.width.mas_equalTo(upFailViewWidth);
    }];

}

- (UIView *)loadingView{
    
    if (!_loadingView) {
        _loadingView = [[UIView alloc]init];
        //_loadingView.backgroundColor = GACSkin_COLOR_KEY_8;
    }
    return _loadingView;
}

- (UIImageView *)lodingImageView{
    
    if(!_lodingImageView){
        _lodingImageView = [[UIImageView alloc]init];
        //_lodingImageView.backgroundColor = GACSkin_COLOR_KEY_14;
    }
    return _lodingImageView;
}

- (UIButton *)deleButton{
    
    if (!_deleButton) {
        _deleButton = [[UIButton alloc]init];
        _deleButton.backgroundColor = [UIColor clearColor];
        [_deleButton setImage:[UIImage imageNamed:@"general_picture_icon_close_normal.png"] forState:UIControlStateNormal];
        [_deleButton setImage:[UIImage imageNamed:@"general_picture_icon_close_pressed.png"]forState:UIControlStateHighlighted];
    }
    return _deleButton;
}

- (UIView *)upFailView{
    if (!_upFailView) {
        _upFailView = [[UIView alloc]init];
        _upFailView.backgroundColor = [UIColor clearColor];
    }
    return _upFailView;
}


- (UIButton *)upFailButton{
    
    if (!_upFailButton) {
        _upFailButton = [[UIButton alloc]init];
        _upFailButton.backgroundColor = [UIColor clearColor];
        //general_web_icon_refresh_normal.png general_web_icon_refresh_pressed
        [_upFailButton setImage:[UIImage imageNamed:@"general_picture_icon_reupload.png"] forState:UIControlStateNormal];
        [_upFailButton setImage:[UIImage imageNamed:@"general_picture_icon_reupload.png"] forState:UIControlStateHighlighted];
    }
    return _upFailButton;
}

- (UIButton *)phtoDeleButton{
    
    if (!_phtoDeleButton) {
        _phtoDeleButton = [[UIButton alloc]init];
        _phtoDeleButton.backgroundColor = [UIColor clearColor];
        [_phtoDeleButton setImage:[UIImage imageNamed:@"general_picture_icon_close_normal.png"]forState:UIControlStateNormal];
        [_phtoDeleButton setImage:[UIImage imageNamed:@"general_picture_icon_close_pressed.png"] forState:UIControlStateHighlighted];
    }
    return _phtoDeleButton;
}

- (UILabel *)upFailLable{
    if (!_upFailLable) {
        _upFailLable = [[UILabel alloc]init];
        _upFailLable.text = @"上传失败";
        _upFailLable.font = [UIFont systemFontOfSize:17.0];
        _upFailLable.textColor = [UIColor blackColor];
    }
    return _upFailLable;
}

- (UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    return _maskView;
}

- (UIImageView *)addImageView{
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc]init];
    }
    return _addImageView;
}


@end
