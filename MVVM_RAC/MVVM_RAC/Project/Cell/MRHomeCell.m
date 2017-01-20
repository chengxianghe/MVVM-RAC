//
//  MRHomeCell.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/20.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRHomeCell.h"
#import <YYWebImage/YYWebImage.h>

@interface MRHomeCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation MRHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(MRHomeModel *)info {
    [self.iconImageView setImage:[UIImage imageNamed:info.icon]];
    self.titleLabel.text = info.name;
    self.infoLabel.text = info.intro;
}

//+ (CGFloat)heightWithInfo:(MRHomeModel *)info {
//    CGFloat h = 61;
//    
//    CGFloat wordH = [info.intro boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 105, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.height;
//    
//    return MAX(95, h + wordH);
//}

@end
