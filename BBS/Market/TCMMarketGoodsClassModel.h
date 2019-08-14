//
//  TCMMarketGoodsClassModel.h
//  BBS
//
//  Created by ZZJ on 2019/8/9.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModelArray.h"

NS_ASSUME_NONNULL_BEGIN
/*
 市场分类模型
 */
@interface TCMMarketGoodsClassModel : NSObject
/*
 分类ID，
 市场优惠券分类ID -- discountCouponRule、
 店铺优惠券 -- storeVoucher、
 买赠（买赠专区）-- redemption、
 鲜活（鲜活专区）--fresh、
 时令（时令专区）--seasonal、
 热门商品（主题专区）--subject
 */
@property (nonatomic, copy) NSString *classId;
//分类名称
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *classImageUrl;
@property (nonatomic, copy) NSString *classLevel;
@property (nonatomic, strong) NSArray <TCMMarketGoodsClassModel*>*childs;

//自定义字段
@property (nonatomic, copy) NSString *marketID;
@property (nonatomic, copy) NSString *firstClassID;//一级类别ID
@property (nonatomic, copy) NSString *secondClassID;//二级类别ID
/**
 优惠券类型 1礼包券 2多个优惠券 3单折扣券
 */
@property (nonatomic, assign)NSInteger couponsType;
@property (nonatomic) BOOL isSelected;

@end

/////////////////////////////////////
/*
 市场商品分区模型
 */
@interface TCMMarketGoodsSectionModel : NSObject
@property (nonatomic ,strong) TCMMarketGoodsClassModel *sectionHeaderData;
@property (nonatomic, strong) NSMutableArray  *rowsData;
@end

///////////////////////////////////////////
/*
 市场商品模型
 */
@class TCMGoodsTagModel;
@interface TCMMarketGoodsModel : NSObject

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *standard_description;
@property (nonatomic, copy) NSString *goods_inventory;
@property (nonatomic, copy) NSString *goods_marketActivityGoods;
@property (nonatomic, copy) NSString *goods_store_price;
@property (nonatomic, copy) NSString *market_id;
@property (nonatomic, copy) NSString *market_name;
@property (nonatomic, copy) NSString *marketInfo;
@property (nonatomic, copy) NSString *goods_salenum;
@property (nonatomic, copy) NSString *store_evaluate1;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_bargain_status;
@property (nonatomic, copy) NSString *goods_img;
@property (nonatomic, copy) NSString *isAsia;
@property (nonatomic, copy) NSString *marketOrderNum;
@property (nonatomic, copy) NSString *marketImgUrl;
@property (nonatomic, copy) NSString *marketId;
@property (nonatomic, copy) NSString *isNewMarket;
@property (nonatomic, copy) NSString *classsify_id;
@property (nonatomic, copy) NSString *storeTagAndName;
@property (nonatomic, copy) NSString *deliveryInfo;
@property (nonatomic, copy) NSString *marketName;
@property (nonatomic, strong) NSArray <TCMGoodsTagModel *> *tagList;
@property (nonatomic, strong) NSArray <NSString *> *storeLabel;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic) BOOL highlight;
/*
 赠品数据
 {
 goods_inventory:,//赠品库存
 goods_name:,//赠品名称
 img:,//赠品图片
 goods_original_price:,//赠品原价
 per_weight:,//重量
 standard_description:,//规格
 id:,
 goods_current_price:,//赠品现价
 status:,//赠品状态
 }
 */
@property(nonatomic,strong)NSDictionary *gifts;

@end

///////////////////////////////////////////
/*
 市场商品标签模型
 */
@interface TCMGoodsTagModel : NSObject
@property (nonatomic, copy) NSString *border;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *tagName;
@end

NS_ASSUME_NONNULL_END
