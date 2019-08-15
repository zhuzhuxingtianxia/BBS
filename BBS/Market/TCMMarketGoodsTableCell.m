//
//  TCMGoodsTableCell.m
//  BBS
//
//  Created by ZZJ on 2019/8/12.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "TCMMarketGoodsTableCell.h"
#import <YYKit/YYKit.h>

@implementation TCMClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.classLabel];
    }
    return self;
}

-(void)setClassModel:(TCMMarketGoodsClassModel *)classModel {
    _classModel = classModel;
    self.classLabel.text = classModel.className;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (_classModel.className.length>0) {
        self.classLabel.backgroundColor = [UIColor clearColor];
        self.classLabel.frame = CGRectMake(3, 0, self.width-3, self.height);
    }else{
        self.classLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.classLabel.frame = CGRectMake(15, (self.height-20)/2.0, self.width-30, 20);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        self.classLabel.textColor = [UIColor colorWithHexString:@"#ff0033"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{
        self.classLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
}

-(UILabel*)classLabel {
    if (!_classLabel) {
        _classLabel = [UILabel new];
        _classLabel.textAlignment = NSTextAlignmentCenter;
        _classLabel.font = [UIFont systemFontOfSize:13];
    }
    return _classLabel;
}

@end

/***********************************/

@interface TCMMarketGoodsSectionCell ()

@end

@implementation TCMMarketGoodsSectionCell

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return self;
}

-(void)setSectionModel:(TCMMarketGoodsSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    self.textLabel.text = sectionModel.sectionHeaderData.className;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.textLabel.font = [UIFont systemFontOfSize:12];
}

@end

/***********************************/

@interface TCMMarketGoodsTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@end
@implementation TCMMarketGoodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(TCMMarketGoodsModel*)data {
    _data = data;
    
    self.contentView.backgroundColor = data.highlight ?  [UIColor colorWithHexString:@"#fef2db"]: [UIColor whiteColor];
    
    _nameLabel.backgroundColor =  data.goods_id.length > 0 ? [UIColor clearColor] : [UIColor colorWithHexString:@"#f5f5f9"];
    _priceLabel.backgroundColor = data.goods_id.length > 0 ? [UIColor clearColor] : [UIColor colorWithHexString:@"#f5f5f9"];
    
    if (data.goods_name.length>0) {
        [_nameLabel setText: [NSString stringWithFormat:@"%@%@",data.goods_name,data.standard_description?:@""]];
    }else {
        _nameLabel.text = @"                          ";
    }
    if (data.goods_price.length) {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",data.goods_store_price];
    }else{
        _priceLabel.text = @"                   ";
    }
    
    [_goodsImg setImageWithURL:[NSURL URLWithString:data.goods_img] placeholder:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

/***********************************/

@interface TCMMarketTopCollectionCell ()
@property (strong, nonatomic) UILabel *textLabel;
@end
@implementation TCMMarketTopCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

-(void)setData:(TCMMarketGoodsClassModel *)data {
    _data = data;
    self.textLabel.text = data.className;

}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.textLabel.textColor = selected  ? [UIColor colorWithHexString:@"#FF0033"] : [UIColor colorWithHexString:@"#333333"];
}

#pragma mark -- getter
-(UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
