//
//  AboutString.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/3.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef AboutString_hpp
#define AboutString_hpp

#include <stdio.h>
#include "common.hpp"

/// 把一个ASCII的字符串转为数字, 时间复杂度为O(n);
/// error_code: -1 -> 空指针或空字符; -2 -> 没有数字字符; -3 -> 值溢出
int atoint32(const char *string, int *error_code);
void test_atoint32();

/// 翻转一个字符串
int reverse_string(char *str, size_t len);
/// 翻转一个字符串，但保留指定子串的内部顺序；
/// 思路：先整体翻转，再对子串执行二次翻转，则子串内部的顺序会被还原；
int reverse_string_expect_substring(char *str, char *substr);

// 输入一个英文句子，翻转句子中单词的顺序，但保持单词内的顺序不变化。
// 注：英文句子的标点只允许有,.?
int reverse_sentence_and_keep_words_order(char *sentence);

void test_reverse_string();


#endif /* AboutString_hpp */
