//
//  ImageCollectionViewCell.h
//  Store
//
//  Created by Wujianfeng on 16/1/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
+(instancetype)initCellWithTableView:(UICollectionView *)collectionview WithIdentifier:(NSString *)identifer forPath:(NSIndexPath *)indePath;
-(void)update:(UIImage *)image AtIndexPath:(NSIndexPath *)indexpath;

@end
