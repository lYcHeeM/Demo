//
//  AboutString.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/3.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutString.hpp"
#include <string.h>

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

void test_atoint32() {
    int error_code = 0;
    int number = atoint32("+++++---+2147483648", &error_code);
    debug_log("error code: %d\n", error_code);
    debug_log("number: %d\n", number);
}

/// 翻转一个字符串
int reverse_string(char *str, size_t len) {
    if (!str || len <= 1) return -1;
    
    char *p_begin = str;
    char *p_end   = str + len - 1;
    while (p_begin < p_end) {
        char temp = *p_begin;
        *p_begin = *p_end;
        *p_end = temp;
        ++ p_begin;
        -- p_end;
    }
    return 0;
}
/// 翻转一个字符串，但保留指定子串的内部顺序；
/// 思路：先整体翻转，再对子串执行二次翻转，则子串内部的顺序会被还原；
int reverse_string_expect_substring(char *str, char *substr) {
    int error_code = reverse_string(str, strlen(str));
    if (error_code < 0) return error_code;
    
    size_t substr_len = strlen(substr);
    error_code = reverse_string(substr, substr_len);
    if (error_code < 0) return error_code;
    
    char *substr_position = strstr(str, substr);
    if (!substr_position) return -1;
    error_code = reverse_string(substr_position, substr_len);
    
    return 0;
}

// 输入一个英文句子，翻转句子中单词的顺序，但保持单词内的顺序不变化。
// 注：英文句子的标点只允许有,.?
int reverse_sentence_and_keep_words_order(char *sentence) {
    if (!sentence) return -1;
    
    // 先整体翻转
    reverse_string(sentence, strlen(sentence));
    
    // 再对每个单词翻转，这样每个单词便翻转了两次，其内部的顺序就还原了
    char *p_word_begin = sentence;
    char *p_word_end   = sentence;
    while (*p_word_begin != '\0') {
        if (*p_word_begin == ' ' || *p_word_begin == '?' ||
            *p_word_begin == ',' || *p_word_begin == '.') {
            // 特殊字符不翻转，此处只需对*p_word_begin判断特殊字符，因为只要*p_word_begin为其中任一字符，
            // 必有 p_word_begin = p_word_end; 一开始我加了 && p_word_begin = p_word_end，其实是蛇足；
            ++ p_word_begin;
            ++ p_word_end;
        }
        else if (*p_word_end == ' ' || *p_word_end == '?' ||
                 *p_word_end == ',' || *p_word_end == '.' ||
                 *p_word_end == '\0') {
            // begin指向非特殊字符，且end指向特殊字符时，说明两者之间的字符就是一个单词；
            // 注，判断是否'\0'是考虑到最后一个单词的情况，极有可能最后一个单词的后面没有空格。
            reverse_string(p_word_begin, p_word_end - p_word_begin);
            p_word_begin = ++ p_word_end;
        } else {
            // 其他情况，令end指针前进，寻找单词后面的第一个特殊字符
            ++ p_word_end;
        }
    }
    
    // 如果翻转后的sentence最后的字符不是空格，则最后一个单词会来不及翻转就退出循环了，
    // 故此处要把这种情况考虑进去，其实更好的办法是修改while循环的条件，不要以 "*p_word_end != '\0'"
    // 为判断条件，而应该是"*p_word_begin != '\0'"。
//    if (p_word_end > p_word_begin) {
//        reverse_string(p_word_begin, p_word_end - p_word_begin);
//    }
    return 0;
}

void test_reverse_string() {
    int error_code = 0;
    // Tag: 注意不能用char *str = "...."; 因为这是不可修改的字符串，会遇到EXC_BAD_ACCESS错误。
    char str[] = "Hello, I am a student, how about you?  ";
    char substr[] = "about";
    error_code = reverse_string_expect_substring(str, substr);
    debug_log("error_code = %d\n", error_code);
    debug_log("%s\n%s", str, substr);
    
    char str2[] = "Hello, I am a student, how about you? Haha.  ";
    error_code = reverse_sentence_and_keep_words_order(str2);
    debug_log("%s\n", str2);
}

