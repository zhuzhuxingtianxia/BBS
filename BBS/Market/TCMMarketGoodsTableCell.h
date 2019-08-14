//
//  TCMGoodsTableCell.h
//  BBS
//
//  Created by ZZJ on 2019/8/12.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMMarketGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface TCMClassTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *classLabel;

@property (nonatomic,strong)TCMMarketGoodsClassModel *classModel;

@end

/***********************************/

@interface TCMMarketGoodsSectionCell : UITableViewHeaderFooterView

@property(nonatomic,strong) TCMMarketGoodsSectionModel *sectionModel;

@end

/***********************************/

@interface TCMMarketGoodsTableCell : UITableViewCell

@property(nonatomic,strong)TCMMarketGoodsModel *data;

@end

/***********************************/

@interface TCMMarketTopCollectionCell : UICollectionViewCell

@property(nonatomic,strong)TCMMarketGoodsClassModel *data;

@end

NS_ASSUME_NONNULL_END
