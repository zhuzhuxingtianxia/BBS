//
//  HMarketSubClassCollectionView.h
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMMarketGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HMarketSubClassBlock)(NSString *classID);

@interface HMarketSubClassCollectionView : UICollectionView

@property (nonatomic, copy) HMarketSubClassBlock didSelectBlock;
@property (strong, nonatomic) NSArray <TCMMarketGoodsClassModel*> *classes;
@property (nonatomic, copy) NSString *classID;

@end

NS_ASSUME_NONNULL_END
