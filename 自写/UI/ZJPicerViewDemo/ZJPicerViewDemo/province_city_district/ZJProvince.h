//
//  BGYProvince.h
//  mobiportal
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJArea.h"
#import "ZJCity.h"

@interface ZJProvince : ZJArea <ZJPickerViewComponent>
@property (nonatomic, strong) NSArray<ZJCity> *cities;
@end
