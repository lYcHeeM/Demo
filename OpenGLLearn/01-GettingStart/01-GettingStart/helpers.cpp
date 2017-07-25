//
//  helpers.cpp
//  01-GettingStart
//
//  Created by luozhijun on 16/9/2.
//  Copyright © 2016年 luozhijun. All rights reserved.
//


#include "helpers.h"

vector<string> split_string(const string &sourceString, string separate_character)
{
    vector<string> result;
    
    size_t separate_characterLen = separate_character.size();//分割字符串的长度,这样就可以支持如“,,”多字符串的分隔符
    size_t lastPosition = 0, index = -1;
    while (-1 != (index = sourceString.find(separate_character,lastPosition)))
    {
        result.push_back(sourceString.substr(lastPosition, index - lastPosition));
        lastPosition = index + separate_characterLen;
    }
    string lastString = sourceString.substr(lastPosition);//截取最后一个分隔符后的内容
    if (!lastString.empty())
        result.push_back(lastString);//如果最后一个分隔符后还有内容就入队
    return result;
}

void debug_printf(const char *fmt, ...)
{
#ifdef DEBUG
    vector<string> pathComponents = split_string(__FILE__, "/");
    cout << "[" << pathComponents[pathComponents.size()-1] << "]" << "--" << "[line:" << __LINE__ << "]:" << endl;
    
    va_list ap;
    const char *p, *sval;
    int ival;
    double dval;
    
    va_start(ap, fmt);
    for (p = fmt; *p; p++) {
        if(*p != '%') {
            putchar(*p);
            continue;
        }
        switch(*++p) {
            case 'd':
                ival = va_arg(ap, int);
                printf("%d", ival);
                break;
            case 'f':
                dval = va_arg(ap, double);
                printf("%f", dval);
                break;
            case 's':
                for (sval = va_arg(ap, char *); *sval; sval++)
                    putchar(*sval);
                break;
            default:
                putchar(*p);
                break;
        }
    }
    va_end(ap);
#endif
}

