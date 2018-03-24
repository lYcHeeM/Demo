//
//  AboutArray.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/15.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutArray.hpp"

/// 在一个二维数组中查找目标值。
/// 二维数组行、列均是升序，即没一行从左往右升序，每一列从上往下升序；
/// 简便起见，省去错误处理；
/// 方法：二维数组逻辑上看成一个矩阵，取右上角或左下角为参考值（其他不可），
/// 以右上角为例，如果它大于目标值，则说明最后一列可从查找范围中去除；否则第一行
/// 可从第一行中去除。如此不断缩小范围，当列数或行数缩小至0时，右上角的值
/// 还是不等于目标值，则表示查找失败。
/// 时间复杂度：O(m + n)
bool array_search_value_in_partitial_sorted_matrix(int *matrix, size_t rows, size_t columns, int target) {
    
    // 这两个变量用于定位右上角的值
    int current_row = 0;
    int current_column = (int)(columns - 1);
    
    while (current_row < rows && current_column >= 0) {
        int top_right_element = matrix[current_row * columns + current_column];
        if (top_right_element == target) {
            return true;
        } else if (top_right_element > target) {
            -- current_column;
        } else {
            ++ current_row;
        }
    }
    
    return false;
}

/// 归并两个有序数组，把第二个数组的元素插入到第一个数组的合适位置，使得归并后的序列还是有序，
/// 此处假定第一个数组后面有足够的空间，且简便起见，不做出错处理。
void merge_two_sorted_array_without_temp_memory(int *seq1, size_t length1, const int *seq2, size_t length2) {
    size_t total_len = length1 + length2;
    // 指向第一个序列的末尾，即为当前可写数据的地方
    size_t writing_index = total_len - 1;
    int tail1 = (int)(length1 - 1);
    int tail2 = (int)(length2 - 1);
    
    while (tail1 >= 0 && tail2 >= 0) {
        if (seq2[tail2] >= seq1[tail1]) {
            seq1[writing_index --] = seq2[tail2 --];
        } else {
            seq1[writing_index --] = seq1[tail1 --];
        }
    }
    
    // 如果序列2还剩余元素未插入，则继续拷贝。注意到剩余元素比序列1所有元素都要小。
    while (tail2 >= 0)
        seq1[writing_index --] = seq2[tail2 --];
    // 与申请临时空间的归并不一样的是，此时不需要再检查序列1是否遍历完，因为序列1的元素
    // 本来就在序列1的头部; 可用极端情况举例，假设seq2中最小元素都大于seq1中最大元素，
    // 则只需把seq2的所有元素拷贝到seq1后面，此时tail1变量的值不会被修改。
}
void test_merge_two_sorted_array_without_temp_memory() {
    printf("====NO:1====");
    int seq1[10] = {-3, 2, 3, 5};
    int seq2[5] = {-1, 0, 3, 4, 6};
    merge_two_sorted_array_without_temp_memory(seq1, 4, seq2, 5);
    print_int_array(seq1, 9);
    
    printf("====NO:2====");
    int seq3[10] = {1, 2, 3, 5};
    int seq4[5] = {-1, 0, 3, 4, 6};
    merge_two_sorted_array_without_temp_memory(seq3, 4, seq4, 5);
    print_int_array(seq3, 9);
    
    printf("====NO:3 seq1 all > seq2 ====");
    int seq5[10] = {7, 8, 9, 10};
    int seq6[5] = {-1, 0, 3, 4, 6};
    merge_two_sorted_array_without_temp_memory(seq5, 4, seq6, 5);
    print_int_array(seq5, 9);
    
    printf("====NO:4 seq1 all < seq2 ====");
    int seq7[10] = {-3, -2, -1, 0};
    int seq8[5] = {3, 4, 5, 6, 7};
    merge_two_sorted_array_without_temp_memory(seq7, 4, seq8, 5);
    print_int_array(seq7, 9);
}


