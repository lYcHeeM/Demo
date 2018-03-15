//
//  common.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/3/15.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "common.hpp"

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
