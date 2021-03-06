//
//  QuickSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "QuickSort.hpp"
#include <time.h>
#include <iostream>

void quick_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    int partition_position = -1;
//    partition_array(data, data + length - 1, &partition_position);
    partition_array_1(data, length, -1, &partition_position);
    if (partition_position < 0 || partition_position >= length) return;
    
    // 得到分隔位置（下标）后，对左右两个子序列再以同样的方式排序
    // 直到最后排序的长度为1为止
    quick_sort(data, partition_position);
    quick_sort(data + partition_position + 1, length - partition_position - 1);
}

void partition_array(int *start, int *end, int *out_partition_position) {
    if (start == NULL || end == NULL || start >= end || out_partition_position == NULL) return;
    
    // 参照值
    // 此处把尾部的数据作为参照值
    int refrence = *end;
    // 空位置, 初始状态为参照值的位置
    int *empty_positon = end;
    // 复制一份形参，以免直接修改形参，导致后面用的时候出现非预期结果
    // 下面会看到start还要使用
    int *using_start = start;
    
    while (using_start != end) {
        // start < end 是为了防止refrence刚好是一个很大的数
        // 这样的话start会一直后移，超出数列边界，直到访问到一个地址中的值比refrence大为止
        // 这样很可能造成死循环
        while (*using_start <= refrence && using_start < end) {
            using_start ++;
        }
        if (using_start != end) {
            // 把using_start位置和空位置交换
            *empty_positon = *using_start;
            empty_positon = using_start;
        }
        while (*end >= refrence && end > using_start) {
            end --;
        }
        if (end != using_start) {
            // 把end位置和空位置交换
            *empty_positon = *end;
            empty_positon = end;
        }
    }
    
    // 把参考值放入最终状态的空位置，此时便达到参考值左边的元素<=参考值，参考值右边的元素>=参考值
    *empty_positon = refrence;
    *out_partition_position = (int)(empty_positon - start);
}

/// @param ref_pos 调用者可指定参考值的位置, 也可不指定(此时ref_pos传-1);
/// @param result_pos 如果不指定参考值的位置, 此参数将存储参考值位置的输出;
int partition_array_1(int *array, size_t len, int ref_pos, int *result_pos) {
    if (!array || len <= 1) return -1;
    if ((ref_pos < 0 || ref_pos >= len) && !result_pos) return -2;
    
    int *p_refrence = NULL;
    if (ref_pos >= 0) {
        p_refrence = array + ref_pos;
    } else {
        size_t random_index = 0;
        int state = random_in_range(len, &random_index);
        if (state != 0) return state;
        p_refrence = array + (int)random_index;
    }
    
    // 交换参考值和尾值
    int *end = array + len - 1;
    swap_two_values(p_refrence, end);
    
    int smaller_index = -1;
    for (int index = 0; index < len - 1; ++ index) {
        if (array[index] < *end) {
            ++ smaller_index;
            if (smaller_index != index) {
                swap_two_values(&array[index], &array[smaller_index]);
            }
        }
    }
    
    ++ smaller_index;
    swap_two_values(&array[smaller_index], end);
    
    if (result_pos) *result_pos = smaller_index;
    return 0;
}

int random_in_range(size_t range, size_t *result) {
    if (range == 0 || result == NULL) return -1;
    srand((unsigned)time(NULL));
    *result = rand() % range;
    return 0;
}

void swap_two_values(int *left, int *right) {
    if (!left || !right) return;
    int temp = *left;
    *left = *right;
    *right = temp;
    return;
}


