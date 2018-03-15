//
//  PartitionApplication.hpp
//  Sort
//
//  Created by luozhijun on 16/9/17.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#ifndef PartitionApplication_hpp
#define PartitionApplication_hpp

#include <stdio.h>
#include "common.hpp"

// partition函数的应用

/// 时间复杂度: O(n*logn)
void quick_sort(int *data, size_t length);
/// 时间复杂度: O(n)
void partition_array(int *start, int *end, int *out_refrence_position);

/// 时间复杂度: O(n)
/// @param ref_pos 调用者可指定参考值的位置, 也可不指定(此时ref_pos传-1);
/// @param result_pos 如果不指定参考值的位置, 此参数将存储参考值位置的输出;
int partition_array_1(int *array, size_t len, int ref_pos, int *result_pos);
int random_in_range(size_t range, size_t *result);
void swap_two_values(int *left, int *right);

/// 求序列中的第k大元素, 假设序列没有相等的元素;
/// 算法复杂度: O(n) + O(n/2) + O(n/4) + ... + O(n/2^log<2>n) (注意这是一个等比数列)
/// = O((n - 1*(1/2))/(1-(1/2))) = O(2n - 1) ——> O(n)
int the_Kth_large_element_in(int *array, size_t length, size_t K, int *result);

/// 较为严格的测试函数
void test_the_Kth_large_algorithm();

#endif /* PartitionApplication_hpp */
