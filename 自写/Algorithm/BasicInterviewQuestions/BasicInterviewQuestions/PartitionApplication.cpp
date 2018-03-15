//
//  PartitionApplication.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "PartitionApplication.hpp"
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
    if (start == NULL || end == NULL || start > end || out_partition_position == NULL) return;
    
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
    if (!array || len == 0) return -1;
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
    
    int small_index = -1;
    for (int index = 0; index < len - 1; ++ index) {
        if (array[index] < *end) {
            ++ small_index;
            if (small_index != index) {
                swap_two_values(&array[index], &array[small_index]);
            }
        }
    }
    
    ++ small_index;
    swap_two_values(&array[small_index], end);
    
    if (result_pos) *result_pos = small_index;
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


#pragma -
/// 求序列中的第k大元素, 假设序列没有相等的元素;
/// 平均算法复杂度(partition函数需要O(n)时间): O(n) + O(n/2) + O(n/4) + ... + O(n/2^log<2>n) (注意这是一个等比数列)
/// = O((n - 1*(1/2))/(1-(1/2))) = O(2n - 1) ——> O(n)
int the_Kth_large_element_in(int *array, size_t length, size_t K, int *result) {
    if (!array || length == 0 || K > length || K == 0 || !result) return -1;
    
    // 把K映射为期待得到的数组分割位置(partition_position)
    int expecting_pos = (int)(length - K);
    
    int partition_pos = -1;
    partition_array_1(array, length, -1, &partition_pos);
    if (partition_pos < 0) return -2;
    
    // 接下来要进行partition操作的子数组长度
    size_t current_partition_array_length = length;
    // 上次一进行partition操作的子数组相对于最初始数组的首地址偏移量
    size_t last_partition_start_index = 0;
    
    while (expecting_pos != partition_pos) {
        size_t current_partition_start_index = 0;
        if (partition_pos > expecting_pos) { // 目标值落在左边, 接下来要对左侧的子数组进行分割操作(调用partition函数)
            current_partition_array_length = (size_t)partition_pos;
            current_partition_start_index = last_partition_start_index;
        } else { // 目标值落在右边, 接下来要对右侧的子数组进行分割操作(调用partition函数)
            // 下一次将对右边数组进行分割操作时, 要对应调整期望位置expecting_pos;
            // 因为每次分割得到的postion都是从子数组的开头开始计数的,
            // 而expecting_pos一开始是相对于初始数组的起始计算的;
            expecting_pos -= (size_t)partition_pos + 1;
            current_partition_array_length -= (size_t)partition_pos + 1;
            current_partition_start_index = last_partition_start_index + partition_pos + 1;
        }
        last_partition_start_index = current_partition_start_index;
        partition_array_1(array + current_partition_start_index, current_partition_array_length, -1, &partition_pos);
        if (partition_pos < 0) return -2;
    }
    // 到此处, 第K大元素位于第(lenth-K)
    *result = array[length - K];
    return 0;
}

void test_the_Kth_large_algorithm() {
    for (int i = 0; i < 99999; ++ i) {
        int data[] = {4,5,6,7,8,9,10,11,0,1,2};
        int result = -1;
        size_t length = sizeof(data)/sizeof(int);
        int ret = the_Kth_large_element_in(data, length, 6, &result);
        print_int_array(data, length);
        printf("return state = %d\n", ret);
        printf("result = %d\n", result);
        printf("==========================\n");
        printf("i = %d\n", i);
        assert(result == 6);
        usleep(10000);
    }
    
    printf("test_the_Kth_large_algorithm succeed🎉!\n");
}

