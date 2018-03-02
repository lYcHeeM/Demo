//
//  MinValueOfRotatedSortedArray.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/1/29.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "MinValueOfRotatedSortedArray.hpp"
#include <iostream>

void binary_search_value_recursively_in_(const int *array, size_t length, size_t startIndex, int target, int *result);

/// 二分查找
void binary_search_value_recursively_in(const int *array, size_t length, int target, int *result)
{
    binary_search_value_recursively_in_(array, length, 0, target, result);
}
void binary_search_value_recursively_in_(const int *array, size_t length, size_t startIndex, int target, int *result)
{
    if (array == NULL || length == 0 || result == NULL) return;
    
    const int *middle = array + startIndex + (length - 1)/2;
    size_t endIndex = length - 1;
    size_t midIndex = (endIndex - startIndex)/2;
    
    if (*middle < target) {
        return binary_search_value_recursively_in_(array, endIndex - midIndex, midIndex + 1, target, result);
    } else if (*middle > target) {
        return binary_search_value_recursively_in_(array, midIndex - startIndex, 0, target, result);
    } else {
        *result = (int)(middle - array);
        return;
    }
}

/// 对已递增排序的数组旋转, 求旋转后最值, 算法复杂度为lg(n);
/// 依据点: 注意到旋转后的数组可看成两个有序子数组, 唯有最小值同时比前序值和后序值小;
void min_value_of_rotated_sorted_array(const int *array, size_t length, int *result)
{
    if (array == NULL || result == NULL) return;
    if (length == 1) {
        *result = array[0];
        return;
    } else if (length == 2) {
        *result = array[0] > array[1] ? array[1] : array[0];
        return;
    }
    
    size_t startIndex = 0;
    size_t endIndex = length - 1;
    size_t midIndex = (endIndex - startIndex)/2;
    int priorValue = array[midIndex - 1];
    int nextValue = array[midIndex + 1];
    int midValue = array[midIndex];
    
    // 中间值如果>=首值, 说明中间值落在前面的有序子数组中;
    // 中间值<前序 && 中间值<=后序, 此时中间值即为最小值;
    // 中间值如果<=尾值, 说明中间值落在后面的有序子数组中;
    if (midValue >= array[startIndex]) {
        // 考虑较特殊的序列: 1, 0, 1, 1, 1; 上面的判断将失效, 此时不得不顺序查找;
        if (midValue == array[startIndex] && midValue == array[endIndex]) {
            int minValue = array[startIndex];
            for (int i = 0; i < length; ++ i) {
                if (array[i] < minValue) {
                    minValue = array[i];
                }
            }
            *result = minValue;
        } else {
            min_value_of_rotated_sorted_array(array + midIndex, length - midIndex, result);
        }
        return;
    } else if (midValue < priorValue && midValue <= nextValue) {
        *result = midValue;
        return;
    } else {
        return min_value_of_rotated_sorted_array(array, length - midIndex, result);
    }
}
