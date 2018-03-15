//
//  AboutPermutation.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/5.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutPermutation.hpp"
#include <stdlib.h>
#include <string.h>

typedef unsigned long size_t;

void __string_permutations(char *string, size_t start, size_t end, char **result, size_t total_count);
void __swap_two_chars(char *left, char *right);

/// 打印一个字符串的全排列, 若参数`result`不为空, 则把结果保存在`result`引用的字符串数组中,
/// 此时函数会尝试分配足够的内存, 意味着调用者须负责`result`所引用内存块的管理;
/// 错误码: -1 -> 输入有误; -2 -> 暂不支持过长的字符串; -3 -> 无法分配足够长的连续内存;
/// 时间复杂度: O(n!), n为字符串长度; 空间复杂度O(n) (若参数`result`非空, 空间复杂度亦为O(n!)).
int string_permutations(const char *string, char ***result, size_t *permutations_amount) {
    if (!string || *string == '\0') return -1;
    
    char **permutations = NULL;
    size_t length = strlen(string);
    size_t permutations_count = 1;
    // 全排列总数为n!
    for (size_t i = 1; i <= length; ++ i)
        permutations_count *= i;
    int max_count_allowed = 0x7ffffff;
    if (permutations_count > max_count_allowed) return -2;
    
    if (result) { // 尝试分配足够的内存, 以存放全部解, 这将是一个含有n!个字符串的字符串数组
        permutations = (char **)malloc(sizeof(char *) * permutations_count);
        if (!permutations) return -3;
        for (size_t i = 0; i < permutations_count; ++ i) {
            permutations[i] = (char *)malloc(sizeof(char) * (length + 1));
            if (!permutations[i]) return -3;
        }
    }
    
    // 为了不修改输入, 此处拷一份输入出来
    char *copyed_string = (char *)malloc(sizeof(char *) * length);
    if (!copyed_string) return -3;
    strcpy(copyed_string, string);
    
    __string_permutations(copyed_string, 0, length - 1, permutations, permutations_count);
    
    // 输出数据
    if (result) *result = permutations;
    if (permutations_amount) *permutations_amount = permutations_count;
    
    return 0;
}

/// 定义内部函数, 便于递归
void __string_permutations(char *string, size_t start, size_t end, char **result, size_t total_count) {
    static size_t counter = 0;
    if (start == end) { // 当前子序列长度为1, 意味着此时的string即为一个排列, 尝试把它保存到result, 并打印之.
        if (result && result[counter]) strcpy(result[counter], string);
        if (counter == 0) printf("====%ld total permutations: ====\n", total_count);
        printf("%s    ", string);
        if (++counter % 10 == 0) printf("\n");
        if (counter == total_count) printf("\n==============\n");
    } else {
        // 把首元素分别与当前待排列子集合中的所有元素交换(包括首元素自身),
        // 使得当前待排列子集合中的每个元素均被固定一次.
        // 时间复杂度: O(n) * O(n-1) * ... * O(1) = O(n!).
        for (size_t i = start; i <= end; ++ i) {
            __swap_two_chars(string + start, string + i);
            // 排列除固定元素之外的子集合, 即执行同样的操作.
            __string_permutations(string, start + 1, end, result, total_count);
            // 当前循环结束前, 须还原交换, 才可保证下次循环依然是和首元素交换:
            // 比如当i = 1时, 当前循环交换后的结果为BACD, 即A和B交换了, 若不还原交换,
            // 则下次循环将为B和C交换, 得到CABD, 与期望得到的交换结果CBAD不符(A和C交换).
            __swap_two_chars(string + start, string + i);
        }
    }
}

/// 交换两个字符
void __swap_two_chars(char *left, char *right) {
    if (!left || !right) return;
    char temp = *left;
    *left = *right;
    *right = temp;
}

