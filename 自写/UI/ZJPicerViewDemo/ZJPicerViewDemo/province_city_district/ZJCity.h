//
//  BGYCity.h
//  mobiportal
//
//  Created by luozhijun on 14-12-12.
//  Copyright (c) 2014年 bgyun. All rights reserved.
//

#import "ZJArea.h"
#import "ZJDistrict.h"
#import <CoreLocation/CoreLocation.h>

@protocol ZJCity
@end

@interface ZJCity : ZJArea <ZJPickerViewComponent>
@property (nonatomic, strong) NSArray<ZJDistrict> *districts;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, copy) NSString *address;
@end
