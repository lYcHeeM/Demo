//
//  InsertSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "InsertSort.hpp"

void insert_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    // 有序数列，初始状态长度为1，包含原数列中的第一个元素
    int *sorted_array = data;
    size_t sorted_array_length = 1;
    
    // 对有序数列扩充n-1次，每次扩充一个元素，此元素和当前有序数列的尾元素比较，若小于则交换
    // 重复这个过程直到寻找到合适的插入位置
    for (size_t index_1 = 1; index_1 < length; index_1 ++) {
        // 待扩充的新元素在有序数列中的位置
        // 初始值为原数列的当前迭代位置
        size_t new_element_index = index_1;
        for (int index_2 = (int)(sorted_array_length - 1); index_2 >= 0; index_2 --) {
            if (data[new_element_index] < sorted_array[index_2]) {
                int temp = data[new_element_index];
                data[new_element_index] = sorted_array[index_2];
                sorted_array[index_2] = temp;
                // 关键点，容易忽略，新元素移动之后一定要修改其下标
                // 才可正确进行下次一比较
                new_element_index = index_2;
            }
        }
        sorted_array_length ++;
    }
}

// 暂未实现
void insert_sort_recursive(int **data, size_t length)
{
    if (*data == NULL || length == 0) {
        return;
    }
    
    int *sorted_array = (int *)malloc(sizeof(int) * length);
    if (sorted_array == NULL) {
        return;
    }
    
    // 每次递归只扩充一个元素
    int *original_array = *data;
    sorted_array[0] = original_array[0];
    size_t sorted_array_length = 1;
    
    if (sorted_array_length > 1) {
        size_t new_element_index = 0;
        for (int index = (int)(sorted_array_length - 1); index >= 0; index --) {
            sorted_array[sorted_array_length - 1] = original_array[0];
            if (sorted_array[new_element_index] < sorted_array[index]) {
                int temp = sorted_array[index];
                sorted_array[index] = sorted_array[new_element_index];
                sorted_array[new_element_index] = temp;
                new_element_index = index;
            }
        }
    }
    sorted_array_length ++ ;
    
    
    insert_sort_recursive(data + 1, length - 1);
}