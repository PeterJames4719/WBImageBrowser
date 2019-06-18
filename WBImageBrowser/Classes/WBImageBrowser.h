//
//  WBImageBrowser.h
//  WBImageBrowser
//
//  Created by wubing on 16/6/14.
//  Copyright © 2016年 wubing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBImageZoomScrollView.h"

@interface WBImageBrowser : UIView
@property (nonatomic, copy) void (^hideBlock) (void);
@property (nonatomic, copy) void (^saveImageCallBack) (NSError *error);
@property (nonatomic, assign) NSInteger currentPage;

+ (void)wb_showWithFrame:(CGRect)frame onView:(UIView *)view images:(NSArray *)imagesArray index:(NSInteger)index animated:(BOOL)animated hideBlock:(void (^) (void))block saveImageCallBack:(void (^)(NSError *error))saveCallback;

- (void)wb_reloadWithImages:(NSArray *)imagesArray index:(NSInteger)index;
@end
