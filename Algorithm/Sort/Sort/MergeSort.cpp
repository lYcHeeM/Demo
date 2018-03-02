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
    
    // 外层循环floor(log^2(length) + 1)次;
    // 内存循环应该从整体上看, 合并所有子数组需要遍历整个序列, 所以内层循环的总次数是length;
    // 所以时间复杂度为: O(n*logn), 空间复杂度为: O(n) (考虑最大的情况, 合并最后两个子数组, 此时需要length的常数倍的临时空间)
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


void __merge_sort_recursively(int *sequence, size_t start, size_t end, bool (*is_left_smaller)(int, int), int **cache);
/// 归并排序, 递归方式;
int merge_sort_recursively(int *sequence, size_t length, bool (*is_left_smaller)(int, int)) {
    if (!sequence || length == 0 || !is_left_smaller) return -1;
    
    // 可在每次归并操作时创建所需缓存,
    // 但一次性分配最大所需缓存, 性能更好.
    // 由此可见这是以空间复杂度为O(n)换取部分的时间复杂度(O(n^2)->O(n*logn));
    int *cache = (int *)malloc(length * sizeof(int));
    // 可确定copyed数组将会被重写, 故无需初始化.
    // memset(copyed, 0, length * sizeof(int));
    
    __merge_sort_recursively(sequence, 0, length - 1, is_left_smaller, &cache);
    free(cache);
    return 0;
}

void __merge_sort_recursively(int *sequence, size_t start, size_t end, bool (*is_left_smaller)(int, int), int **cache) {
    if (start == end) {
        (*cache)[start] = sequence[start];
        return;
    }
    
    // 取一个点, 作为序列的逻辑分割点, 分别对分割点左右两边的子序列归并排序
    size_t division_index = (start + end) / 2;
    __merge_sort_recursively(sequence, start, division_index, is_left_smaller, cache);
    __merge_sort_recursively(sequence, division_index + 1, end, is_left_smaller, cache);
    
    // 执行至此处, 即可确定逻辑分割点(division_index)左右两侧的子序列是有序的了;
    // 接下来只需合并这两个子序列.
    size_t left_array_index  = start;
    size_t right_array_index = division_index + 1;
    size_t cache_array_index = start;
    while (left_array_index <= division_index && right_array_index <= end) // 较小者拷入临时序列
        if (is_left_smaller(sequence[left_array_index], sequence[right_array_index]))
            (*cache)[cache_array_index ++] = sequence[left_array_index ++];
        else
            (*cache)[cache_array_index ++] = sequence[right_array_index ++];
    
    // 追加剩余元素, 由于两个子序列都是有序, 故以下的两个while只有其一可进入.
    while (left_array_index <= division_index)
        (*cache)[cache_array_index ++] = sequence[left_array_index ++];
    while (right_array_index <= end)
        (*cache)[cache_array_index ++] = sequence[right_array_index ++];
    
    // 把当前归并得到的有序子序列拷回至原始序列对应的位置.
    for (size_t i = start; i <= end; ++ i)
        sequence[i] = (*cache)[i];
}

