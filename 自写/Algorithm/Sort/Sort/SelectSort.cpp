//
//  SelectSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "SelectSort.hpp"

void select_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    // n-1次循环
    for (size_t index_1 = 0; index_1 < length - 1; ++ index_1) {
        // 找出最小值
        int min = data[index_1];
        size_t min_index = index_1;
        for (size_t index_2 = index_1 + 1; index_2 < length; ++ index_2) {
            if (data[index_2] < min) {
                min = data[index_2];
                min_index = index_2;
            }
        }
        
        // 和当前循环第一个元素交换
        int temp = data[index_1];
        data[index_1] = data[min_index];
        data[min_index] = temp;
    }
}

void select_sort_recursive(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    // 找出最小值
    size_t min_index = 0;
    int min = data[min_index];
    for (size_t index = 1; index < length; ++ index) {
        if (data[index] < min) {
            min = data[index];
            min_index = index;
        }
    }
    // 和第一个元素交换
    if (min_index != 0) {
        int temp = data[0];
        data[0] = data[min_index];
        data[min_index] = temp;
    }
    // 注意不可data++
    select_sort_recursive(++data, length - 1);
}