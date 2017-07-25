//
//  first_triangle.cpp
//  01-GettingStart
//
//  Created by luozhijun on 16/9/1.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

#include "first_triangle.h"


// 教程：http://learnopengl-cn.readthedocs.io/zh/latest/01%20Getting%20started/04%20Hello%20Triangle/
int first_triangle()
{
    GLFWwindow *window = NULL;
    
    int ret = getting_start(&window);
    
    if (ret != 0) {
        return ret;
    }
    
    // ---------------------------------------
    // Define a vertex shader
    // ---------------------------------------
    // 1.Vertex shader source: a C string
    const GLchar *vertexShaderSource = GLSL(330 core, layout (location = 0) in vec3 position;
         void main() {
             gl_Position = vec4(position.x, position.y, position.z, 1.0);
         });
    // 2.Compile vertex shader
        // 2.1.Create vertex shader object
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        // 2.2.Attach shader source on shader object
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
        // 2.3.Compile
    glCompileShader(vertexShader);
        // 2.4.Check the compilation
    GLint hasSuccess = 0;
    GLchar shaderCompileInfoLog[512] = {0};
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &hasSuccess);
    if (!hasSuccess) {
        glGetShaderInfoLog(vertexShader, sizeof(shaderCompileInfoLog)/sizeof(GLchar), NULL, shaderCompileInfoLog);
        debugLog("Vertex shader compilation failed: %s", shaderCompileInfoLog);
    }
    
    // ---------------------------------------
    // Define a fragment shader
    // ---------------------------------------
    const GLchar *fragmentShaderSource = GLSL(330 core, out vec4 color;
                                              void main() {
                                                  color = vec4(1.0, 0.5, 0.2, 1.0);
                                              });
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    hasSuccess = 0;
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &hasSuccess);
    if (!hasSuccess) {
        glGetShaderInfoLog(fragmentShader, sizeof(shaderCompileInfoLog)/sizeof(GLchar), NULL, shaderCompileInfoLog);
        debugLog("Fragment shader compilation failed: %s", shaderCompileInfoLog);
    }
    
    // ---------------------------------------
    // Link shader program
    // ---------------------------------------
    GLuint shaderProgram = glCreateProgram();
        // Attach shaders
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    hasSuccess = 0;
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &hasSuccess);
    if (!hasSuccess) {
        glGetProgramInfoLog(shaderProgram, sizeof(shaderCompileInfoLog)/sizeof(GLchar), NULL, shaderCompileInfoLog);
        debugLog("Link shader program failed: %s", shaderCompileInfoLog);
    }
    // Use shader program
    // glUseProgram成功调用之后，每个着色器调用和渲染调用都会使用这个程序对象，也就是会使用之前定制的着色器。此处注释，表示在后面使用，下同。
//    glUseProgram(shaderProgram);
    // Delete shader objects
    // 可以删除刚才创建的着色器对象了
    // 记得以前学习CF框架时，曾学到每个create、copy都要对应一次CFRelease，此处也类似哈
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    // ---------------------------------------
    // Input vertex data to buffer. 输入顶点数据到显存
    // ---------------------------------------
    GLfloat triangleVertices[] = {
        0.5, -0.5, 0, // 左下角
        -0.5, -0.5, 0, // 右下角
        0, 0.5, 0 // 顶部
    };
    // Create vertex buffer object
    GLuint triangleVBO = 0;
    glGenBuffers(1, &triangleVBO);
    // Bind buffer, 绑定缓存, OpenGL允许绑定多个缓存，只要它们是不同类型的
//    glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
    // Copy ROM data to GPU buffer, 把内存中的数据写入申请好的显存
    // 第4个参数指定了显卡管理给定数据的策略，GL_STATIC_DRAW指示数据不会或几乎不会改变。GL_DYNAMIC_DRAW：数据会被改变很多；GL_STREAM_DRAW ：数据每次绘制时都会改变。
//    glBufferData(GL_ARRAY_BUFFER, sizeof(triangleVertices), triangleVertices, GL_STATIC_DRAW);
    
    // ---------------------------------------
    // Link vertex attributes. 链接顶点属性
    // ---------------------------------------
    /**
     第一个参数指定我们要配置的顶点属性。还记得我们在顶点着色器中使用layout(location = 0)定义了position顶点属性的位置值(Location)吗？它可以把顶点属性的位置值设置为0。因为我们希望把数据传递到这一个顶点属性中，所以这里我们传入0。
     第二个参数指定顶点属性的大小。顶点属性是一个vec3，它由3个值组成，所以大小是3。
     第三个参数指定数据的类型，这里是GL_FLOAT(GLSL中vec*都是由浮点数值组成的)。
     下个参数定义我们是否希望数据被标准化(Normalize)。如果我们设置为GL_TRUE，所有数据都会被映射到0（对于有符号型signed数据是-1）到1之间。我们把它设置为GL_FALSE。
     第五个参数叫做步长(Stride)，它告诉我们在连续的顶点属性组之间的间隔。由于下个组位置数据在3个GLfloat之后，我们把步长设置为3 * sizeof(GLfloat)。要注意的是由于我们知道这个数组是紧密排列的（在两个顶点属性之间没有空隙）我们也可以设置为0来让OpenGL决定具体步长是多少（只有当数值是紧密排列时才可用）。一旦我们有更多的顶点属性，我们就必须更小心地定义每个顶点属性之间的间隔，我们在后面会看到更多的例子(译注: 这个参数的意思简单说就是从这个属性第二次出现的地方到整个数组0位置之间有多少字节)。
     最后一个参数的类型是GLvoid*，所以需要我们进行这个奇怪的强制类型转换。它表示位置数据在缓冲中起始位置的偏移量(Offset)。由于位置数据在数组的开头，所以这里是0。我们会在后面详细解释这个参数。

     */
//    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid *)0);
    // Enable vertex attributes, it is disabled in default. 启用顶点属性, 默认情况下顶点属性是禁用的。
//    glEnableVertexAttribArray(0);
    
    // ---------------------------------------
    // Vertex array object. 顶点数组对象，用于抽象顶点缓存和顶点属性配置，便于重用。
    // ---------------------------------------
    // 前面从创建VBO到配置完顶点属性，这个过程比较繁琐，而且其间的状态配置无法保存，VAO便可解决这个问题，它即可引用VBO，也能保存与之相关的状态配置。
    
    // 初始化代码，一般只运行一次
    GLuint triangleVAO = 0;
    glGenVertexArrays(1, &triangleVAO);
        // 1.需要先绑定VAO, 方能保存
    glBindVertexArray(triangleVAO);
    {
        // 2.拷贝顶点数据到显存
        glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(triangleVertices), triangleVertices, GL_STATIC_DRAW);
        // 3.设置（链接）顶点属性
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid *)0);
        glEnableVertexAttribArray(0);
        // 4.解绑VBO
        // Note that this is allowed, the call to glVertexAttribPointer registered VBO as the currently bound vertex buffer object so afterwards we can safely unbind
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }
    glBindVertexArray(0); // 4.保存完毕之后，解绑VAO，防止之后的意外修改
    
    // ---------------------------------------
    // quadrangle 如何绘制四边形，OpenGL主要处理三角形，矩形可由两个三角形拼接而成
    // ---------------------------------------
    /**
    GLfloat quadrangleVertices[] = {
        // 第一个三角形
        -0.5, 0.5, 0,
        0.5, 0.5, 0,
        -0.5, -0.5, 0,
        // 第二个三角形
        -0.5, -0.5, 0,
        0.5, -0.5, 0,
        0.5, 0.5, 0,
    };
     */
    // 上面的顶点数据有两组是完全相同的，因为两个三角形共有6个顶点，而一个四边形只需要4个顶点，这样便造成了50%的存储浪费，为了解决这个问题，引入Vertex Element Buffer Object，顶点索引缓冲对象EBO，告诉OpenGL如何使用顶点的顺序以及如何利用重叠的顶点
    GLfloat quadrangleVertices[] = {
        -0.5, 0.5, 0, // 左上角
        0.5, 0.5, 0, // 右上角
        0.5, -0.5, 0, // 右下角
        -0.5, -0.5, 0 // 左下角
    };
    GLuint quadrangleVBO = 0;
    glGenBuffers(1, &quadrangleVBO);
    // 顶点索引数据
    GLuint quadrangleVertexIndices[] = {
        0, 1, 2, // 第一个三角形
        0, 2, 3 // 第二个三角形
    };
    // 顶点索引缓冲对象EBO
    GLuint quadrangleEBO = 0;
    glGenBuffers(1, &quadrangleEBO);
    // 用VAO保存
    GLuint quadrangleVAO = 0;
    glGenVertexArrays(1, &quadrangleVAO);
    // 开始保存
    glBindVertexArray(quadrangleVAO);
    {
        // 拷贝顶点数据到显存
        glBindBuffer(GL_ARRAY_BUFFER, quadrangleVBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(quadrangleVertices), quadrangleVertices, GL_STATIC_DRAW);
        // 拷贝顶点索引数据到显存
        // 当目标是GL_ELEMENT_ARRAY_BUFFER的时候，VAO会储存glBindBuffer的函数调用。这也意味着它也会储存解绑调用，所以确保你没有在解绑VAO之前解绑索引数组缓冲，否则它就没有这个EBO配置了。
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, quadrangleEBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(quadrangleVertexIndices), quadrangleVertexIndices, GL_STATIC_DRAW);
        // 设置顶点属性指针
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid *)0);
        glEnableVertexAttribArray(0);
        // 解绑VBO
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }
    glBindVertexArray(0); // 结束保存
    
    // ---------------------------------------
    // Uncommenting this call will result in wireframe polygons.
    // 设置多边形的绘制模式，下面的参数将指定OpenGL之后都以线框模式绘制图元
    // 第一个参数表示我们打算将其应用到所有的三角形的正面和背面，第二个参数告诉我们用线来绘制
    // 默认模式是glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    
    // ---------------------------------------
    // Render. 绘制
    // ---------------------------------------
    // Game loop
    while (!glfwWindowShouldClose(window))
    {
        // Check if any events have been activiated (key pressed, mouse moved etc.) and call corresponding response functions
        glfwPollEvents();
        
        // Clear the colorbuffer
        // 发现不这么做会闪屏
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        // 绘制三角形
//        glUseProgram(shaderProgram);
//        glBindVertexArray(triangleVAO);
//        // 第一个参数指定图元类型，第二个参数表示第一个顶点数据在数组中的偏移量，第二个数据指定需要绘制的顶点个数
//        glDrawArrays(GL_TRIANGLES, 0, 3);
//        glBindVertexArray(0);
        
        // 绘制四边形
        glUseProgram(shaderProgram);
        glBindVertexArray(quadrangleVAO);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
        glBindVertexArray(0);
        
        glfwSwapBuffers(window);
    }
    
    // 删除所有缓存对象
    glDeleteVertexArrays(1, &triangleVAO);
    glDeleteVertexArrays(1, &quadrangleVAO);
    glDeleteBuffers(1, &triangleVBO);
    glDeleteBuffers(1, &quadrangleVBO);
    glDeleteBuffers(1, &quadrangleEBO);
    
    glfwTerminate();
    return 0;
}



