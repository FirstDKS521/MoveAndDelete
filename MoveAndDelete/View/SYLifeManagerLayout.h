//
//  SYLifeManagerLayout.h
//  shan
//
//  Created by aDu on 2016/12/6.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYLifeManagerDelegate <NSObject>

/**
 * 更新数据源
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;

/**
 * 改变编辑状态
 */
- (void)didChangeEditState:(BOOL)inEditState;

@end

@interface SYLifeManagerLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL inEditState; //检测是否处于编辑状态
@property (nonatomic, weak) id<SYLifeManagerDelegate> delegate;

@end
