//
//  ShellSort.cpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "ShellSort.hpp"

void shell_sort(int *data, size_t length)
{
    if (data == NULL || length <= 1) {
        return;
    }
    
    // 据说这样的gap：初始值为length/3+1, 之后每次除以3
    // 能使排序的平均时间最短
    size_t gap = length/3 + 1;
    
    do {
        // 对于每个gap，都可产生gap个子序列，每个子序列相邻元素的间隔是gap-1
        // 对所有子序列进行插入排序
        for (size_t index = 0; index < gap; index ++) {
            
            // 以下代码和插入排序一致，只不过把每个子序列看成是一个特殊的序列
            // 其特殊之处是相邻元素间隔gap-1, 所以每次迭代的步长不再是1，而是gap
            
            // 表示已经排好序的子序列
            int *sorted_array = &(data[index]);
            size_t sorted_array_length = 1;
            
            // 遍历子序列的所有元素
            for (size_t index_2 = gap + index; index_2 < length; index_2 += gap) {
                // 扩充有序子序列
                size_t new_element_index = index_2;
                // 和插入排序一样，从后往前遍历当前子序列（由gap产生）的有序子序列，如果比正在遍历的元素大，则交换
                // 会发现如果gap=1，整个代码等价于插入排序
                for (int index_3 = (int)((sorted_array_length - 1) * gap); index_3 >= 0; index_3 -= gap) {
                    if (data[new_element_index] < *(sorted_array + index_3)) {
                        int temp = data[new_element_index];
                        data[new_element_index] = *(sorted_array + index_3);
                        *(sorted_array + index_3) = temp;
                        new_element_index = index_3;
                    }
                }
                sorted_array_length ++;
            }
        }
        
        gap /= 3;
    } while (gap >= 1);
}