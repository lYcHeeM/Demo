//
//  TableViewCell.m
//  tttaa
//
//  Created by luozhijun on 15/11/9.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    NSLog(@"-- %@", NSStringFromCGRect(self.imageView.frame));
    NSLog(@"-- %@", NSStringFromCGRect(self.textLabel.frame));
    NSLog(@"-- %@", NSStringFromCGRect(self.accessoryView.frame));
    NSLog(@"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
