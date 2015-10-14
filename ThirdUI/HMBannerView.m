//
//  HMBannerView.m
//  HMBannerViewDemo
//
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//

#import "HMBannerView.h"


#define Banner_StartTag     1000

#define KPAGECTRL_WIDTH     70.0
#define KPAGECTRL_HEIGHT    20.0
#define KSPACE_10           10.0

@interface HMBannerView ()
{
    // 下载统计
    NSInteger totalCount;
}

@property (nonatomic, assign) BOOL enableRolling;


- (void)refreshScrollView;

- (NSInteger)getPageIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex;


@end

@implementation HMBannerView
@synthesize delegate;

@synthesize imageNamesArray;
@synthesize scrollDirection;

@synthesize pageControl;

- (void)dealloc
{
    delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images
{
    self = [super initWithFrame:frame];

    if(self)
    {
        self.imageNamesArray = [[NSArray alloc] initWithArray:images];

        self.scrollDirection = direction;
        totalPage = imageNamesArray.count;
        totalCount = totalPage;
        // 显示的是图片数组里的第一张图片
        // 和数组是+1关系
        curPage = 1;

        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        if (totalPage < 2)
        {
            scrollView.scrollEnabled = NO;
        }
        
        // 在水平方向滚动
        if(scrollDirection == ScrollDirectionLandscape)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        else if(scrollDirection == ScrollDirectionPortait)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }

        for (NSInteger i = 0; i < 3; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
            imageView.userInteractionEnabled = YES;
            imageView.tag = Banner_StartTag+i;

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];

            // 水平滚动
            if(scrollDirection == ScrollDirectionLandscape)
            {
                imageView.frame = CGRectOffset(imageView.frame, scrollView.frame.size.width * i, 0);
            }
            // 垂直滚动
            else if(scrollDirection == ScrollDirectionPortait)
            {
                imageView.frame = CGRectOffset(imageView.frame, 0, scrollView.frame.size.height * i);
            }
            
            [scrollView addSubview:imageView];
        }

        [self refreshScrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(self.frame.size.width - KPAGECTRL_WIDTH - KSPACE_10 * 2, self.frame.size.height - KPAGECTRL_HEIGHT, KPAGECTRL_WIDTH, KPAGECTRL_HEIGHT)];
      
        pageControl.numberOfPages = totalPage;
        pageControl.currentPage = 0;
        pageControl.currentPageIndicatorTintColor = COLOR(0, 185, 200, 1.0);
        [self addSubview:pageControl];
        
        if (totalPage < 2)
        {
            [self stopRolling];
            pageControl.hidden = YES;
        }
        else
        {
            [self startRolling];
            pageControl.hidden = NO;
        }
    }
    
    return self;
}


#pragma mark - Custom Method

- (void)refreshScrollView
{
    NSArray *curimages = [self getDisplayImagesWithPageIndex:curPage];
    
    for (NSInteger i = 0; i < curimages.count; i++)
    {
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:Banner_StartTag+i];
        if (imageView && [imageView isKindOfClass:[UIImageView class]])
        {
            [imageView sd_setImageWithURL: [NSURL URLWithString: [curimages safeObjectAtIndex:i]]];
        }
    }

    // 水平滚动
    if (scrollDirection == ScrollDirectionLandscape)
    {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (scrollDirection == ScrollDirectionPortait)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }

    self.pageControl.currentPage = curPage-1;
}

- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)page
{
    NSInteger pre = [self getPageIndex:curPage-1];
    NSInteger last = [self getPageIndex:curPage+1];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    
    [images addObject:[imageNamesArray objectAtIndex:pre-1]];
    [images addObject:[imageNamesArray objectAtIndex:curPage-1]];
    [images addObject:[imageNamesArray objectAtIndex:last-1]];
    
    return images;
}

- (NSInteger)getPageIndex:(NSInteger)index
{
    // value＝1为第一张，value = 0为前面一张
    if (index == 0)
    {
        index = totalPage;
    }

    if (index == totalPage + 1)
    {
        index = 1;
    }
    
    return index;
}

// 从服务器下载 业务介绍 广告图成功后，刷新滚动视图
- (void)updateCycleScrollView:(NSArray *)array
{
    self.imageNamesArray = [array copy];
    totalPage = array.count;
    pageControl.numberOfPages = array.count;
    // 显示的是图片数组里的第一张图片
    // 和数组是+1关系
    curPage = 1;
    
    if (array.count < 2)
    {
        pageControl.hidden = YES;
        scrollView.scrollEnabled = NO;
        [self stopRolling];
    }
    else
    {
        scrollView.scrollEnabled = YES;
         pageControl.hidden = NO;
        [self startRolling];
    }
    
    [self refreshScrollView];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;
    //NSLog(@"did  x=%d  y=%d", x, y);

    //取消已加入的延迟线程
    if (self.enableRolling)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }

    // 水平滚动
    if(scrollDirection == ScrollDirectionLandscape)
    {
        // 往下翻一张
        if (x >= 2 * scrollView.frame.size.width)
        {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }

        if (x <= 0)
        {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }
    // 垂直滚动
    else if(scrollDirection == ScrollDirectionPortait)
    {
        // 往下翻一张
        if (y >= 2 * scrollView.frame.size.height)
        {
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }

        if (y <= 0)
        {
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    //NSInteger x = aScrollView.contentOffset.x;
    //NSInteger y = aScrollView.contentOffset.y;
    
    //NSLog(@"--end  x=%d  y=%d", x, y);
    
    // 水平滚动
    if (scrollDirection == ScrollDirectionLandscape)
    {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (scrollDirection == ScrollDirectionPortait)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }

    if (self.enableRolling)
    {
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
    }
}


#pragma mark -
#pragma mark Rolling

- (void)startRolling
{
    if (self.imageNamesArray.count<2)
    {
        return;
    }

    [self stopRolling];

    self.enableRolling = YES;
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
}

- (void)stopRolling
{
    self.enableRolling = NO;
    //取消已加入的延迟线程
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction
{
    //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));

    [UIView animateWithDuration:0.25 animations:^{
        // 水平滚动
        if(scrollDirection == ScrollDirectionLandscape)
        {
            scrollView.contentOffset = CGPointMake(1.99*scrollView.frame.size.width, 0);
        }
        // 垂直滚动
        else if(scrollDirection == ScrollDirectionPortait)
        {
            scrollView.contentOffset = CGPointMake(0, 1.99*scrollView.frame.size.height);
        }
        //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    } completion:^(BOOL finished) {
        curPage = [self getPageIndex:curPage+1];
        [self refreshScrollView];

        if (self.enableRolling)
        {
            [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
        }
    }];
}



#pragma mark -
#pragma mark action

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([delegate respondsToSelector:@selector(bannerView:didSelectImageView:)])
    {
        [delegate bannerView:self didSelectImageView:curPage-1];
    }
}



@end
