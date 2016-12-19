//
//  SYLifeManagerCell.m
//  shan
//
//  Created by aDu on 2016/12/5.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "SYLifeManagerCell.h"
#import "Masonry.h"

@interface SYLifeManagerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SYLifeManagerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 15, 15, 15));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
            make.left.and.right.equalTo(self);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        self.button.hidden = YES;
    }
    return self;
}

- (void)addMeaageLabel
{
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setModel:(SYLifeManagerModel *)model indexPaht:(NSIndexPath *)indexPath exist:(BOOL)exist
{
    if (_model != model) {
        self.titleLabel.text = model.title;
        if (indexPath.section == 0) {
            [self.button setBackgroundImage:[UIImage imageNamed:@"life_reduce"] forState:UIControlStateNormal];
            self.button.userInteractionEnabled = YES;
        } else {
            if (exist) {
                [self.button setBackgroundImage:[UIImage imageNamed:@"life_exist"] forState:UIControlStateNormal];
                self.button.userInteractionEnabled = NO;
            } else {
                [self.button setBackgroundImage:[UIImage imageNamed:@"life_add"] forState:UIControlStateNormal];
                self.button.userInteractionEnabled = YES;
            }
        }
    }
    _model = model;
}

- (void)setDataAry:(NSMutableArray *)dataAry groupAry:(NSMutableArray *)groupAry indexPath:(NSIndexPath *)indexPath
{
    SYLifeManagerModel *model;
    if (indexPath.section == 0) {
        model = dataAry[indexPath.row];
    } else {
        model = groupAry[indexPath.row];
    }
    self.titleLabel.text = model.title;
    if (indexPath.section == 0) {
        self.button.userInteractionEnabled = YES;
        [self.button setBackgroundImage:[UIImage imageNamed:@"life_reduce"] forState:UIControlStateNormal];
    } else {
        if ([dataAry containsObject:model]) {
            self.button.userInteractionEnabled = NO;
            [self.button setBackgroundImage:[UIImage imageNamed:@"life_exist"] forState:UIControlStateNormal];
        } else {
            self.button.userInteractionEnabled = YES;
            [self.button setBackgroundImage:[UIImage imageNamed:@"life_add"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 是否处于编辑状态

- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.button.hidden = NO;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.button.hidden = YES;
    }
}

#pragma mark - init

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"wallet_payChange"];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"您还未添加任何应用\n长按下面的应用可以添加";
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 7.5;
        [self addSubview:_button];
    }
    return _button;
}

@end
