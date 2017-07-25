//
//  ZJCover.m
//  mobiportal
//
//  Created by JC.Wang on 14/11/23.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJCover.h"

@implementation ZJCover

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.默认的背景色
        self.backgroundColor = [UIColor blackColor];
    
        // 2.默认的alpha
        self.alpha = 0.f;
        
        // 3.透明时的alpha值
        _translucentAlpha = 0.25;
        
        // 4.自动伸缩宽高
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 5.添加tap手势
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTaped)]];
    }
    return self;
}

- (void)coverTaped
{
    if (self.coverTapedBlock) {
        self.coverTapedBlock(self);
    }
}

@end
