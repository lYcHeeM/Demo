//
//  main.cpp
//  StringAddtionSubtraction
//
//  Created by luozhijun on 16/9/20.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include <iostream>

// 任务：打印从1到n位数的最大值

#pragma mark - 方法1 字符串数字增量
bool should_increment_number_in_string(char *numbers_string)
{
    if (numbers_string == NULL) {
        return false;
    }
    
    // 是否超出当前字符串能容纳的最大正整数
    bool isOverflow = false;
    // 是否有进位
    int hasCarry = 0;
    
    int length = (int)strlen(numbers_string);
    // 当前字符位的数值大小
    int valueOfCurrentCharacter = 0;
    
    for (int index = length - 1; index >= 0; -- index) {
        
        valueOfCurrentCharacter = numbers_string[index] - '0' + hasCarry;
        if (index == length - 1) { // 给最末位一个增量，即每次加1
            valueOfCurrentCharacter ++;
        }
        
        if (valueOfCurrentCharacter >= 10) { // 如果当前字符位的数值大于等于10
            // 则要么进位，要么直接结束（当遍历到最开头的时候，因为第一位数需要进位意味着当前字符串所能表达的数值已达最大）
            if (index == 0) {
                isOverflow = true;
                // 把前面因进位改为0的字符位改回来
                for (int i = length - 1; i >= 1; -- i) {
                    numbers_string[i] = '9';
                }
            } else {
                valueOfCurrentCharacter = 0;
                hasCarry = 1;
                numbers_string[index] = '0' + valueOfCurrentCharacter;
            }
        } else { // 否则直接给当前位赋值，并结束遍历
            numbers_string[index] = valueOfCurrentCharacter + '0';
            break;
        }
    }
    
    return isOverflow;
}

void print_number_in_string(char *numbers_string)
{
    if (numbers_string == NULL) {
        return;
    }
    
    for (size_t i = 0; i < strlen(numbers_string); ++ i) {
        if (numbers_string[i] > '0') {
            printf("%s\t", numbers_string + i);
            break;
        }
    }
}

/**
 *  @param placeAmountOfNumber 需要打印多少位数
 */
void print_number_from_1_to_max(size_t placeAmountOfNumber)
{
    if (placeAmountOfNumber == 0) {
        return;
    }
    
    char *numbers_string = (char *)malloc(sizeof(char) * (placeAmountOfNumber + 1));
    if (numbers_string == NULL) {
        return;
    }
    memset(numbers_string, '0', sizeof(char) * placeAmountOfNumber);
    numbers_string[placeAmountOfNumber] = '\0';
    
    
    while (!should_increment_number_in_string(numbers_string)) {
        print_number_in_string(numbers_string);
    }
}

#pragma mark - 方法2 排列组合
void print_number___(char *numbers_string, size_t length, size_t index)
{
    if (length == 0) {
        return;
    }
    
    if (index == length) {
        print_number_in_string(numbers_string);
        return;
    }
    
    ++index;
    for (int j = 0; j < 10; j ++) {
        numbers_string[index] = '0' + j;
        print_number___(numbers_string, length, index);
    }
}

void print_number_from_1_to_max_recursively(size_t placeAmountOfNumber)
{
    if (placeAmountOfNumber == 0) {
        return;
    }
    
    char *numbers_string = (char *)malloc((placeAmountOfNumber + 1) * sizeof(char));
    if (numbers_string == NULL) {
        return;
    }
    memset(numbers_string, '0', (placeAmountOfNumber + 1) * sizeof(char));
    numbers_string[placeAmountOfNumber] = '\0';
    
    print_number___(numbers_string, placeAmountOfNumber, 0);
}




int main(int argc, const char * argv[]) {
    
//    print_number_from_1_to_max(3);
    print_number_from_1_to_max_recursively(2);
    
    std::cout << "Hello, World!\n";
    return 0;
}
