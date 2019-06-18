//
//  WBImageBrowser.m
//  WBImageBrowser
//
//  Created by wubing on 16/6/14.
//  Copyright © 2016年 wubing. All rights reserved.
//

#import "WBImageBrowser.h"

@interface WBImageBrowser()<UIScrollViewDelegate>
@end

@implementation WBImageBrowser
{
    UIScrollView *_scrollView;
    NSMutableArray *_imagesArray;
    UIButton *_saveBtn;
    UILabel *_pageLabel;
    NSInteger totalCount;
}

+ (void)wb_showWithFrame:(CGRect)frame onView:(UIView *)view images:(NSArray *)imagesArray index:(NSInteger)index animated:(BOOL)animated hideBlock:(void (^)(void))block saveImageCallBack:(void (^)(NSError *error))saveCallback {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    WBImageBrowser *browser = [[WBImageBrowser alloc] initWithFrame:frame];
    browser.hideBlock = block;
    browser.saveImageCallBack = saveCallback;
    browser.currentPage = index;
    [view addSubview:browser];
    if (animated) {
        browser.alpha = 0.1;
        [UIView animateWithDuration:0.25 animations:^{
            browser.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    [browser wb_reloadWithImages:imagesArray index:index];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        _imagesArray = [[NSMutableArray alloc] init];

        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(frame.size.width - 55, frame.size.height - 50, 35, 20);
        _saveBtn.contentMode = UIViewContentModeRight;
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
        
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.size.height - 50, 40, 20)];
        _pageLabel.font = [UIFont systemFontOfSize:16];
        _pageLabel.textColor = [UIColor whiteColor];
        [self addSubview:_pageLabel];
        
    }
    return self;
}

- (void)wb_reloadWithImages:(NSArray *)imagesArray index:(NSInteger)index
{
    if (index < 0 || index >= imagesArray.count) {
        index = 0;
    }
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imagesArray removeAllObjects];
    [_imagesArray addObjectsFromArray:imagesArray];
    
    NSInteger pageCount = _imagesArray.count;
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGFloat pageHeight = _scrollView.bounds.size.height;
    _scrollView.contentSize = CGSizeMake(pageCount * pageWidth, pageHeight);
    _scrollView.contentOffset = CGPointMake(pageWidth * index, 0);
    
    for (NSInteger i = 0; i < pageCount; i++)
    {
        WBImageZoomScrollView *zoomScrollView = [[WBImageZoomScrollView alloc] initWithFrame:CGRectMake(pageWidth * i, 0, pageWidth, pageHeight)];
        zoomScrollView.maximumZoomScale = 3;
        zoomScrollView.image = _imagesArray[i];
        [_scrollView addSubview:zoomScrollView];
        __weak typeof(self) weakSelf = self;
        zoomScrollView.tappedBlock = ^{
            [weakSelf hide];
        };
    }
    totalCount = imagesArray.count;
    _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", index + 1, totalCount];
}

- (void)hide {
    if (self.hideBlock) {
        self.hideBlock();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)saveImage {
    NSArray *subviews = _scrollView.subviews;
    if (self.currentPage < subviews.count) {
        WBImageZoomScrollView *zoomView = subviews[self.currentPage];
        if ([zoomView isKindOfClass:[WBImageZoomScrollView class]]) {
            UIImage *img = zoomView.imageView.image;
            if (img) {
                UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSLog(@"photos currentPage:%zd", page);
    self.currentPage = page;
    _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.currentPage + 1, totalCount];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (self.saveImageCallBack) {
        self.saveImageCallBack(error);
    }
}

@end
