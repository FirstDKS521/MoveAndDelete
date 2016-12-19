//
//  SYLifeManagerHeaderView.m
//  shan
//
//  Created by aDu on 2016/12/7.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "SYLifeManagerHeaderView.h"
#import "Header.h"

@implementation SYLifeManagerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor orangeColor];
        [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(16);
        }];
    }
    return self;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.textColor = [UIColor sy_titleColor];
        _headLabel.font = [UIFont systemFontOfSize:K_BigFont_Size];
        [self addSubview:_headLabel];
    }
    return _headLabel;
}

@end
