//
//  main.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include <iostream>
#include "SelectSort.hpp"
#include "BubbleSort.hpp"
#include "InsertSort.hpp"
#include "ShellSort.hpp"
#include "QuickSort.hpp"
#include "MergeSort.hpp"
#include "HeapSort.hpp"

void print_int_array(int *array, size_t length)
{
    if (array == NULL || length == 0) {
        return;
    }
    printf("\n");
    for (size_t i = 0; i < length; ++ i) {
        printf("%d  ", array[i]);
    }
    printf("\n");
}

bool is_left_smaller(int left, int right) {
    return left <= right;
}

int main(int argc, const char * argv[]) {
    
    int data[] = {4, 9, 14, 6, 10, 3, 15, 8, 2, 5, 13, 11, 1, 7, 6, 10, 12, 3, 8, 2, 5, 11, 1, 7, 3, 8, 2, 5, 11, 20, 1011, -5, -1023, -4};
    size_t length = sizeof(data)/sizeof(data[0]);
    print_int_array(data, length);
//    merge_sort(data, length);
//    quick_sort(data, length);
//    print_int_array(data, length);
    
//    merge_sort_recursively(data, length, is_left_smaller);
    heap_sort(data, length, false);
//    int temp = 0;
//    partition_array(data, data + length - 1, &temp);
//    partition_array(data, data + length - 1, &temp);
//    partition_array(data, data + length - 1, &temp);
//    partition_array(data, data + length - 1, &temp);
    print_int_array(data, length);
    
    int a = -16;
    if (((a - 1) & a) != 0) {
        printf("不是2的整数次方\n");
    } else {
        printf("是2的整数次方\n");
    }
    
    
//    std::cout << "Hello, World!\n";
    return 0;
}



