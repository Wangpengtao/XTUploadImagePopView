//
//  ViewController.m
//  XTDemo
//
//  Created by 夏天 on 2023/5/16.
//

#import "ViewController.h"
#import "XTUploadImagePopView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        
    [XTUploadImagePopView showSelectImagePopView:^(NSString * _Nonnull title, UIImage * _Nonnull img) {
        NSLog(@"%@", title);
    }];
}

@end
