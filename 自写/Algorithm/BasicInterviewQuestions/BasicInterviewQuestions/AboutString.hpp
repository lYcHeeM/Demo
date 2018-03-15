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
/// 把一个ASCII的字符串转为数字, 时间复杂度为O(n);
/// error_code: -1 -> 空指针或空字符; -2 -> 没有数字字符; -3 -> 值溢出
int atoint32(const char *string, int *error_code);
#endif /* AboutString_hpp */
