

//
//  UIImage+Resize.m
//  Store
//
//  Created by Wujianfeng on 16/1/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)
-(CGSize)getsizeWithResetWidth:(CGFloat)width{
    CGFloat scale = width/ self.size.width;
    CGFloat height = scale * self.size.height;
    
    return CGSizeMake(width, height);
}

-(CGSize)getsizeWithRestHeight:(CGFloat)height{
    CGFloat scale = height/ self.size.height;
    CGFloat width = scale * self.size.width;
    
    return CGSizeMake(width, height);
}
@end
