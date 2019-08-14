//
//  TCMPageView.h
//  Pods-ComponentDemo
//
//  Created by ZZJ on 2019/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TCMPageView;

@protocol TCMPageViewProtocol <NSObject>

-(void)pageView:(TCMPageView*)pageView clickedOnIndex:(NSInteger)index image:(UIImage*)image;

@end
@interface TCMPageView : UIView

//设置所有显示图片：传入图片URL字符串（imageURLStrings）或者 传入UIImage（images），两者都传时，优先使用images
@property(nonatomic, strong) NSArray <NSString*> *imageURLStrings;
@property(nonatomic, strong) NSArray <UIImage*> *images;

@property(nonatomic, weak) id <TCMPageViewProtocol> delegate; //协议委托对象
@property(nonatomic, strong) UIImage *placeHolderImage;//设置网络加载失败时显示的默认图片
@property(nonatomic, strong) UIColor *pageIndicatorTintColor;//设置翻页控制器未选中状态颜色
@property(nonatomic, strong) UIColor *currentPageIndicatorTintColor;//设置翻页控制器选中状态颜色
@property(nonatomic, assign) NSTimeInterval autoScrollTime; //设置自动翻页时间间隔,默认 10 秒
@property(nonatomic) UIViewContentMode imageViewContentMode;//设置视图填充模式，默认值为 UIViewContentModeScaleToFill
@property(nonatomic) NSInteger index;//当前图片位置下标
@property(nonatomic) BOOL autoScroll;//打开定时轮播，默认不打开

@end

NS_ASSUME_NONNULL_END
