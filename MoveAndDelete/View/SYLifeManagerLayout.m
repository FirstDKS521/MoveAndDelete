//
//  SYLifeManagerLayout.m
//  shan
//
//  Created by aDu on 2016/12/6.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "SYLifeManagerLayout.h"
#import "SYLifeManagerCell.h"
#import "SYLifeManagerModel.h"

@interface SYLifeManagerLayout ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, strong) NSIndexPath *currentIndexPath; //当前indexPath
@property (nonatomic, assign) CGPoint movePoint; //移动的中心点
@property (nonatomic, strong) UIView *moveView; //移动的视图

@end

@implementation SYLifeManagerLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureObserver];
    }
    return self;
}

#pragma mark - 添加观察者

- (void)configureObserver
{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGestureRecognizers];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 长按手势

- (void)setUpGestureRecognizers
{
    if (self.collectionView == nil) {
        return;
    }
    _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    _longGesture.minimumPressDuration = 0.3f; //时间长短
    _longGesture.delegate = self;
    [self.collectionView addGestureRecognizer:_longGesture];
}

#pragma mark - 手势动画

- (void)longGesture:(UILongPressGestureRecognizer *)gesture
{
    if (!self.inEditState) {
        [self setInEditState:YES];
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {  //手势开始
            CGPoint location = [gesture locationInView:self.collectionView];
            //找到当前点击的cell的位置
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            //判断哪个分区可以被点击并且移动
            self.currentIndexPath = indexPath;
            if (indexPath == nil || indexPath.section != 0) return;
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前cell的映射(截图)
            self.moveView = [targetCell snapshotViewAfterScreenUpdates:YES];
            //隐藏被点击的cell
            targetCell.hidden = YES;
            //给截图添加上边框，如果不添加的话，截图有一部分是没有边框的，具体原因也没有找到
            self.moveView.layer.borderWidth = 0.5;
            self.moveView.layer.borderColor = [UIColor grayColor].CGColor;
            [self.collectionView addSubview:self.moveView];
            //放大截图
            self.moveView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.moveView.center = targetCell.center;
        }
            break;
        case UIGestureRecognizerStateChanged: { //手势在变化
            CGPoint point = [gesture locationInView:self.collectionView];
            //更新cell的位置
            self.moveView.center = point;
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil)  return;
            if (indexPath.section == self.currentIndexPath.section && indexPath.section == 0) {
                //通过代理去改变数据源
                if ([self.delegate respondsToSelector:@selector(moveItemAtIndexPath:toIndexPath:)]) {
                    [self.delegate moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                }
                //移动的方法
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {  //手势结束
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //手势结束后，把截图隐藏，显示出原先的cell
            [UIView animateWithDuration:0.25 animations:^{
                self.moveView.center = cell.center;
            } completion:^(BOOL finished) {
                [self.moveView removeFromSuperview];
                cell.hidden = NO;
                self.moveView = nil;
                self.currentIndexPath = nil;
                [self.collectionView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处于编辑状态

- (void)setInEditState:(BOOL)inEditState
{
    if (_inEditState != inEditState) {
        //通过代理方法改变处于编辑状态的cell
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeEditState:)]) {
            [_delegate didChangeEditState:inEditState];
        }
    }
    _inEditState = inEditState;
}

#pragma mark - 移除观察者

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"collectionView"];
}

@end
