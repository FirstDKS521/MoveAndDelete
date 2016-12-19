//
//  SYLifeManagerCell.h
//  shan
//
//  Created by aDu on 2016/12/5.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYLifeManagerModel.h"

@interface SYLifeManagerCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) SYLifeManagerModel *model;

@property (nonatomic, assign) BOOL inEditState; //是否处于编辑状态

- (void)setModel:(SYLifeManagerModel *)model indexPaht:(NSIndexPath *)indexPath exist:(BOOL)exist;

- (void)setDataAry:(NSMutableArray *)dataAry groupAry:(NSMutableArray *)groupAry indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UILabel *messageLabel;

- (void)addMeaageLabel;

@end
