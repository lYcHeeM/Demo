//
//  QuickSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "QuickSort.hpp"

void quick_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    int partition_position = -1;
    partition_array(data, data + length - 1, &partition_position);
    if (partition_position < 0) {
        return;
    }
    
    // 得到分隔位置（下标）后，对左右两个子序列再以同样的方式排序
    // 直到最后排序的长度为1为止
    quick_sort(data, partition_position);
    quick_sort(data + partition_position + 1, length - partition_position - 1);
}

void partition_array(int *start, int *end, int *out_partition_position)
{
    if (start == NULL || end == NULL || start >= end || out_partition_position == NULL) {
        return;
    }
    
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



