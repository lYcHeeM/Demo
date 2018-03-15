//
//  AboutString.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/3.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutString.hpp"

/// 把一个ASCII的字符串转为数字, 时间复杂度为O(n);
/// error_code: -1 -> 空指针或空字符; -2 -> 没有数字字符; -3 -> 值溢出;
int atoint32(const char *string, int *error_code) {
    long long result = 0;
    if (!string || *string == '\0') {
        if (error_code) *error_code = -1;
        return (int)result;
    }
    
    // 考虑值溢出
    const long int32_max = 0x7fffffff;
    const long int32_min = 0x80000000;
    
    // 允许起始字符有除数字和正负号之外的其他字符
    char *number = (char *)string;
    // 注意一定加上*number != '\0'的限定, 否则如果输入字符串压根没有数字和正负号的话,
    // 迭代定会超出字符串的范围, 并可能一直循环下去, #1处代码同理.
    while (*number != '+' && *number != '-' && (*number < '0' || *number > '9') && *number != '\0')
        number ++;
    
    // 允许数字字符前面有正负号
    bool is_minus = false;
    while ((*number == '+' || *number == '-') && *number != '\0') // #1
        number ++;
    if (number != string) { // 判断最后一个正负号是否为负号
        char *last_traversal_num = number - 1;
        if (*last_traversal_num == '-')
            is_minus = true;
    }
    
    // 只有非数字字符: 非法输入
    if (*number == '\0') {
        if (error_code) *error_code = -2;
        return (int)result;
    }
    
    while (*number != '\0') {
        result = result * 10 + (*number - '0');
        if (!is_minus) { // >= int允许的最大正数
            if (result > int32_max) {
                result = int32_max;
                if (error_code) *error_code = -3;
                break;
            }
        } else { // <= int允许的最小负数, 注意到最小负数的绝对值比最大正数大1
            if (result > int32_max + 1) {
                result = int32_min;
                if (error_code) *error_code = -3;
                break;
            }
        }
        number ++;
    }
    if (is_minus) result = -result;
    
    return (int)result;
}
