//
//  MinValueOfRotatedSortedArray.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/1/29.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef MinValueOfRotatedSortedArray_hpp
#define MinValueOfRotatedSortedArray_hpp

#include <stdio.h>

/// 二分查找
void binary_search_value_recursively_in(const int *array, size_t length, int target, int *result);

/// 对已递增排序的数组旋转, 求旋转后最值, 算法复杂度为lg(n);
/// 依据点: 注意到旋转后的数组可看成两个有序子数组, 唯有最小值同时比前序值和后序值小;
void min_value_of_rotated_sorted_array(const int *array, size_t length, int *result);

#endif /* MinValueOfRotatedSortedArray_hpp */
