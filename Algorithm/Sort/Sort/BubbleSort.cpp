//
//  BubbleSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "BubbleSort.hpp"

void bubble_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    // 标识当前数列是否已排好序
    bool isSorted = true;
    
    for (size_t index_1 = 0; index_1 < length - 1; ++ index_1) {
        isSorted = true;
        // 相邻元素两两比较
        for (size_t index_2 = 0; index_2 < length - index_1 - 1; ++ index_2) {
            if (data[index_2] > data[index_2 + 1]) {
                isSorted = false;
                int temp = data[index_2];
                data[index_2] = data[index_2 + 1];
                data[index_2 + 1] = temp;
            }
        }
        if (isSorted) {
            break;
        }
    }
}

void bubble_sort_recursive(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    bool isSorted = true;
    
    // 相邻元素两两比较
    for (size_t index = 0; index < length - 1; ++ index) {
        if (data[index] > data[index + 1]) {
            isSorted = false;
            int temp = data[index];
            data[index] = data[index + 1];
            data[index + 1] = temp;
        }
    }
    
    if (isSorted) {
        return;
    }
    
    bubble_sort(data, length - 1);
}