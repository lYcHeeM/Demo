//
//  QuickSort.hpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#ifndef QuickSort_hpp
#define QuickSort_hpp

#include <stdio.h>

void quick_sort(int *data, size_t length);
void partition_array(int *start, int *end, int *out_refrence_position);

#endif /* QuickSort_hpp */
