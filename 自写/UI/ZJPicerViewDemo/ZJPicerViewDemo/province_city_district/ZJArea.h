//
//  BGYArea.h
//  mobiportal
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "JSONModel.h"
#import "ZJPickerView.h"

@interface ZJArea : JSONModel <ZJPickerViewRow ,ZJPickerViewComponent>

@property (nonatomic, copy) NSString *AreaName;
@property (nonatomic, strong) NSNumber *AreaID;
@property (nonatomic, strong) NSNumber *AreaLevel;
@property (nonatomic, strong) NSNumber *ParentID;

@end
