//
//  HMBannerView.h
//  HMBannerViewDemo
//
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BannerViewScrollDirection)
{
    // 水平滚动
    ScrollDirectionLandscape,
    // 垂直滚动
    ScrollDirectionPortait
};

typedef NS_ENUM(NSInteger, BannerViewPageStyle)
{
    PageStyle_None,
    PageStyle_Left,
    PageStyle_Right,
    PageStyle_Middle
};


@protocol HMBannerViewDelegate;

@interface HMBannerView : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIButton *BannerCloseButton;

    NSInteger totalPage;
    NSInteger curPage;
}


@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) id <HMBannerViewDelegate> delegate;

// 存放所有需要滚动的图片名字
@property (nonatomic, strong) NSArray *imageNamesArray;
// scrollView滚动的方向
@property (nonatomic, assign) BannerViewScrollDirection scrollDirection;

@property (nonatomic, assign) NSTimeInterval rollingDelayTime;

- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images;
- (void)startRolling;
- (void)stopRolling;
- (void)refreshScrollView;

// 从服务器下载 业务介绍 广告图成功后，刷新滚动视图
- (void)updateCycleScrollView:(NSArray *)array;

@end

@protocol HMBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(HMBannerView *)bannerView didSelectImageView:(NSInteger)index;
@end
