//
//  ImageCollectionViewCell.m
//  Store
//
//  Created by Wujianfeng on 16/1/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

#pragma mark - override
+(instancetype)initCellWithTableView:(UICollectionView *)collectionview WithIdentifier:(NSString *)identifer forPath:(NSIndexPath *)indePath 
{
    //1.创建cell
    ImageCollectionViewCell * cell = [collectionview dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indePath];
    
    if (cell == nil) {
        cell = [[ImageCollectionViewCell alloc] init];
        
    }
    
    return cell;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void) setUpUI
{
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
}

#pragma mark - private
-(void)update:(UIImage *)image AtIndexPath:(NSIndexPath *)indexpath
{
    self.contentView.backgroundColor = [UIColor blackColor];
#if 1
    self.imageView.frame = self.bounds;
#endif
    self.imageView.image = nil;
    self.imageView.image = image;
}


#pragma mark - setter/getter
//- (void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:highlighted];
//    if (highlighted) {
//        _imageView.alpha = 1.f;
//        [UIView animateWithDuration:0.1 animations:^{
//            CGFloat w = self.imageView.frame.size.width * 0.9;
//            CGFloat h = self.imageView.frame.size.height * 0.9;
//            
//            CGFloat x = self.imageView.frame.origin.x + (self.imageView.frame.size.width - w)/2;
//            CGFloat y = self.imageView.frame.origin.y + (self.imageView.frame.size.height - h)/2;
//
//            self.imageView.frame = CGRectMake(x, y, w, h);
//            
//        } completion:^(BOOL finished) {
//           [UIView animateWithDuration:0.5 animations:^{
//               
//               self.imageView.frame = self.bounds;
//           }];
//        }];
//        
//    }else {
//        _imageView.alpha = 1.f;
//    }
//}

@end
