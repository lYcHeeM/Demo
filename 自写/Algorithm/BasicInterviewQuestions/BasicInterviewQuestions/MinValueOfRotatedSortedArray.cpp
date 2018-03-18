//
//  MinValueOfRotatedSortedArray.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/1/29.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "MinValueOfRotatedSortedArray.hpp"
#include <iostream>

void __binary_search_value_recursively_in(const int *array, size_t startIndex, size_t endIndex, int target, int *target_index);

/// 二分查找
void binary_search_value_recursively_in(const int *array, size_t length, int target, int *target_index) {
    __binary_search_value_recursively_in(array, 0, length - 1, target, target_index);
}
void __binary_search_value_recursively_in(const int *array, size_t startIndex, size_t endIndex, int target, int *target_index) {
    if (array == NULL || startIndex > endIndex || target_index == NULL) return;
    
    size_t midIndex = (startIndex + endIndex)/2;
    const int middle = array[midIndex];
    
    if (middle < target) {
        return __binary_search_value_recursively_in(array, midIndex + 1, endIndex, target, target_index);
    } else if (middle > target) {
        return __binary_search_value_recursively_in(array, 0, midIndex - 1, target, target_index);
    }
    
    *target_index = (int)midIndex;
}

void __binary_search_of(const int *array, int start_index, int end_index, int target, int *target_index);
/// 二分查找，循环方式
void binary_search_of(const int *array, size_t length, int target, int *target_index) {
    __binary_search_of(array, 0, (int)(length - 1), target, target_index);
}
void __binary_search_of(const int *array, int start_index, int end_index, int target, int *target_index) {
    if (!array || start_index > end_index || !target_index) return;
    
    int midindex = (start_index + end_index)/2;
    int midvalue = array[midindex];
    
    while (midvalue != target && start_index < end_index) {
        if (midvalue > target) {
            end_index = midindex - 1;
        } else {
            start_index = midindex + 1;
        }
        if (start_index <= end_index) {
            midindex = (start_index + end_index)/2;
            midvalue = array[midindex];
        }
    }
    
    if (midvalue == target)
        *target_index = (int)midindex;
}


/// 对已递增排序的数组旋转, 求旋转后最值, 算法复杂度为lg(n);
/// 依据点: 注意到旋转后的数组可看成两个有序子数组, 唯有最小值同时比前序值和后序值小;
void min_value_of_rotated_sorted_array(const int *array, size_t length, int *result) {
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
    size_t midIndex = (startIndex + endIndex)/2;
    int priorValue = array[midIndex - 1];
    int nextValue = array[midIndex + 1];
    int midValue = array[midIndex];
    
    // 中间值如果>=首值, 说明中间值落在前面的有序子数组中;
    // 中间值<前序 && 中间值<=后序, 此时中间值即为最小值;
    // 中间值如果<=尾值, 说明中间值落在后面的有序子数组中;
    if (midValue >= array[startIndex]) {
        // 考虑较特殊的序列: 1, 0, 1, 1, 1 或 1, 1, 1 即相等的元素很多;
        // 上面的判断将失效, 此时不得不顺序查找;
        if (midValue == array[startIndex] && midValue == array[endIndex]) {
            int minValue = array[startIndex];
            for (int i = 0; i < length; ++ i) {
                if (array[i] < minValue) {
                    minValue = array[i];
                }
            }
            *result = minValue;
        } else {
            // Tag: 注意此算法不能像二分查找那样，从array + midIndex + 1开始下一段查找，因为上面的三个条件
            // 不像二分查找只需比较相等那么简单，下一轮查找的子数组必须包含当前的midvalue。
            // 比如考虑这种情况，2，2，3，0，1，2，第一次midvalue为3，>=首值又不等于
            // 尾值，所以下一轮查找范围在2的后面，但不能不包含3，把下次查找的子数组设为0，1，2，这样下次还会继续满足这个
            // 条件，会继续往后面的片段查找，导致永远错过真正的最小值。
            min_value_of_rotated_sorted_array(array + midIndex, length - midIndex, result);
        }
        return;
    } else if (midValue < priorValue && midValue <= nextValue) {
        *result = midValue;
        return;
    } else {
        return min_value_of_rotated_sorted_array(array, midIndex + 1, result);
    }
}
void __min_value_of_rotated_sorted_array(const int *array, int start_index, int end_index, int *result) {
    
}

#pragma mark - Test
void test_min_value_of_rotated_sorted_array() {
//    int data[] = {4,5,6,7,8,9,10,13,-1,1,2,3};
//    int data[] = {2, 2, 2, 2, 0, 1, 1, 1};
    int data[] = {2, 2, 3, 0, 1, 2};
    int result = -1;
    
    size_t length = sizeof(data)/sizeof(int);
    min_value_of_rotated_sorted_array(data, length, &result);
    debug_log("%d\n", result);
    
    int data2[] = {-2, -1, -1, 0, 0, 1, 2, 3, 4, 5, 6, 7};
    int target_value_index = -1;
    binary_search_of(data2, sizeof(data2)/sizeof(int), 4, &target_value_index);
    if (target_value_index < 0) {
        debug_log("\nnot found!\n");
    } else {
        debug_log("\nfound: %dth -- %d\n", target_value_index, data2[target_value_index]);
    }
}
