//
//  main.cpp
//  ttsdfs
//
//  Created by luozhijun on 15/7/24.
//  Copyright © 2015年 luozhijun. All rights reserved.
//

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int trimStringSpace(const char *inBuf, char **outBuf)
{
    int ret = 0;
    
    if (inBuf == NULL) {
        ret = -1;
        return ret;
    }
    
    const char *starP = inBuf;
    const char *endP = starP + strlen(inBuf);
    
    while (*starP == ' ') starP ++;
    
    while (*endP == ' ' || *endP == '\0') endP --;
    
    size_t resultStringLen = (endP - starP + 1) / sizeof(char);
    char *result = (char *)malloc((resultStringLen + 1) * sizeof(char));
    result = (char *)memcpy(result, starP, resultStringLen);
    *(result + resultStringLen) = '\0';
    
    *outBuf = result;
    
    return ret;
}

int divString(const char *sourceStr, char **leftOutBuf, char **rightOutBuf)
{
    int ret = 0;
    
    if (sourceStr == NULL) {
        ret = -1;
        return ret;
    }
    
    int i = 0;
    while (*(sourceStr + i) != '=') {
        i ++;
    }
    
    size_t leftStrLen = i;
    size_t rightStrLen = strlen(sourceStr) - i - 1;
    char *leftString = (char *)malloc((leftStrLen + 1) * sizeof(char *));
    char *rightString = (char *)malloc((rightStrLen + 1) * sizeof(char *));
    
    leftString = (char *)memcpy(leftString, sourceStr, leftStrLen);
    *(leftString + i) = '\0';
    rightString = (char *)memcpy(rightString, sourceStr + i + 1, rightStrLen + 1);
    
    char *leftTrimStr = NULL;
    char *rightTrimStr = NULL;
    
    trimStringSpace(leftString, &leftTrimStr);
    trimStringSpace(rightString, &rightTrimStr);
    
    free(leftString);
    leftString = NULL;
    free(rightString);
    rightString = NULL;
    
    *leftOutBuf = leftTrimStr;
    *rightOutBuf = rightTrimStr;
    
    return ret;
}

int getValueByKey(const char **keyValues, int keyValuesCount, const char *key, char **outbuf, size_t *outBufLen)
{
    int ret = 0;
    
    if (keyValues == NULL || keyValuesCount == 0 || key == NULL) {
        ret = -1;
        return ret;
    }
    
//    char **allKeysAddress = (char **)malloc(keyValuesCount * sizeof(char *));
//    char **allValuesAddress = (char **)malloc(keyValuesCount * sizeof(char *));
    
    for (int i = 0; i < keyValuesCount; ++ i) {
        char *leftTrimStr = NULL;
        char *rightTrimStr = NULL;
//        printf("%s\n", *(keyValues + i));
        divString(*(keyValues + i), &leftTrimStr, &rightTrimStr);
        printf("%s\n", leftTrimStr);
        printf("%s\n", rightTrimStr);
        if (!strcmp(key, leftTrimStr)) {
            *outbuf = rightTrimStr;
            *outBufLen = strlen(rightTrimStr);
            free(leftTrimStr);
            break;
        } else {
            free(rightTrimStr);
        }
//        *(allKeysAddress + i) = leftTrimStr;
//        *(allValuesAddress + i) = rightTrimStr;
    }
    
    return ret;
}

int main()
{
 
    const char *kv1 = "tom =   america";
    const char *kv2 = " panda =   china  ";
    const char *kv3 = "   tencent  = shenzhen   ";
    const char *keyValues[3] = {kv1, kv2, kv3};
    
    char *result = NULL;
    size_t resLen = 0;
    
    getValueByKey(keyValues, 3, "tencent", &result, &resLen);
    
    printf("value: %s\n", result);
    
    free(result);
    result = NULL;
    
    return 0;
}






