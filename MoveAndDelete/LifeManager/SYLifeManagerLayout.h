//
//  SYLifeManagerLayout.h
//  shan
//
//  Created by aDu on 2016/12/6.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYLifeManagerDelegate <NSObject>

//去改变数据源
//- (void)moveDataItem:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)didChangeEditState:(BOOL)inEditState;

@end

@interface SYLifeManagerLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, assign) id<SYLifeManagerDelegate> delegate;

//- (id)initWithSelectItems:(NSArray *)selectItems unSelectItems:(NSArray *)unSelectItems;

@end
