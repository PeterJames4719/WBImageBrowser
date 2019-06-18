//
//  WBImageZoomScrollView.m
//  WBImageBrowser
//
//  Created by wubing on 16/6/14.
//  Copyright © 2016年 wubing. All rights reserved.
//

#import "WBImageZoomScrollView.h"
#import <UIImageView+WebCache.h>

@implementation WBImageZoomScrollView
{
    //UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        //_imageView.layer.borderWidth = 2;
        //_imageView.layer.borderColor = [UIColor redColor].CGColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    if (self.tappedBlock) {
        self.tappedBlock();
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)setImage:(NSString *)image
{
    if ([image hasPrefix:@"http"])
    {
        if (![image isEqualToString:_image])
        {
            _image = image;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:_image] placeholderImage:[UIImage imageNamed:WBImageBrowser_PlaceHolderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
    }
    else
    {
        if (![image isEqualToString:_image])
        {
            _image = image;
            _imageView.image = [UIImage imageNamed:_image];
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
