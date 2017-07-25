//
//  MergeSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/18.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "MergeSort.hpp"

void merge_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    for (size_t gap = 1; gap < length; gap *= 2) {
        size_t i = 0;
        // 归并gap长度的两个相邻子表
        // i + 2 * gap - 1 < length 用于确保剩余未遍历的子序列中
        // 还存在相邻两个都是gap长度的情况
        // 目的是暂时不处理最后剩余的无法配对的子序列
        // 而把处理放在for循环的出口之后
        for (; i + 2 * gap - 1 < length; i = i + 2 * gap) {
            merge_two_sorted_arrays(data + i, gap, data + i + gap, gap);
        }
        
        // 处理剩余的子表，目前我能想到两种情况
        // > 1.只剩余一个子表，比如 gap = 1 的时候，有奇数个子序列
        //     那么最后一个子表就是剩余的子表，因为此时for的出口肯定是i指向最后一个子表（也就是最后一个元素）；
        //     即使如此，在下面的if块中还是可以当做有两个子表来看待，虽然此时data + i + gap越界了，
        //     但length-(i+gap)却为0，而merge_two_sorted_arrays函数对于有0长度的输入不做处理立即返回
        //     所以不会有任何影响
        // > 2.剩余两个子表，此时后者长度一定小于gap
        if (i + gap < length) {
            merge_two_sorted_arrays(data + i, gap, data + i + gap, length - (i + gap));
        }
    }
}

void merge_two_sorted_arrays(int *array_1, size_t length_1, int *array_2, size_t length_2)
{
    if (array_1 == NULL || array_2 == NULL) {
        return;
    }
    if (length_1 == 0 || length_2 == 0) {
        return;
    }
    
    // 创建临时空间
    size_t temp_array_memory_length = (length_1 +length_2) * sizeof(int);
    int *temp_array = (int *)malloc(temp_array_memory_length);
    memset(temp_array, 0, temp_array_memory_length);
    
    size_t array1_index     = 0;
    size_t array2_index     = 0;
    size_t temp_array_index = 0;
    
    // 从两个有序子序列中取当前迭代器指向的元素
    // 把较小者放入临时数组
    while (array1_index < length_1 && array2_index < length_2) {
        if (array_1[array1_index] <= array_2[array2_index]) {
            temp_array[temp_array_index ++] = array_1[array1_index ++];
        } else {
            temp_array[temp_array_index ++] = array_2[array2_index ++];
        }
    }
    
    // 追加剩余元素，注意到剩余元素一定是有序的较大值
    if (array1_index < length_1) {
        while (array1_index < length_1) {
            temp_array[temp_array_index ++] = array_1[array1_index ++];
        }
    } else if (array2_index < length_2) {
        while (array2_index < length_2) {
            temp_array[temp_array_index ++] = array_2[array2_index ++];
        }
    }
    
    // 把合并后的值按位置拷回原来的序列
    for (temp_array_index = 0; temp_array_index < length_1 + length_2; temp_array_index ++) {
        if (temp_array_index < length_1) {
            array_1[temp_array_index] = temp_array[temp_array_index];
        } else {
            array_2[temp_array_index - length_1] = temp_array[temp_array_index];
        }
    }
    
    // 释放临时空间
    free(temp_array);
}


