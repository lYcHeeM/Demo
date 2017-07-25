//
//  main.cpp
//  01-GettingStart
//
//  Created by luozhijun on 16/9/1.
//  Copyright © 2016年 luozhijun. All rights reserved.
//
//
//#include <iostream>
//
//// GLEW
//#include <GL/glew.h>
//
//// GLFW
//#include <GLFW/glfw3.h>
//
//void render() {
//    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT);
//    
//    glBegin(GL_TRIANGLES);
//    {
//        glColor3f(1.0f, 0.0f, 0.0f);
//        glVertex2f(0, 0.5);
//        glColor3f(0.0, 1.0, 0.0);
//        glVertex2f(-0.5, -0.5);
//        glColor3f(0.0, 0.0, 1.0);
//        glVertex2f(0.5, -0.5);
//    }
//    glEnd();
//}
//
//void key_callback(GLFWwindow *window, int key, int scancode, int action, int mode) {
//    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
//        glfwSetWindowShouldClose(window, GL_TRUE);
//    }
//}
//
//int main(int argc, const char * argv[]) {
//    // insert code here...
//    std::cout << "Hello, World!\n";
//    
//    GLFWwindow *window = NULL;
//    
//    if (!glfwInit()) {
//        return -1;
//    }
////    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
////    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
////    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
////    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
////    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GLFW_TRUE);
//    
//    window = glfwCreateWindow(640, 480, "First OpenGL Project", NULL, NULL);
//    if (!window) {
//        glfwTerminate();
//        exit(EXIT_FAILURE);
//    }
//
//    glewExperimental = GL_TRUE;
//    if (!glewInit()) {
//        return -1;
//    }
//    glfwMakeContextCurrent(window);
//    
//    int width = 0;
//    int height = 0;
//    glfwGetFramebufferSize(window, &width, &height);
//    glViewport(0, 0, width, height);
//    
//    glfwSetKeyCallback(window, key_callback);
//    while (!glfwWindowShouldClose(window)) {
//        glfwPollEvents();
//        render();
//        glfwSwapBuffers(window);
//    }
//    
//    glfwTerminate();
//    exit(EXIT_SUCCESS);
//    
//    return 0;
//}

#include "getting_start.h"

// Window dimensions
const GLuint WIDTH = 800, HEIGHT = 600;

// The MAIN function, from here we start the application and run the game loop
int getting_start(GLFWwindow **out_window)
{
    std::cout << "Starting GLFW context, OpenGL 3.3" << std::endl;
    // Init GLFW
    glfwInit();
    // Set all the required options for GLFW
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GLFW_TRUE);
    
    // Create a GLFWwindow object that we can use for GLFW's functions
    GLFWwindow* window = glfwCreateWindow(WIDTH, HEIGHT, "LearnOpenGL", nullptr, nullptr);
    if (window == nullptr)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    // Set the required callback functions
    glfwSetKeyCallback(window, key_callback);
    
    // Set this to true so GLEW knows to use a modern approach to retrieving function pointers and extensions
    glewExperimental = GL_TRUE;
    // Initialize GLEW to setup the OpenGL Function pointers
    if (glewInit() != GLEW_OK)
    {
        std::cout << "Failed to initialize GLEW" << std::endl;
        return -1;
    }
    
    // Define the viewport dimensions
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);
    glViewport(0, 0, width, height);
    
    if (out_window) {
        *out_window = window;
    } else {
        std::cout << "[line" << __LINE__ << "]" << "`out_window` is NULL!" << std::endl;
    }
    
    return 0;
}

int gameloop(GLFWwindow *window, void (*renderFunction)(void))
{
    if (window == NULL) {
        std::cout << "[line" << __LINE__ << "]" << "`window` is NULL!" << std::endl;
        return -1;
    }
    
    // Game loop
    while (!glfwWindowShouldClose(window))
    {
        // Check if any events have been activiated (key pressed, mouse moved etc.) and call corresponding response functions
        glfwPollEvents();
        
        if(renderFunction) {
            renderFunction();
        }
        
        // Swap the screen buffers
        glfwSwapBuffers(window);
    }
    
    // Terminate GLFW, clearing any resources allocated by GLFW.
    glfwTerminate();
    return 0;
}

// Is called whenever a key is pressed/released via GLFW
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode)
{
    std::cout << "[line]" << __LINE__ << "-->" << key << std::endl;
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, GL_TRUE);
}


