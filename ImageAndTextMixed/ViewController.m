//
//  ViewController.m
//  ImageAndTextMixed
//
//  Created by syc on 17/5/10.
//  Copyright © 2017年 syc. All rights reserved.
//


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Nav_Height 64.0f
#define InputViewBarHeight 43
#define ImageOffsize 20
#define Space 5
#define MaxTag 10000
#define Width  ScreenWidth - ImageOffsize
#define TexViewDefaultHeight 10
#define TextToImageSpace 20
#define EditePothoDefHeight 100
#define MoreHeight 80

#import "ViewController.h"
#import "GAEditPhoto.h"
#import "GAXMLModel.h"
#import "GADetialTextView.h"
#import "UIImage+GAImage.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <libextobjc/EXTScope.h>

@interface ViewController ()<UITextViewDelegate,NSTextStorageDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UILabel *placeholder;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) NSInteger deleTag;
@property (nonatomic,strong) NSMutableArray *insertImageArray;
@property (nonatomic,strong) UIWindow *keyWidow;
@property (nonatomic,strong) UIScrollView *textScroller;
@property (nonatomic,assign) CGRect newFrame;

@property (nonatomic,assign) NSInteger iamgeViewTag;
@property (nonatomic,assign) ObjectType objectType;
@property (nonatomic,assign) BOOL isDeaultTextView;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,strong) NSMutableArray *insertObjecArray;
@property (nonatomic,strong) NSMutableArray *defaultTextViewArray;

@property (nonatomic,assign) BOOL isEditeTextView;
@property (nonatomic,assign) CGFloat currentScrheight;
@property (nonatomic,assign) BOOL isShowKeyBoard;
@property (nonatomic,assign) BOOL showingKeyBord;


@end

@implementation ViewController

- (void)dealloc{
    [self removeobserverForKeyBord];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图文混排";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initData];
    [self setRightBarButtonItem];
    [self configUI];
    [self addKeyBordNotifiy];
}

#pragma mark -- UI

-(void)configUI{
    [self.view addSubview:self.textScroller];
    @weakify(self);
    [self.textScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        make.height.mas_equalTo(ScreenHeight-Nav_Height);
    }];
    //默认的textview
    GADetialTextView *defaultTextView =  [self creatTxetViewWithObject:self.textScroller text:nil type:ObjectofTextView];
    defaultTextView.textAlignment = NSTextAlignmentLeft;
    self.placeholder.hidden = NO;
    [self.defaultTextViewArray addObject:defaultTextView];
    [self.view addSubview:self.inputView];
}


- (void)initData {
    self.insertImageArray = [[NSMutableArray alloc]init];
    self.keyWidow = [UIApplication sharedApplication].keyWindow;
    _isEditeTextView = NO;
    _iamgeViewTag = MaxTag;
    _deleTag = MaxTag*2;
    _isShowKeyBoard = NO;
    _currentScrheight = 0;
    //需要创建默认texvie时就设为yes
    _isDeaultTextView = YES;
    _isFirst = YES;
    self.insertObjecArray = [[NSMutableArray alloc]init];
    self.defaultTextViewArray = [[NSMutableArray alloc]init];
}

-(void)setRightBarButtonItem{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    rightButton.backgroundColor=[UIColor clearColor];
    [rightButton addTarget:self action:@selector(onRightBarItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"点击添加图片" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
   
}



#pragma mark -- Action

-(void)onRightBarItemClicked{
    //相册
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)addKeyBordNotifiy {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeobserverForKeyBord{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

#pragma mark--CreatCompoment

/**
 创建文本控件

 @param object 参照对象
 @param text 文本
 @param type 类型
 @return GADetialTextView
 */
- (GADetialTextView * )creatTxetViewWithObject:(id)object
                                          text:(NSString *)text
                                          type:(ObjectType)type {
    GADetialTextView *textView = [[GADetialTextView alloc]init];
    [textView addSubview:self.placeholder];
    textView.textAlignment = NSTextAlignmentLeft;
    self.placeholder.hidden = YES;
    if (_isDeaultTextView) {
        self.placeholder.hidden = NO;
    }
    if (!_isDeaultTextView) {
        [self.insertObjecArray addObject:textView];
    }
    _isDeaultTextView = NO;
    textView.text = text;
    textView.font = [UIFont systemFontOfSize:17.0];
    CGFloat height = [textView sizeThatFits:CGSizeMake(Width, CGFLOAT_MAX)].height;
    if (!height) {
        height = TexViewDefaultHeight;
    }
    textView.backgroundColor = [UIColor whiteColor];
    textView.textContainerInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    textView.delegate = self;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    //[textView becomeFirstResponder];
    [self.textScroller addSubview:textView];
    UIView *viewObject = nil;
    UITextView *textViewObject = nil;
    UIScrollView *scrollerObject = nil;
    
    switch (type) {
        case ObjectofUIview:{
            viewObject = (UIView *)object;
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(viewObject.mas_bottom).offset(TextToImageSpace);
                make.height.mas_equalTo(height);
                make.centerX.equalTo(self.textScroller);
                make.width.mas_equalTo(Width);
            }];
        }
            break;
        case ObjectofScrollerView:{
            scrollerObject = (UIScrollView *)object;
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(scrollerObject.mas_top).offset(TextToImageSpace);
                make.height.mas_equalTo(height);
                make.centerX.equalTo(scrollerObject);
                make.width.mas_equalTo(Width);
            }];
        }
            break;
        case ObjectofTextView:{
            textViewObject = (UITextView *)object;
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(textViewObject.mas_bottom).offset(TextToImageSpace);
                make.height.mas_equalTo(height);
                make.centerX.equalTo(self.textScroller);
                make.width.mas_equalTo(Width);
            }];
        }
            break;
        default:
            break;
    }
    [self performSelector:@selector(gettingFrame) withObject:nil afterDelay:0.5];
    return textView;
    
}

- (void)gettingFrame{
    CGFloat height ;
    _isEditeTextView = NO;
    if (!_isFirst) {
        //默认只有一个texview
        _isFirst = YES;
        GADetialTextView *defaultTextView = [self.defaultTextViewArray firstObject];
        height = defaultTextView.frame.origin.y + defaultTextView.frame.size.height;
        [self changeTextStrollerContentSizeWithHeight:height];
    }else{
        for ( int i  = 0 ; i < self.insertObjecArray.count; i++) {
            if ([[self.insertObjecArray objectAtIndex:i] isKindOfClass:[GAEditPhoto class]]) {
                GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:i];
                height = photo.frame.origin.y + photo.frame.size.height;
                [self changeTextStrollerContentSizeWithHeight:height];
            }else{
                GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:i];
                height = textView.frame.origin.y + textView.frame.size.height;
                [self changeTextStrollerContentSizeWithHeight:height];
            }
        }
    }
}


/**
 创建图片控件

 @param object 参照对象
 @param size 图片size
 @param model GAXMLModel
 @param image 图片
 @param type 类型
 @return GAEditPhoto
 */
- (GAEditPhoto *)creatPhotoViewWithObject:(id)object
                                iamgeSize:(CGSize)size
                                    model:(GAXMLModel *)model
                                    image:(UIImage*)image
                                     type:(ObjectType)type {
    NSString *url = model.src;
    GAEditPhoto *showPhoto = [[GAEditPhoto alloc]init];
    showPhoto.tag = _iamgeViewTag;
    _iamgeViewTag ++;
    [self.insertObjecArray addObject:showPhoto];
    self.objectType =  ObjectofUIview;
    showPhoto.backgroundColor = [UIColor whiteColor];
    [self.textScroller addSubview:showPhoto];
    CGFloat imageMinHeight = 50;
    CGFloat height = EditePothoDefHeight;
    if (image) {
        if (image.size.height <= imageMinHeight) {
            image = [image scaleToSize:CGSizeMake(image.size.width * imageMinHeight /image.size.height, imageMinHeight)];
            height = image.size.height;
        }else{
            height = image.size.height;
        }
        
    }else if (model.height) {
        height = [model.height floatValue];
    }
    UIView *viewObject = nil;
    UITextView *textViewObject = nil;
    UIScrollView *scrollerObject = nil;
    @weakify(self);
    switch (type) {
        case ObjectofUIview:{
            viewObject = (UIView *)object;
            [showPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(viewObject.mas_bottom).offset(TextToImageSpace);
                make.height.mas_equalTo(height);
                make.centerX.equalTo(self.textScroller);
                make.width.mas_equalTo(Width);
            }];
        }
            break;
        case ObjectofScrollerView:{
            scrollerObject = (UIScrollView *)object;
            [showPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(scrollerObject.mas_top).offset(TextToImageSpace);
                make.height.mas_equalTo(height);
                make.centerX.equalTo(self.textScroller);
                make.width.mas_equalTo(Width);
            }];
            
        }
            break;
        case ObjectofTextView:{
            textViewObject = (UITextView *)object;
            [showPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(textViewObject.mas_bottom).offset(TextToImageSpace);
                make.height.mas_equalTo(height);
                make.centerX.equalTo(self.textScroller);
                make.width.mas_equalTo(Width);
            }];
            
        }
            break;
        default:
            break;
    }
    
    [showPhoto.deleButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    if (image) {
        [showPhoto creatImageViewWith:image andWidth:image.size.width];
        [self.insertImageArray addObject:image];
        [showPhoto addingDeleButton];
        showPhoto.deleButton.tag = _deleTag;
        _deleTag++;
    }
    
    return showPhoto;
}

#pragma mark--InsertCompoment

- (void)insertNewImageWithImage:(UIImage *)image model:(GAXMLModel *)model{
    //  插入图片
    GAEditPhoto *photo = nil;
    GADetialTextView *textView = nil;
    if (self.insertObjecArray.count > 0) {
        //规避容器中没有视图的情况 以上个视图为参照物
        if ([[self.insertObjecArray lastObject] isKindOfClass:[GAEditPhoto class]]) {
            //得到布局参照物
            photo =(GAEditPhoto*)[self.insertObjecArray lastObject];
            // 插入图片 并且要在后面放一个默认的textview
            GAEditPhoto *newPhoto = [self creatPhotoViewWithObject:photo iamgeSize:image.size model:model image:image type:ObjectofUIview];
            [self creatTxetViewWithObject:newPhoto text:@"" type:ObjectofUIview];
            self.placeholder.hidden = YES;
        }else{
            //得到布局参照物
            textView =(GADetialTextView*)[self.insertObjecArray lastObject];
            if (textView.text.length == 0) {
                [self.insertObjecArray removeObject:textView];
                [textView removeFromSuperview];
                // 插入图片 并且要在后面放一个默认的textview
                id object = nil;
                photo = [self.insertObjecArray lastObject];
                if (photo) {
                    object = photo;
                }else{
                    object = self.textScroller;
                }
                GAEditPhoto *newPhoto = [self creatPhotoViewWithObject:object iamgeSize:image.size model:model image:image type:ObjectofUIview];
                [self creatTxetViewWithObject:newPhoto text:@"" type:ObjectofUIview];
                self.placeholder.hidden =YES;
            }else{
                // 插入图片 并且要在后面放一个默认的textview
                GAEditPhoto *newPhoto = [self creatPhotoViewWithObject:textView iamgeSize:image.size model:model image:image type:ObjectofTextView];
                [self creatTxetViewWithObject:newPhoto text:@"" type:ObjectofUIview];
                self.placeholder.hidden = YES;
            }
        }
    }else{
        //容器中没有视图 以容器为参照物 因默认是一个textview 当插入图片时移除默认的textview 创建图片
        GADetialTextView *defaultTextView = [self.defaultTextViewArray firstObject];
        if (defaultTextView.text.length == 0) {
            //默认texview 为空 则删
            [defaultTextView removeFromSuperview];
            [self.defaultTextViewArray removeAllObjects];
            photo = [self creatPhotoViewWithObject:self.textScroller iamgeSize:image.size model:model image:image type:ObjectofScrollerView];
            [self creatTxetViewWithObject:photo text:@"" type:ObjectofUIview];
        }else{
            [self.insertObjecArray addObject:defaultTextView];
            //[self.defaultTextViewArray removeAllObjects];
            photo = [self creatPhotoViewWithObject:defaultTextView iamgeSize:image.size model:model image:image type:ObjectofTextView];
            [self creatTxetViewWithObject:photo text:@"" type:ObjectofUIview];
        }
    }
    //更新容器的cosntentsize
    _isEditeTextView = NO;
    [self getInserObjectLastObjectToChangeContensize];
}

#pragma mark--DeleteCompoment

- (void)deletePhoto:(id)sender{
    UIButton *deleButton = (UIButton *)sender;
    //需要判断这个textview 是在哪个位置 若在最后一个不做操作 其他情况删除 更新布局
    NSInteger currentImageTag =  deleButton.tag - MaxTag;
    GAEditPhoto *currentPhoto = [self.textScroller viewWithTag:currentImageTag];
    NSInteger currentImageIndext = [self.insertObjecArray indexOfObject:currentPhoto];
    NSInteger count = self.insertObjecArray.count;
    if (currentImageIndext >count || currentImageIndext < 0) {
        return;
    }
    NSInteger lastIndext = currentImageIndext -1;
    NSInteger nextIndext = currentImageIndext +1;
    NSInteger finalIdext = currentImageIndext +2;
    if (!((currentImageIndext == self.insertObjecArray.count -1) ||currentImageIndext == 0)) {
        // 不是最后位置 并且也不在第一个
        id lastObject = [self.insertObjecArray objectAtIndex:lastIndext];
        id nextObject = [self.insertObjecArray  objectAtIndex:nextIndext];
        id finalObject = nil;
        if (self.insertObjecArray.count -1 >= finalIdext) {
            finalObject = [self.insertObjecArray  objectAtIndex:finalIdext];
        }
        //布局nextObject
        if ([lastObject isKindOfClass:[GADetialTextView class]]) {
            [self updateDetialTextViewBottomViewWithNextIndext:nextIndext photo:lastObject];
            GADetialTextView *lastTextview = lastObject;
            //若是两个textview就合并
            if ([nextObject isKindOfClass:[GADetialTextView class]]) {
                GADetialTextView *nextTextView = nextObject;
                lastTextview.text = [lastTextview.text stringByAppendingString:nextTextView.text];
                //改变textview的height
                CGFloat height = [lastTextview sizeThatFits:CGSizeMake(Width, CGFLOAT_MAX)].height;
                //更新当前textview的高
                [lastTextview mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
                
                if (finalObject) {
                    [finalObject mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(lastTextview.mas_bottom).offset(10);
                    }];
                    [self upadteSubViewLayoutWithObject:finalObject];
                    
                }
                [nextObject removeFromSuperview];
                [self.insertObjecArray removeObject:nextObject];
            }else if ([nextObject isKindOfClass:[GAEditPhoto class]]){
                
                [self updateDetialTextViewBottomViewWithNextIndext:nextIndext photo:lastObject];
            }
            
        }else if ([lastObject isKindOfClass:[GAEditPhoto class]]){
            [self updateEditPhotoBottomViewWithNextIndext:nextIndext photo:lastObject];
        }
        
    }else if (currentImageIndext == 0){
        //在第一个位置
        //布局nextObject
        [self updateTextScrollerBottomViewWithNextIndext:nextIndext];
    }
    
    //移除数组中的数据
    [self.insertObjecArray removeObject:currentPhoto];
    [self.insertImageArray removeObject:currentPhoto.addImageView.image];
    [currentPhoto removeFromSuperview];
    _deleTag--;
    _iamgeViewTag--;
    if (self.insertObjecArray.count == 1) {
        if ([[self.insertObjecArray firstObject] isKindOfClass:[GADetialTextView class]]){
            GADetialTextView *textView = [self.insertObjecArray firstObject];
            if (textView.textStorage.length > 0) {
                self.placeholder.hidden = YES;
            }else{
                self.placeholder.hidden = NO;
            }
            
        }
    }
    [self performSelector:@selector(updateScrollerContentsize) withObject:nil afterDelay:0.5];
}

- (void)updateScrollerContentsize{
    _isEditeTextView = NO;
    [self getInserObjectLastObjectToChangeContensize];
}



#pragma mark--updateLayout

//更新特定对象下面的布局
- (void)updateTextScrollerBottomViewWithNextIndext:(NSInteger )indext{
    //取出下个视图 更新布局
    if ([[self.insertObjecArray objectAtIndex:indext] isKindOfClass:[GAEditPhoto class]]) {
        GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:indext];
        [photo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textScroller.mas_top).offset(10);
        }];
        [self upadteSubViewLayoutWithObject:photo];
    }else{
        GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:indext];
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textScroller.mas_top).offset(10);
        }];
        [self upadteSubViewLayoutWithObject:textView];
    }
}

- (void)updateEditPhotoBottomViewWithNextIndext:(NSInteger )indext photo:(GAEditPhoto *)lastPhoto {
    //取出下个视图 更新布局
    if ([[self.insertObjecArray objectAtIndex:indext] isKindOfClass:[GAEditPhoto class]]) {
        GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:indext];
        [photo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastPhoto.mas_bottom).offset(10);
        }];
        [self upadteSubViewLayoutWithObject:photo];
    }else{
        GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:indext];
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastPhoto.mas_bottom).offset(10);
        }];
        [self upadteSubViewLayoutWithObject:textView];
    }
}

- (void)updateDetialTextViewBottomViewWithNextIndext:(NSInteger )indext photo:(GADetialTextView *)lastTextView {
    //取出下个视图 更新布局
    if ([[self.insertObjecArray objectAtIndex:indext] isKindOfClass:[GAEditPhoto class]]) {
        GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:indext];
        [photo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTextView.mas_bottom).offset(10);
        }];
        [self upadteSubViewLayoutWithObject:photo];
    }else{
        GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:indext];
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTextView.mas_bottom).offset(10);
        }];
        [self upadteSubViewLayoutWithObject:textView];
    }
}

//更新某个对象下面的所有布局
- (void)upadteSubViewLayoutWithObject:(id)object{
    //容器第一个不是texview 即当前的texview是在 self.insertObjecArray 中
    if (self.insertObjecArray.count > 0) {
        CGFloat indext = [self.insertObjecArray indexOfObject:object];
        NSInteger leftCount = self.insertObjecArray.count - indext -1;
        if (leftCount > 0) {
            for (NSInteger i = 0; i < leftCount; i++) {
                if ([[self.insertObjecArray objectAtIndex:i] isKindOfClass:[GAEditPhoto class]]) {
                    GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:i];
                    [photo mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                    }];
                }else{
                    GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:i];
                    
                    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    }];
                }
            }
        }
        //设置scrollercontensize
        [self getInserObjectLastObjectToChangeContensize];
    }
    
}


- (void)getInserObjectLastObjectToChangeContensize{
    //得到容器中最后一个视图
    if ([[self.insertObjecArray lastObject] isKindOfClass:[GAEditPhoto class]]) {
        GAEditPhoto* photo =(GAEditPhoto*)[self.insertObjecArray lastObject];
        CGFloat height = photo.frame.origin.y + photo.frame.size.height;
        [self changeTextStrollerContentSizeWithHeight:height];
    }else{
        GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray lastObject];
        if (textView) {
            CGFloat height = textView.frame.origin.y + textView.frame.size.height;
            [self changeTextStrollerContentSizeWithHeight:height];
        }
        
    }
    
}

//动态改变srollerconsize
-(void)changeTextStrollerContentSizeWithHeight:(CGFloat)height{
    CGFloat nowHeight = height+MoreHeight;
    self.textScroller.contentSize = CGSizeMake(Width, nowHeight);
    if ((nowHeight > _currentScrheight) || _isShowKeyBoard) {
        if (!_isEditeTextView) {
            _currentScrheight = nowHeight;
            [self.textScroller scrollRectToVisible:CGRectMake(0, 0, Width, nowHeight) animated:YES];
            _isEditeTextView = NO;
            _isShowKeyBoard = NO;
        }
    }
    
    
}

#pragma mark--UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //适配屏幕宽度
    NSInteger width = ScreenWidth - 20;
    UIImage *image1 = [image scaleToSize:CGSizeMake(width, image.size.height*width/image.size.width)];
    [self insertNewImageWithImage:image1 model:nil];
    [self dismissViewControllerAnimated:picker completion:nil];
}

#pragma mark---UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    GADetialTextView *lastTextView = (GADetialTextView *)[self.insertObjecArray lastObject];
    if (lastTextView == textView) {
        _isEditeTextView = NO;
    }else{
        _isEditeTextView = YES;
    }
    NSDictionary *attributes = nil;
    if (textView.text.length < 1) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 1.5;// 字体的行间距
        attributes = @{
                       NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                       NSForegroundColorAttributeName:[UIColor blackColor],
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    }
    return YES;
}



- (void)textViewDidChange:(UITextView *)textView{
    
    GADetialTextView *lastTextView = nil;
    if (self.insertObjecArray.count > 0) {
        lastTextView = (GADetialTextView *)[self.insertObjecArray lastObject];
    }else{
        lastTextView = (GADetialTextView *)[self.defaultTextViewArray firstObject];
    }
    if (textView.textStorage.length > 0 && (lastTextView != textView)) {
        _isEditeTextView = YES;
    }else{
        _isEditeTextView = NO;
    }
    //控制placeholder的显示
    if (![textView.subviews containsObject:self.placeholder]) {
        [textView addSubview:self.placeholder];
    }
    GADetialTextView *firsttextView = nil;
    GADetialTextView *defaultTextView = [self.defaultTextViewArray firstObject];
    if (self.insertObjecArray.count == 1) {
        if ([[self.insertObjecArray firstObject] isKindOfClass:[GADetialTextView class]]){
            firsttextView = [self.insertObjecArray firstObject];
            
            self.placeholder.hidden = NO;
        }
    }
    //当前texvtview是默认的
    if (textView == defaultTextView || textView == firsttextView) {
        if (textView.textStorage.length > 0 ){
            self.placeholder.hidden = YES;
        }else{
            self.placeholder.hidden = NO;
        }
    }
    //改变textview的height
    CGFloat height = [textView sizeThatFits:CGSizeMake(Width, CGFLOAT_MAX)].height;
    //更新当前textview的高
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    //容器第一个是texview
    if (self.insertObjecArray.count > 0) {
        //容器第一个是texview 并且 此时teview就是第一个默认textview
        GADetialTextView *firstTextView = nil;
        //容器第一个是texview
        if ([[self.defaultTextViewArray firstObject] isKindOfClass:[GADetialTextView class]]) {
            firstTextView = [self.defaultTextViewArray firstObject];
            //当前texvtview是默认的
            if (textView == firstTextView) {
                if (textView.textStorage.length > 0 ){
                    self.placeholder.hidden = YES;
                }else{
                    self.placeholder.hidden = NO;
                }
                //当前视图是否只有默认的这个texview
                if (self.insertObjecArray.count > 1) {
                    //还有别的视图 先更新布局
                    if (textView.text.length >0) {
                        for (NSInteger i = 0; i < self.insertObjecArray.count; i++){
                            if ([[self.insertObjecArray objectAtIndex:i] isKindOfClass:[GAEditPhoto class]]) {
                                GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:i];
                                [photo mas_updateConstraints:^(MASConstraintMaker *make) {
                                    
                                }];
                            }else{
                                GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:i];
                                [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                                }];
                            }
                            
                        }
                    }else{
                        //文字为空 删除
                        NSInteger indext =  [self.insertObjecArray indexOfObject:textView];
                        //取出下个视图 更新布局
                        NSInteger nextIndext = indext +1;
                        if (self.insertObjecArray.count >= nextIndext + 1) {
                            if ([[self.insertObjecArray objectAtIndex:nextIndext] isKindOfClass:[GAEditPhoto class]]) {
                                GAEditPhoto *photo =(GAEditPhoto*)[self.insertObjecArray objectAtIndex:nextIndext];
                                [photo mas_updateConstraints:^(MASConstraintMaker *make) {
                                    make.top.equalTo(self.textScroller.mas_top).offset(10);
                                }];
                                [self upadteSubViewLayoutWithObject:photo];
                                
                            }else{
                                GADetialTextView *textView =(GADetialTextView*)[self.insertObjecArray objectAtIndex:nextIndext];
                                [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                                    make.top.equalTo(self.textScroller.mas_top).offset(10);
                                }];
                                [self upadteSubViewLayoutWithObject:textView];
                            }
                        }
                        //移除数组中的数据
                        [self.insertObjecArray removeObject:textView];
                        [textView removeFromSuperview];
                    }
                    //设置scrollercontensize
                    [self getInserObjectLastObjectToChangeContensize];
                }else{
                    //只有默认的texview
                    [self changeTextStrollerContentSizeWithHeight:height];
                }
                
            }else{
                //不是默认的
                //容器第一个是texview 并且 此时teview不是第一个默认textview 并且也不在第一个位置
                if (textView.text.length > 0) {
                    [self upadteSubViewLayoutWithObject:textView];
                }else{
                    //需要判断这个textview 是在哪个位置 若在最后一个不做操作 其他情况删除 更新布局
                    NSInteger indext =  [self.insertObjecArray indexOfObject:textView];
                    NSInteger lastIndext = indext -1;
                    NSInteger nextIndext = indext +1;
                    id lastObject = nil;
                    if (!(indext == self.insertObjecArray.count -1)) {
                        // 不是最后位置 并且这个textview也不在第一个
                        if (lastIndext < 0) {
                            //防止上个视图不存在问题
                            lastObject = nil;
                        }else{
                            lastObject = [self.insertObjecArray objectAtIndex:lastIndext];
                        }
                        //布局nextObject
                        if (lastObject) {
                            if ([lastObject isKindOfClass:[GADetialTextView class]]) {
                                [self updateDetialTextViewBottomViewWithNextIndext:nextIndext photo:lastObject];
                            }else if ([lastObject isKindOfClass:[GAEditPhoto class]]){
                                [self updateEditPhotoBottomViewWithNextIndext:nextIndext photo:lastObject];
                            }
                        }else{
                            
                            [self updateTextScrollerBottomViewWithNextIndext:nextIndext];
                        }
                        
                        //移除数组中的数据
                        [self.insertObjecArray removeObject:textView];
                        [textView removeFromSuperview];
                    }
                }
                
            }
        }else{
            //容器第一个不是textview
            //容器第一个不是texview 并且 此时teview不是第一个默认textview
            if (textView.text.length > 0) {
                [self upadteSubViewLayoutWithObject:textView];
            }else{
                //需要判断这个textview 是在哪个位置 若在最后一个不做操作 其他情况删除 更新布局
                NSInteger indext =  [self.insertObjecArray indexOfObject:textView];
                NSInteger lastIndext = indext -1;
                NSInteger nextIndext = indext +1;
                if (!(indext == self.insertObjecArray.count -1)) {
                    // 不是最后位置 并且这个textview也不在第一个
                    id lastObject = [self.insertObjecArray objectAtIndex:lastIndext];
                    //布局nextObject
                    if ([lastObject isKindOfClass:[GADetialTextView class]]) {
                        [self updateDetialTextViewBottomViewWithNextIndext:nextIndext photo:lastObject];
                    }else if ([lastObject isKindOfClass:[GAEditPhoto class]]){
                        [self updateEditPhotoBottomViewWithNextIndext:nextIndext photo:lastObject];
                    }
                    //移除数组中的数据
                    [self.insertObjecArray removeObject:textView];
                    [textView removeFromSuperview];
                }
            }
        }
        
    }else{
        //只有默认textview时 更新scrollrer
        GADetialTextView *textView =(GADetialTextView*)[self.defaultTextViewArray firstObject];
        CGFloat height = textView.frame.origin.y + textView.frame.size.height;
        [self changeTextStrollerContentSizeWithHeight:height];
    }
    //保证最后一个textview的 placeholder 不显示
    if (self.insertObjecArray.count > 1) {
        if ([[self.insertObjecArray lastObject] isKindOfClass:[GADetialTextView class]]){
            self.placeholder.hidden = YES;
        }
    }
    [textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [scrollView endEditing:YES];
}

#pragma mark--ResetTextStyle

- (void)resetTextStyle:(UITextView *)texview{
    NSRange wholeRange = NSMakeRange(0, texview.textStorage.length);
    [texview.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [texview.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:wholeRange];
    [texview.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:wholeRange];
}


#pragma mark--keyboardAction

- (void)keyboardWillShow:(NSNotification *)aNotification{
    //_isEditeTextView = YES;
    if (_showingKeyBord) {
        //当前键盘已经是弹起状态
        _isShowKeyBoard = NO;
    }else{
        _isShowKeyBoard = YES;
    }
    _showingKeyBord = YES;
    if (self.insertObjecArray.count > 0) {
        [self getInserObjectLastObjectToChangeContensize];
    }else{
        GADetialTextView *textView =(GADetialTextView*)[self.defaultTextViewArray firstObject];
        if (textView.textStorage.length > 0) {
            _isEditeTextView = NO;
            CGFloat height = textView.frame.origin.y + textView.frame.size.height;
            [self changeTextStrollerContentSizeWithHeight:height];
        }
    }
    
    
}


- (void)keyboardWillHide:(NSNotification *)aNotification{
    //_isEditeTextView = NO;
    if (_showingKeyBord) {
        _isShowKeyBoard = NO;
    }
    _showingKeyBord = NO;
    if (self.insertObjecArray.count > 0) {
        [self getInserObjectLastObjectToChangeContensize];
    }else{
        GADetialTextView *textView =(GADetialTextView*)[self.defaultTextViewArray firstObject];
        if (textView.textStorage.length > 0) {
            _isEditeTextView = NO;
            CGFloat height = textView.frame.origin.y + textView.frame.size.height;
            [self changeTextStrollerContentSizeWithHeight:height];
        }
    }
}

- (void)keyBoardWillChageFrame:(NSNotification *)notification{
    NSDictionary * infoDict = [notification userInfo];
    CGFloat duration = [[infoDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [[infoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [[infoDict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect newFrame = self.inputView.frame;
    CGFloat offset_y = endFrame.origin.y - beginFrame.origin.y;
    //获取当前的inputview的高
    CGFloat height = CGRectGetHeight(self.inputView.frame);
    CGFloat endHeight = ScreenHeight-Nav_Height;
    height = height > InputViewBarHeight ? height : InputViewBarHeight;
    if (offset_y<0) {
        if (endFrame.origin.y < endHeight) {
            newFrame.origin.y = endHeight - endFrame.size.height-height;
        }else{//避免一些 键盘在屏幕下方浮动的现象
            newFrame.origin.y = endHeight - height;
        }
    }else{//键盘下移或消失
        if (endFrame.origin.y >= endHeight) {//键盘完全消失
            newFrame.origin.y = endHeight - height;
        }else{//键盘只是变矮了一点
            newFrame.origin.y = endHeight - endFrame.size.height - height;
        }
    }
    CGRect frame = CGRectMake(0, newFrame.origin.y, ScreenWidth, height);
    [self changeFrameAnimation:duration newFrame:frame oldFrame:self.inputView.frame];
    
}

- (void)changeFrameAnimation:(CGFloat)duration newFrame:(CGRect)newFrame oldFrame:(CGRect)oldFrame {
    @weakify(self);
    CGRect frame = self.textScroller.frame;
    frame.size.height = newFrame.origin.y;
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        self.inputView.frame = newFrame;
        @weakify(self);
        [self.textScroller mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            make.height.mas_equalTo(CGRectGetHeight(frame));
        }];
        self.textScroller.frame = frame;
    }];
    
}


#pragma mark--init

- (UILabel *)placeholder{
    if (!_placeholder) {
        CGFloat lineHeight17 = [UIFont systemFontOfSize:17.0].lineHeight;
        _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(5,-1, Width, lineHeight17)];
        _placeholder.text = @"请输入内容";
        _placeholder.font = [UIFont systemFontOfSize:17.0];
        _placeholder.textColor = [UIColor grayColor];
        _placeholder.backgroundColor = [UIColor clearColor];
    }
    return _placeholder;
}


- (UIScrollView *)textScroller{
    if (!_textScroller) {
        _textScroller = [[UIScrollView alloc]init];
        _textScroller.backgroundColor = [UIColor whiteColor];
        _textScroller.delegate = self;
    }
    return _textScroller;
}



/**
 * 是否自动旋转
 */
- (BOOL)shouldAutorotate {
    return NO; //暂时只支持默认的竖屏
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
