//
//  helpers.h
//  01-GettingStart
//
//  Created by luozhijun on 16/9/2.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#ifndef helpers_h
#define helpers_h

#include <stdio.h>
#include <stdarg.h>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

#ifdef DEBUG
#define debugLog(message, ...) {vector<string> pathComponents = split_string(__FILE__, "/");\
cout << "[" << pathComponents[pathComponents.size()-1] << "." << __LINE__ << "]-->:";\
printf(message"\n", ##__VA_ARGS__);\
};
#else
#define debugLog(...) 
#endif

vector<string> split_string(const string &sourceString, string separate_character);
void debug_printf(const char *fmt, ...);

#endif /* helpers_h */
