//
//  XTUploadImagePopView.h
//  XTDemo
//
//  Created by 夏天 on 2023/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XTUploadImagePopView : UIView

+ (void)showSelectImagePopView:( void(^)(NSString *title, UIImage *img) )blockAction;

@end

NS_ASSUME_NONNULL_END
