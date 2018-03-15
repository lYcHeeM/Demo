//
//  ViewController.m
//  Store
//
//  Created by Mac on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ViewController.h"

#import "ImageCollectionViewCell.h"

#import "UIImage+Resize.h"

@interface ViewController ()<UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *cellSizeArray;

//初始页面将要展现cell个数
@property (nonatomic, assign) NSInteger FiristVisibleCellNumber;

@property (nonatomic, assign) CGPoint orginContenOffset;

@end

static NSString *BrandCell = @"cellID";

static BOOL isFirstFresh = YES;

static BOOL isFirstDisplay = YES;

@implementation ViewController

#pragma mark - override

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initCollection];
}

- (void)initCollection
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    layout.headerHeight = 0;
    layout.footerHeight = 0;
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:BrandCell];
    
    //[self.collectionView visibleCells];
   [self.view addSubview:self.collectionView];
}

#pragma mark - notification

#pragma mark - action

#pragma mark - setter/getter
- (NSMutableArray *)imageArray{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray new];
        for (int i = 1; i < 41; i++)
        {
            NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i];
            UIImage *image = [UIImage imageNamed:imgName];
            [_imageArray addObject:image];
        }
    }
    
    return _imageArray;
}
#pragma mark - private

#pragma mark - UICollectionViewDataSource 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [ImageCollectionViewCell initCellWithTableView:collectionView WithIdentifier:BrandCell forPath:indexPath];
    [cell update:self.imageArray[indexPath.row] AtIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat Duration;
    CGFloat Delay;
    CGFloat transformY = 0;
    
    CGPoint contenOffset = collectionView.contentOffset;
    //判断上拉下拉
    CGFloat flag = contenOffset.y - _orginContenOffset.y;
    
    if (isFirstDisplay)
    {
        //第一次加载从底部弹出
        transformY = ScreenHeight - 64;
        Duration  = 4 * 0.20 + 0.45;
        Delay = indexPath.row * 0.15 + 0.1;
        if (indexPath.row + 1 == _FiristVisibleCellNumber)
        {
            isFirstDisplay = NO;
        }
    }else if (flag > 0)
    {   //上拉
        Duration  = 1.5;
        Delay = 0;
        transformY = 50;
    }else
    {  //下拉
        Duration  = 1.5;
        Delay = 0;
        transformY = -50;
    }
    
#if 1
    
     // 1.第一种动画方法
//    cell.transform = CGAffineTransformMakeTranslation(0, transformY);
//    [UIView animateWithDuration:Duration delay:Delay usingSpringWithDamping:2 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.transform = CGAffineTransformIdentity;
//    } completion:nil];

     // 2.第二种方法
//    cell.transform = CGAffineTransformMakeTranslation(0, transformY);
//    [UIView animateKeyframesWithDuration:Duration delay:Delay options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
//        cell.transform = CGAffineTransformIdentity;
//    } completion:nil];
    
     // 3.另一种常用的渐变动画, 也挺好看, 溶解效果
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    if (transformY > 0) {
        transition.subtype = kCATransitionFromBottom;
    } else {
        transition.subtype = kCATransitionFromTop;
    }
    [cell.layer addAnimation:transition forKey:@"transition"];
#endif
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        UIImage *image = self.imageArray[indexPath.row];
    
        return [image getsizeWithResetWidth:(ScreenWidth - 10) /2];
}

- (void)numberOfVisibleCells:(NSInteger)number{
    //只运行一次 初始页面cell个数
    if (isFirstFresh) {
        _FiristVisibleCellNumber = number;
        isFirstFresh = NO;
    }else
        return;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _orginContenOffset = scrollView.contentOffset;
}



@end
