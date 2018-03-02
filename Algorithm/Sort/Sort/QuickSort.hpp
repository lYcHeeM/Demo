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

int partition_array_1(int *array, size_t len, int ref_pos, int *result_pos);
int random_in_range(size_t range, size_t *result);
void swap_two_values(int *left, int *right);

#endif /* QuickSort_hpp */
