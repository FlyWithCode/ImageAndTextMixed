//
//  GAEditPhoto.h
//  GroupAdvertiseComponent
//
//  Created by syc on 17/5/11.
//  Copyright © 2016年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAEditPhoto : UIView
@property (nonatomic,strong) UIImage *addImage;
@property (nonatomic,strong) UIImageView *addImageView;
@property (nonatomic,strong) UIButton *deleButton;
@property (nonatomic,strong) UIImageView *lodingImageView;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIView *upFailView;
@property (nonatomic,strong) UIButton *upFailButton;
@property (nonatomic,strong) UILabel *upFailLable;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIButton *phtoDeleButton;;


- (void)creatImageViewWith:(UIImage *)image andWidth:(CGFloat)width;
- (void)addingLoadingView;
- (void)addingDeleButton;
- (void)addingUpfailView;
- (void)setPhtoDeleButton;
- (void)hideUpfailView;
- (void)showUpfailView;
- (void)showLoadingView;
- (void)hideLoadingView;
@end

