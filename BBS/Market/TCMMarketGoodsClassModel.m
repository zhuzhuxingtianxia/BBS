//
//  TCMMarketGoodsClassModel.m
//  BBS
//
//  Created by ZZJ on 2019/8/9.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "TCMMarketGoodsClassModel.h"

@implementation TCMMarketGoodsClassModel

+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{@"childs":TCMMarketGoodsClassModel.class};
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    //记录父级类别id
    for (TCMMarketGoodsClassModel *data in self.childs) {
        if ([data.classLevel isEqualToString:@"2"]) {
            data.firstClassID = self.classId;
            for (TCMMarketGoodsClassModel *data2 in data.childs) {
                if ([data2.classLevel isEqualToString:@"3"]) {
                    data2.firstClassID = self.classId;
                    data2.secondClassID = data.classId;
                }
            }
        }
    }
    return YES;
}

//记录市场ID
-(void)setMarketID:(NSString *)marketID {
    _marketID = marketID;
    [self.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.marketID = marketID;
    }];
}

@end

/////////////////////////////////////////////

@implementation TCMMarketGoodsSectionModel
- (NSMutableArray *)rowsData{
    if (!_rowsData) {
        _rowsData = [NSMutableArray array];
    }
    return _rowsData;
}
@end


/////////////////////////////////

@implementation TCMMarketGoodsModel
+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{@"tagList":TCMGoodsTagModel.class};
}
@end

/////////////////////////////////

@implementation TCMGoodsTagModel

@end
