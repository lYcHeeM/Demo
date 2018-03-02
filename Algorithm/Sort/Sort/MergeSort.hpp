//
//  MergeSort.hpp
//  Sort
//
//  Created by luozhijun on 16/9/18.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#ifndef MergeSort_hpp
#define MergeSort_hpp

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

void merge_sort(int *data, size_t length);
void merge_two_sorted_arrays(int *array_1, size_t length_1, int *array_2, size_t length_2);
int merge_sort_recursively(int *sequence, size_t length, bool (*is_left_smaller)(int, int));
#endif /* MergeSort_hpp */
