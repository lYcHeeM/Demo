//
//  AboutBitOperation.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/22.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutBitOperation.hpp"
#include "common.hpp"

double __power_with_unsigned_exponent(double base, unsigned int exponent);
double my_power(double base, int exponent, int *error_code) {
    // 底数为零并且指数为负数时，说明输入有误；
    // 试想当指数为负的时候，我们要先求x^n，再对结果求倒数，而如果分母为零，程序会奔溃；
    if (double_equal(base, 0) && exponent < 0) {
        if (error_code) *error_code = -1;
        return 0;
    }
    
    unsigned int unsigned_exponent = exponent;
    if (exponent < 0)
        unsigned_exponent = -exponent;
    double result = __power_with_unsigned_exponent(base, unsigned_exponent);
    if (exponent < 0)
        result = 1/result;
    
    return result;
}

double __power_with_unsigned_exponent(double base, unsigned int exponent) {
    if (exponent == 0) return 1;
    if (exponent == 1) return base;

    // 先求 x^n/2
    double result = __power_with_unsigned_exponent(base, exponent >> 1);
    // 对结果求二次方
    result *= result;
    // 如果指数是奇数，比如31，则上面的结果只是x^30，故要再乘一次底数
    // 注意 &运算 的优先级比 == 低
    if ( (exponent & 1) == 1 )
        result *= base;
    
    return result;
}
