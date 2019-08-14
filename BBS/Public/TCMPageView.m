//
//  TCMPageView.m
//  Pods-ComponentDemo
//
//  Created by ZZJ on 2019/7/11.
//

#import "TCMPageView.h"
#import <YYKit/UIImageView+YYWebImage.h>

@interface TCMPageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray <UIImageView*>*ivs;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL leftDrag;
@end
@implementation TCMPageView
@synthesize index = _index, autoScrollTime = _autoScrollTime;

-(void)layoutSubviews{
    [super layoutSubviews];
    
    ///初始化配置
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    ///设置pageControl是否使用
    if (self.images.count > 1 || self.imageURLStrings.count > 1) {
        self.scrollView.scrollEnabled = YES;
        [self.pageControl setHidden:NO];
    } else {
        self.scrollView.scrollEnabled = NO;
        [self.pageControl setHidden:YES];
    }
    [self bringSubviewToFront:self.pageControl];
    
    ///设置定时轮播是否开启
    if(self.autoScroll && (self.images.count > 1 || self.imageURLStrings.count > 1)){
        [self timer];
    }else{
        [_timer invalidate];
        _timer = nil;
    }
    
    ///设置frame、offest、contentSize
    [self.scrollView setFrame:self.bounds];
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    self.scrollView.contentSize = CGSizeMake(self.ivs.count*self.bounds.size.width, self.bounds.size.height);
    [self.pageControl setFrame:CGRectMake(0,self.bounds.size.height-20,self.bounds.size.width, 20)];
    
    [self.ivs enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *iv = self.ivs[idx];
        NSUInteger index = [self.ivs indexOfObject:iv];
        [iv setFrame:CGRectMake(index*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.scrollView addSubview:iv];
    }];
    
    ///更新图片
    [self updateImage];
}

#pragma mark - UIScrollViewDelegate 协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = scrollView.contentSize.width/3;
    CGFloat x = scrollView.contentOffset.x;
    
    if (x < width) {
        self.leftDrag = NO;
    }else if(x > width ){
        self.leftDrag = YES;
    }
    
    if (x <= 0 || x >= width*2 ) {
        _index += (self.leftDrag ? 1 : -1);
        if (self.images.count) {
            if (_index == -1){
                _index = self.images.count - 1;
            } else if (_index == self.images.count) {
                _index = 0;
            }
        } else if (self.imageURLStrings.count) {
            if (_index < 0){
                _index = self.imageURLStrings.count - 1;
            } else if (_index > self.imageURLStrings.count - 1) {
                _index = 0;
            }
        }
        self.index = _index;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width/3, 0);
    }
}

#pragma makr - 图片点击事件
-(void)tapAction:(UITapGestureRecognizer*)sender{
    if ([self.delegate respondsToSelector:@selector(pageView:clickedOnIndex:image:)]) {
        UIImageView *imageView = self.ivs[1];
        [self.delegate pageView:self clickedOnIndex:self.index image:imageView.image];
    }
}

#pragma makr - 自动翻页滑动事件
-(void)pageAction:(NSTimer*)timer{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width/3*2, 0) animated:YES];
}

#pragma makr - 更新图片
- (void)updateImage{
    if (self.images.count) {
        self.ivs[0].image = index - 1 < 0 ? self.images.lastObject : self.images[_index-1];
        self.ivs[1].image = self.images[_index];
        self.ivs[2].image =  _index + 1 > self.images.count - 1 ? self.images.firstObject : self.images[_index+1];
        
    } else if (self.imageURLStrings.count) {
        
        if (self.leftDrag) {
            UIImageView *iv = self.ivs.firstObject;
            [self.ivs removeObjectAtIndex:0];
            [self.ivs addObject:iv];
            
        }else{
            UIImageView *iv = self.ivs.lastObject;
            [self.ivs removeObject:self.ivs.lastObject];
            [self.ivs insertObject:iv atIndex:0];
        }
        CGRect frame0 = self.ivs[0].frame;
        frame0.origin.x = 0;
        self.ivs[0].frame = frame0;
        
        CGRect frame1 = self.ivs[1].frame;
        frame1.origin.x = self.scrollView.contentSize.width/3;
        self.ivs[1].frame = frame1;
        
        CGRect frame2 = self.ivs[2].frame;
        frame2.origin.x = self.scrollView.contentSize.width/3*2;
        self.ivs[2].frame = frame2;
        
        [self.ivs[0] setImageWithURL:[NSURL URLWithString:_index - 1 < 0 ? self.imageURLStrings.lastObject : self.imageURLStrings[_index - 1]] placeholder:self.placeHolderImage];
        [self.ivs[1] setImageWithURL:[NSURL URLWithString:self.imageURLStrings[_index]] placeholder:self.placeHolderImage];
        [self.ivs[2] setImageWithURL:[NSURL URLWithString: _index + 1 > self.imageURLStrings.count - 1 ? self.imageURLStrings.firstObject : self.imageURLStrings[_index+1]] placeholder:self.placeHolderImage];
    }
}

#pragma mark - 属性配置
-(void)setImageURLStrings:(NSArray<NSString *> *)imageURLStrings{
    _imageURLStrings = imageURLStrings;
    NSLog(@"bannerUrl = %@",[imageURLStrings componentsJoinedByString:@",\n"]);
    _index = 0;
    [self.pageControl setNumberOfPages:[_imageURLStrings count]];
    [self setNeedsLayout];
}

-(void)setImages:(NSArray<UIImage *> *)images{
    _images = images;
    _index = 0;
    [self.pageControl setNumberOfPages:[_images count]];
    [self setNeedsLayout];
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self setNeedsLayout];
}

- (void)setAutoScrollTime:(NSTimeInterval)autoScrollTime{
    _autoScrollTime = autoScrollTime;
    [self setNeedsLayout];
}

-(void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode{
    _imageViewContentMode = imageViewContentMode;
    for (UIImageView* iv in self.ivs) {
        iv.contentMode = _imageViewContentMode;
    }
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    self.pageControl.currentPage = index;
    [self updateImage];
}

#pragma mark - 懒加载初始化数据
-(NSMutableArray<UIImageView *> *)ivs{
    if (!_ivs) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithImage:self.placeHolderImage];
            iv.clipsToBounds = YES;
            [arr addObject:iv];
            iv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [iv addGestureRecognizer:tap];
        }
        _ivs = arr;
    }
    return _ivs;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView setContentSize:CGSizeMake(self.ivs.count * self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        [_pageControl setPageIndicatorTintColor:self.pageIndicatorTintColor];
        [_pageControl setCurrentPageIndicatorTintColor:self.currentPageIndicatorTintColor];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
    }
    return _pageControl;
}

-(UIColor *)pageIndicatorTintColor{
    if(!_pageIndicatorTintColor){
        _pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageIndicatorTintColor;
}

-(UIColor *)currentPageIndicatorTintColor{
    if(!_currentPageIndicatorTintColor){
        _currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _currentPageIndicatorTintColor;
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.autoScrollTime target:self selector:@selector(pageAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

-(NSTimeInterval)autoScrollTime{
    if (!_autoScrollTime) {
        _autoScrollTime = 10;
    }
    return _autoScrollTime;
}

-(NSInteger)index{
    return self.pageControl.currentPage;
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}


@end
