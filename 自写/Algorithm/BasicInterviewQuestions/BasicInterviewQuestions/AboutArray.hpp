//
//  AboutArray.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/15.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef AboutArray_hpp
#define AboutArray_hpp

#include <stdio.h>
#include "common.hpp"

// 数组相关

/// 在一个二维数组中查找目标值。
/// 二维数组行、列均是升序，即没一行从左往右升序，每一列从上往下升序；
/// 简便起见，省去错误处理；
/// 方法：二维数组逻辑上看成一个矩阵，取右上角或左下角为参考值（其他不可），
/// 以右上角为例，如果它大于目标值，则说明最后一列可从查找范围中去除；否则第一行
/// 可从第一行中去除。如此不断缩小范围，当列数或行数缩小至0时，右上角的值
/// 还是不等于目标值，则表示查找失败。
/// 时间复杂度：O(m + n)
bool array_search_value_in_partitial_sorted_matrix(int *matrix, size_t rows, size_t columns, int target);


/// 归并两个有序数组，把第二个数组的元素插入到第一个数组的合适位置，使得归并后的序列还是有序，
/// 此处假定第一个数组后面有足够的空间，且简便起见，不做出错处理。
void merge_two_sorted_array_without_temp_memory(int *seq1, size_t length1, const int *seq2, size_t length2);
void test_merge_two_sorted_array_without_temp_memory();


#endif /* AboutArray_hpp */
