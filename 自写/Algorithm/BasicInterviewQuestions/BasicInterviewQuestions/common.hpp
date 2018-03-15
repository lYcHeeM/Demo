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

#define debug_log(...) \
size_t len = strlen(__FILE__);\
int i = (int)(len - 1);\
for (; i >= 0; --i)\
    if (__FILE__[i] == '/') break;\
printf(">>[%s]--[line:%ld]:\n",  &(__FILE__[i+1]), __LINE__); printf(__VA_ARGS__);

const char * file_name();
void print_int_array(int *array, size_t length);

#endif /* common_h */
