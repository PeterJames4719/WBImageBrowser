//
//  WBImageZoomScrollView.h
//  WBImageBrowser
//
//  Created by wubing on 16/6/14.
//  Copyright © 2016年 wubing. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WBImageBrowser_PlaceHolderImageName @"placeHolder.png"


@interface WBImageZoomScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void (^tappedBlock) (void);
@end
