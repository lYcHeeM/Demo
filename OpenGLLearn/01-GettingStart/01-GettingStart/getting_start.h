//
//  getting_start.h
//  01-GettingStart
//
//  Created by luozhijun on 16/9/1.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#ifndef getting_start_h
#define getting_start_h

#include <iostream>

// GLEW
#define GLEW_STATIC
#include <GL/glew.h>

// GLFW
#include <GLFW/glfw3.h>

#define GLSL(version, shader) "#version " #version "\n" #shader

// Function prototypes
int getting_start(GLFWwindow **out_window);
int gameloop(GLFWwindow *window, void (*renderFunction)(void));
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode);

#endif /* getting_start_h */
