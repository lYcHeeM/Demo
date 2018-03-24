//
//  common.h
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/15.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef common_h
#define common_h

#include <iostream>
#include <cassert>
#include <unistd.h>
#include <set>
#include <stdio.h>
#include <exception>

/// 为防止外界使用诸如 if (a) debug_log() 形式, 而这个宏的本质是替换代码（犹豫有\连接符，此处全是替换成一行代码），
/// 也由于此，下面的__LINE__变量才是准确的。
/// 而如果if不写大括号的话只有第一句(;号代表一句)代码从属于if，故此处要用一个大括号括住所有代码。
#define debug_log(...) {\
    for (int i = (int)(strlen(__FILE__) - 1); i >= 0; --i)\
        if (__FILE__[i] == '/') {\
            printf("\n>>[%s]--[line:%d]: ",  &(__FILE__[i+1]), __LINE__);\
            break;\
        }\
    printf(__VA_ARGS__);\
}

//static inline void print_fl(const char* file = __FILE__, int line = __LINE__) {
//    for (int i = (int)(strlen(file) - 1); i >= 0; --i)\
//        if (file[i] == '/') {
//            printf(">>[%s]--[line:%d]:\n",  &(file[i+1]), line);\
//            break;
//        }
//}

#define print_fl \
for (int i = (int)(strlen(__FILE__) - 1); i >= 0; --i)\
    if (__FILE__[i] == '/') {\
        printf(">>[%s]--[line:%d]:\n",  &(__FILE__[i+1]), __LINE__);\
        break;\
    }

const char * file_name();
void print_int_array(int *array, size_t length);

bool double_equal(double left, double right);

#endif /* common_h */
