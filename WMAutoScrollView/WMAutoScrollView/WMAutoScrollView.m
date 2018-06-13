//
//  WMAutoScrollView.m
//  WMAutoScrollView
//
//  Created by Zhangwenmin on 2018/6/8.
//  Copyright © 2018年 Zhangwenmin. All rights reserved.
//

#import "WMAutoScrollView.h"

@interface WMAutoScrollView()<UIScrollViewDelegate>{
    NSTimer * _timer;
}

@property(nonatomic,strong)UIScrollView * scrollview;

@property(nonatomic,strong)NSArray * imageArray;

@property(nonatomic,strong)NSArray * imageUrlArray;

@property(nonatomic,assign)NSInteger imageCount;

@property (nonatomic,assign) NSInteger currentIndext;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property(nonatomic,strong)UIPageControl * pageController;

@end

@implementation WMAutoScrollView

- (instancetype)initWMAutoScrollViewWithFrame:(CGRect)rect imageArray:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        self.imageArray = imageArray;
        self.frame = rect;
        [self setScrollViewInfoWithImageArray:imageArray];
    }
    return self;
}

- (instancetype)initWMAutoScrollViewWithFrame:(CGRect)rect imageUrlArray:(NSArray *)imageUrlArray{
    self = [super init];
    if (self) {
        self.imageUrlArray = imageUrlArray;
        self.frame = rect;
        [self setScrollViewInfoWithImageArray:imageUrlArray];
    }
    return self;
}

- (void)setScrollViewInfoWithImageArray:(NSArray *)imageArray{
    _imageCount = imageArray.count;
    self.imageViewArray = [NSMutableArray array];
    self.currentIndext = 0;
    NSInteger count = 0;
    if (imageArray.count > 1) {
        count = 3;
    }
    else{
        count = imageArray.count;
    }
    self.scrollview = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        CGFloat width = CGRectGetWidth(scrollView.bounds);
        CGFloat height = CGRectGetHeight(scrollView.bounds);
        
        scrollView.contentSize = CGSizeMake(width * count, height);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        if (imageArray.count == 1) {
            scrollView.scrollEnabled = NO;
        }
        scrollView.delegate = self;
        scrollView;
    });
    [self addSubview:self.scrollview];
    
    for (int i = 0; i < count; i ++) {
        CGFloat width = CGRectGetWidth(_scrollview.bounds);
        CGFloat height = CGRectGetHeight(_scrollview.bounds);
        
        // 创建图片视图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        imageView.userInteractionEnabled = YES;
        imageView.opaque = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSInteger index = (_currentIndext + i + _imageCount) % _imageCount;
        if (self.imageArray.count > 0) {
            UIImage * image = [UIImage imageNamed:self.imageArray[index]];
            imageView.image = image;
        }
        else{
            imageView.image = [UIImage imageNamed:@"placeholder.jgp"];//占位图
        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:tap];
        [self.scrollview addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
    [self dynimicloadingImageIndext];
}

- (void)imageClick:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag;
    if (self.imageBlock) {
        self.imageBlock(index-100);
    }
}

//加载轮播器
- (void)addPageControllerIntoScrollView{
    UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 40, self.bounds.size.width, 20)];
    
    pageController.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds) - 40);
    pageController.numberOfPages = _imageCount;
    pageController.currentPage = 0;
    pageController.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageController.pageIndicatorTintColor = [UIColor grayColor];
    
    [self addSubview:pageController];
    self.pageController = pageController;
}

//根据下标动态加载图片
- (void)dynimicloadingImageIndext{
    if (_imageCount <= 1) {
        return;
    }
    for (int i = -1; i <= 1; i ++) {
        
        NSInteger index = (_currentIndext + i + _imageCount) % _imageCount;
        //获取图片视图 [-1,1] + 1  <==> [0,2]
        UIImageView *imageView;
        imageView = _imageViewArray[i + 1];
        imageView.tag = index + 100;
        if (self.imageArray.count > 0) {
            UIImage *image = [UIImage imageNamed:self.imageArray[index]];
            imageView.image = image;
        }else{
            [self getImageWithLocalOrDownloadFromNet:index imageView:imageView];
        }
        _pageController.currentPage = _currentIndext;
    }
    self.scrollview.contentOffset = CGPointMake(CGRectGetWidth(_scrollview.bounds), 0);
    
}

- (void)pageLeft{
    _currentIndext = (--_currentIndext + _imageCount) % _imageCount;
    [self dynimicloadingImageIndext];
}

- (void)pageRight{
    _currentIndext = (++_currentIndext + _imageCount) % _imageCount;
    [self dynimicloadingImageIndext];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x <= 0) {
        [self pageLeft];
    }else if (scrollView.contentOffset.x >= 2 * CGRectGetWidth(scrollView.bounds)){
        [self pageRight];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startTimer];
}

#pragma mark Timer
- (void)startTimer{
    if (self.isAuto == NO || _imageCount == 1) {
        return;
    }
    if (_timer) {
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.second];
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.second target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}
//暂停
- (void)pauseTimer{
    if (_timer) {
        _timer.fireDate = [NSDate distantFuture];
    }
    
}
- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)handleTimer:(NSTimer *)timer{
    
    [self.scrollview setContentOffset:CGPointMake(2 * CGRectGetWidth(self.bounds), 0) animated:YES];
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.second];
}
#pragma mark setter
- (void)setIsPageController:(BOOL)isPageController{
    _isPageController = isPageController;
    if (_isPageController) {
        [self addPageControllerIntoScrollView];
    }
}

- (void)setIsAuto:(BOOL)isAuto{
    _isAuto = isAuto;
    if (_isAuto == NO) {
        [self stopTimer];
    }
    else{
        [self startTimer];
    }
}

- (void)setCurrentColor:(UIColor *)currentColor{
    _currentColor = currentColor;
    _pageController.currentPageIndicatorTintColor = currentColor;
}

- (void)setDefaultColor:(UIColor *)defaultColor{
    _defaultColor = defaultColor;
    _pageController.pageIndicatorTintColor = defaultColor;
}

#pragma mark 网络图片下载并缓存到沙盒
- (void)getImageWithLocalOrDownloadFromNet:(NSInteger)index imageView:(UIImageView *)imageView{
    //先查看缓存中是否存在图片
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"test%ld.png",index]];
    UIImage * localImage = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
    if (localImage) {
        [imageView setImage:localImage];
        return;
    }
    NSString * urlString = self.imageUrlArray[index];
    __block UIImage * image = [[UIImage alloc] init];
    dispatch_async(dispatch_queue_create("downImage",0), ^{
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:&error];
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
        //缓存
        BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
        }
    });
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
