//
//  StringAddition.cpp
//  StringAddtionSubtraction
//
//  Created by luozhijun on 2018/1/23.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "StringAddition.hpp"
#include <iostream>
#include <stack>

/// 大整数加法
const char * string_addition(const char *string1, const char *string2) {
    if (string1 == NULL && string2 == NULL) {
        return NULL;
    } else if (string1 != NULL && string2 == NULL) {
        return string1;
    } else if (string1 == NULL && string2 != NULL) {
        return string2;
    }
    
    bool hasCarry = false;
    int len_1 = (int)strlen(string1);
    int len_2 = (int)strlen(string2);
    const char *longerString = len_1 >= len_2 ? string1 : string2;
    const char *shorterString = len_1 < len_2 ? string1 : string2;
    int longerLength = len_1 >= len_2 ? len_1 : len_2;
    int shorterLength = len_1 < len_2 ? len_1 : len_2;
    
    // 考虑到从尾部往前遍历, 此处用栈缓存每一位已完成计算的数字字符
    std::stack<char> addedNumChars = std::stack<char>();
    
    int shorterStringIndex = shorterLength - 1;
    for (int i = longerLength - 1; i >= 0; i --) {
        int num1 = longerString[i] - '0';
        int num2 = 0;
        if(shorterStringIndex >= 0) {
            num2 += shorterString[shorterStringIndex] - '0';
        }
        
        int addedValue = num1 + num2;
        if (hasCarry) addedValue ++;
        
        addedNumChars.push(addedValue % 10 + '0');
        hasCarry = addedValue >= 10;
        
        if (shorterStringIndex < 0) {
            // 拷贝较长字符串中, 不需要再进行计算的数字字符
            for (int index_2 = i - 1; index_2 >= 0; index_2 --) {
                addedNumChars.push(longerString[index_2]);
            }
            break;
        }
        shorterStringIndex --;
    }
        
    if (shorterLength == longerLength && hasCarry) {
        addedNumChars.push('1');
    }
    
    char *result = NULL;
    result = (char *)malloc((addedNumChars.size() + 1) * sizeof(char));
    if (result == NULL) return NULL;
    memset(result, '0', (addedNumChars.size() + 1) * sizeof(char));
    result[addedNumChars.size()] = '\0';
    
    int index = 0;
    while (!addedNumChars.empty()) {
        result[index] = addedNumChars.top();
        addedNumChars.pop();
        index ++;
    }
    return result;
}


