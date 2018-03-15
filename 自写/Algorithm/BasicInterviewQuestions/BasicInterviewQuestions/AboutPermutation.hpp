//
//  AboutPermutation.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/5.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef AboutPermutation_hpp
#define AboutPermutation_hpp

/// 全排列相关
#include <stdio.h>

/// 打印一个字符串的全排列, 若参数`result`不为空, 则把结果保存在`result`引用的字符串数组中,
/// 此时函数会尝试分配足够的内存, 意味着调用者须负责`result`所引用内存块的管理;
/// 错误码: -1 -> 输入有误; -2 -> 暂不支持过长的字符串; -3 -> 无法分配足够长的连续内存;
/// 时间复杂度: O(n!), n为字符串长度; 空间复杂度O(n) (若参数`result`非空, 空间复杂度亦为O(n!)).
int string_permutations(const char *string, char ***result, size_t *permutations_amount);

// 测试代码
void string_permutations_test();
#endif /* AboutPermutation_hpp */
