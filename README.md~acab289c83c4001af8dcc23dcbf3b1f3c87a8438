# MoveAndDelete
iOS开发：UICollectionView长按移动、添加、删除（仿支付宝首页中的全部功能）

![效果图](http://upload-images.jianshu.io/upload_images/1840399-3963fd46ca66b073.gif?imageMogr2/auto-orient/strip)

UICollectionView添加手势，可以使cell移动、添加、删除，这种功能网上也有一大堆的资料可供查看，本文没有做封装，提供一个思路给读者；封装的再好，不符合自己的业务，还是需要修改的；

仿支付宝的效果，你可以打开支付宝，首页中有个全部功能，点击进去，第一个分区的cell是可以移动，第一个分区可以添加，可以删除；后面的分区不可以添加，也不能够删除和移动，如果第一个分区已经有了，下面的就是一个`✔️`号，如果没有，则显示`+`号；第一个分区永远都是`-`号，表示只能删除；

首先创建一个继承与`UICollectionViewFlowLayout`的类：.h中的代码

```
#import <UIKit/UIKit.h>

@protocol SYLifeManagerDelegate <NSObject>

/**
 * 改变编辑状态
 */
- (void)didChangeEditState:(BOOL)inEditState;

/**
 * 更新数据源
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;

@end

@interface SYLifeManagerLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, assign) id<SYLifeManagerDelegate> delegate;

@end
```
#####.m中的代码：

```
#import "SYLifeManagerLayout.h"
#import "SYLifeManagerCell.h"
#import "SYLifeManagerModel.h"
#import "Header.h"

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
    [self.collectionView addGestureRecognizer:self.longGesture];
}

#pragma mark - 手势动画

- (void)longGesture:(UILongPressGestureRecognizer *)gesture
{
    if (!self.inEditState) {
        [self setInEditState:YES];
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint location = [gesture locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
            //如果indexPath为空，不做任何操作
            if (indexPath == nil || indexPath.section != 0) return;
            self.currentIndexPath = indexPath;
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前cell的映射(截图)
            self.moveView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.moveView.layer.borderWidth = 0.3;
            self.moveView.layer.borderColor = [UIColor sy_grayColor].CGColor;
            [self.collectionView addSubview:self.moveView];
            targetCell.hidden = YES;
            self.moveView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.moveView.center = location;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [gesture locationInView:self.collectionView];
            //更新cell的位置
            self.moveView.center = point;
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil)  return;
            if (indexPath.section == self.currentIndexPath.section && indexPath.section == 0) {
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                //使用代理方法更新数据源
                if ([self.delegate respondsToSelector:@selector(moveItemAtIndexPath:toIndexPath:)]) {
                    [self.delegate moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                }
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
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

#pragma mark - 手势

- (UILongPressGestureRecognizer *)longGesture
{
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        _longGesture.minimumPressDuration = 0.5f; //时间长短
        _longGesture.delegate = self;
    }
    return _longGesture;
}

@end
```
限于文章篇幅长度，有需要的可以移步[demo](https://github.com/FirstDKS521/MoveAndDelete)

`SYLifeManagerCell`创建的cell，这个就不用多讲了，一般都是一张图片和描述文案

`SYLifeManagerModel`创建的model

`SYLifeManagerHeaderView`是创建的区头视图，为了显示分区标题

`SYLIfeManagerFooterView`是区尾视图，主要是为了实现分割线

[Demo的Github地址](https://github.com/FirstDKS521/MoveAndDelete)，如果有问题或者好的建议，希望留言，欢迎交流！
