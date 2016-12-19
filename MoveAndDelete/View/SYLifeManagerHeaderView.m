//
//  SYLifeManagerHeaderView.m
//  shan
//
//  Created by aDu on 2016/12/7.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "SYLifeManagerHeaderView.h"

@implementation SYLifeManagerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headLabel];
    }
    return self;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.font = [UIFont systemFontOfSize:16];
        _headLabel.frame = CGRectMake(16, 0, 150, 20);
    }
    return _headLabel;
}

@end
