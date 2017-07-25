//
//  main.cpp
//  01-GettingStart
//
//  Created by luozhijun on 16/9/1.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "getting_start.h"
#include "first_triangle.h"

void test_getting_start_render() {
    // Render
    // Clear the colorbuffer
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

void test_getting_start() {
    
    GLFWwindow *window = NULL;
    
    int ret = getting_start(&window);
    
    if (ret == 0) {
        gameloop(window, test_getting_start_render);
    }
}

int main()
{
    debugLog("aaa");
    // test getting_start
//    test_getting_start();
    
    // test first_traingle
    first_triangle();

    return 0;
}