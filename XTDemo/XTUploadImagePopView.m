//
//  XTUploadImagePopView.m
//  XTDemo
//
//  Created by 夏天 on 2023/5/16.
//

#import "XTUploadImagePopView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "SDPhotoBrowser.h"

#define kScreenW UIScreen.mainScreen.bounds.size.width
#define kScreenH UIScreen.mainScreen.bounds.size.height
#define kw(x) (375.0/kScreenW*x)
#define kKeyWindow [UIApplication sharedApplication].windows.firstObject

@interface XTUploadImagePopView ()<TZImagePickerControllerDelegate, SDPhotoBrowserDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIColor *nColor;
@property (nonatomic, strong) UIColor *sColor;
@property (nonatomic, copy) void(^blockAction)(NSString *title, UIImage *img);
@end

@implementation XTUploadImagePopView

+ (void)showSelectImagePopView:( void(^)(NSString *title, UIImage *img) )blockAction{
    
    XTUploadImagePopView *popView = [[XTUploadImagePopView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    popView.alpha = 0;
    popView.nColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    popView.sColor = [UIColor orangeColor];
    popView.blockAction = blockAction;
    [kKeyWindow addSubview:popView];
    
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(kw(15), kw(160), kScreenW - kw(30), kw(300))] ;
    cView.layer.cornerRadius = kw(8);
    cView.backgroundColor = [UIColor whiteColor];
    popView.contentView = cView;
    [popView addSubview:popView.contentView];
    
    [popView bulidUI];
    
    [UIView animateWithDuration:0.25 animations:^{
        popView.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)dismiss{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UITextField *)textField{
    if (!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kw(15), kw(15), kScreenW - kw(60), kw(40))];
        _textField.font = [UIFont systemFontOfSize:kw(14)];
        _textField.placeholder = @"请输入一些描述(*)";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, kw(39), kScreenW - kw(60), 1);
        layer.backgroundColor = [UIColor grayColor].CGColor;
        [_textField.layer addSublayer:layer];
    }
    return _textField;
}

- (UIButton *)bulidBtnWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.layer.cornerRadius = kw(5);
    btn.titleLabel.font = [UIFont systemFontOfSize:kw(16)];
    btn.backgroundColor = self.nColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)bulidUI{
    
    [self.contentView addSubview:self.textField];
    
    CGFloat cW = self.contentView.bounds.size.width;
    CGFloat cH = self.contentView.bounds.size.height;
    CGFloat bW = (cW - kw(45))/2.0;
    CGFloat bH = kw(40);
    UIButton *cleanBtn = [self bulidBtnWithFrame:CGRectMake(kw(15), cH - kw(50), bW, bH) title:@"取 消" action:@selector(dismiss)];
    [self.contentView addSubview:cleanBtn];
    
    self.sureButton = [self bulidBtnWithFrame:CGRectMake(kw(30) + bW, cH - kw(50), bW, bH) title:@"上 传" action:@selector(sureAction)];
    self.sureButton.enabled = NO;
    [self.contentView addSubview:self.sureButton];
    
    
    UIImageView *addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kw(100), kw(100))];
    addImageView.center = CGPointMake(cW/2, cH/2);
    addImageView.backgroundColor = [UIColor cyanColor];
    addImageView.userInteractionEnabled = YES;
    [addImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageAction)]];
    [self.contentView addSubview:addImageView];
    
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cW - kw(30), kw(160))];
    self.imgView.clipsToBounds = YES;
    self.imgView.center = addImageView.center;
    self.imgView.userInteractionEnabled = YES;
    self.imgView.backgroundColor = [UIColor orangeColor];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.hidden = YES;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserImg)]];
    [self.contentView addSubview:self.imgView];
    
    
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(CGRectGetWidth(self.imgView.frame) - kw(20), 0, kw(20), kw(20));
    dBtn.backgroundColor = [UIColor redColor];
    [dBtn addTarget:self action:@selector(dBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:dBtn];
}

- (void)textChange{
    if (self.textField.text.length > 0 && self.imgView.image != nil){
        self.sureButton.enabled = YES;
        self.sureButton.backgroundColor = self.sColor;
    }else{
        self.sureButton.enabled = NO;
        self.sureButton.backgroundColor = self.nColor;
    }
}

/// 上传
- (void)sureAction{
    [self endEditing:YES];
    
    if (self.blockAction) {
        self.blockAction(self.textField.text, self.imgView.image);
    }
    [self dismiss];
}

/// 删除选中图片
- (void)dBtnAction{
    self.imgView.image = nil;
    self.imgView.hidden = YES;
    self.sureButton.enabled = NO;
    self.sureButton.backgroundColor = self.nColor;
}

/// 图片预览
- (void)browserImg{
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.contentView;
    browser.imageCount = 1;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.imgView.image;
}


/// 添加图片
- (void)addImageAction{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePicker.allowPickingOriginalPhoto = NO;
    [kKeyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    if (photos.count > 0){
        self.imgView.image = photos.lastObject;
        self.imgView.hidden = NO;
        
        if (self.textField.text.length > 0){
            self.sureButton.enabled = YES;
            self.sureButton.backgroundColor = self.sColor;
        }
    }
}

@end
