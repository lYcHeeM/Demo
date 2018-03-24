//
//  common.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/15.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "common.hpp"
#include <string.h>

void print_int_array(int *array, size_t length) {
    if (array == NULL || length == 0) {
        return;
    }
    printf("\n");
    for (size_t i = 0; i < length; ++ i) {
        printf("%d  ", array[i]);
    }
    printf("\n");
}

const char * file_name() {
    size_t len = strlen(__FILE__);
    int i = (int)(len - 1);
    // 获取最后一个斜杆的位置
    for (; i >= 0; --i)
        if (__FILE__[i] == '/') break;
    size_t file_name_len = len - 1 - i;
    char *temp = (char *)malloc((file_name_len + 1) * sizeof(char));
    if (!temp) return NULL;
    strcpy(temp, &(__FILE__[i+1]));
    temp[file_name_len] = '\0';
    return temp;
}

//static inline void debug_log_1(const char * __restrict, ...) {
//    size_t len = strlen(__FILE__);
//    int i = (int)(len - 1);
//    for (; i >= 0; --i)
//        if (__FILE__[i] == '/') break;
//    size_t file_name_len = len - 1 - i;
//    printf(">>[%s]--[line:%ld]:\n",  &(__FILE__[i+1]), __LINE__);
//}

bool double_equal(double left, double right) {
    double tolerance = 1e-6;
    if (left - right >= -tolerance && left - right <= tolerance)
        return true;
    else
        return false;
}

