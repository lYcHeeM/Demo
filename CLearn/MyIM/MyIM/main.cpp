//
//  main.c
//  MyIM
//
//  Created by luozhijun on 2018/3/1.
//  Copyright © 2018年 luozhijun. All rights reserved.
//  参考: https://www.binarytides.com/socket-programming-c-linux-tutorial/

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h> // struct sockaddr_in
#include <arpa/inet.h> // inet_addr
#include <string.h> // strlen
#include <netdb.h> // struct hostent
#include <unistd.h> // write
#include <pthread.h> // handle multiple connection at one time;
#include <stdlib.h>

struct in_addr ipaddress_by_hostname(const char *host_name);
int create_socket_server();
void * connection_handler(void *sender);

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
    // 1.创建socket
    /*
     参数含义:
     Address Family Internat - AF_INET (this is IP version 4)
     Type - SOCK_STREAM (this means connection oriented TCP protocol), SOCK_DGRAM -- UDP
     Protocol - 0 [ or IPPROTO_IP This is IP protocol]
    */
    int socket_descriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_descriptor == -1) {
        printf("socket_descriptor create error\n");
        return -1;
    }
    
    // 2.创建链接信息, 须用`struct sockaddr_in`结构体封装
    struct sockaddr_in server_addr;
    // 14.215.177.39是ping www.baidu.com得到的ip地址;
    server_addr.sin_addr.s_addr = inet_addr("14.215.177.39");
    // Address Family Internat - AF_INET (this is IP version 4)
    server_addr.sin_family = AF_INET;
    // http是80端口
    server_addr.sin_port = htons(80);
    
    // 3.连接到服务器(另一个进程)
    if (connect(socket_descriptor, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        printf("connect error\n");
        return -2;
    }
    printf("Server connected\n");
    
    // 4.发送接收数据
    // ------------
    // 发送数据. 下面用一个最简单的HTTP get请求来获取百度的主页html文件
    char message[] = "GET / HTTP/1.1\r\n\r\n";
    // 也可用等价函数: write
    if (send(socket_descriptor, message, strlen(message), 0) < 0) {
        printf("Message send failed!\n");
        return -3;
    }
    printf("HTTP Head send succeed!\n");
    
    // 接收服务器回应.
    size_t len = 5000;
    char server_reply[len];
    // 也可用等价函数: read(socket_desc, server_reply , len);
    // 在socket概念中, 接收数据相当于从socket对象中读数据, 此时可把socket看做文件;
    if (recv(socket_descriptor, server_reply, len, 0) < 0) {
        printf("Receive failed!\n");
        return -4;
    }
    printf("Receive succeed!🎉:\n %s\n", server_reply);
    // ----------
    
    // 5.关闭socket, 对于tcp来说意味着要断开连接
//    close(socket_descriptor);
    
    // 6.通过域名获得ip, 这样发起连接就不需要先查找、再输入抽象的ip地址
    struct in_addr ip_addr = ipaddress_by_hostname("www.baidu.com");
    char *ip_addr_s = inet_ntoa(ip_addr);
    printf("===: %s\n", ip_addr_s);
    
    // 7.建立socket服务端.
    // 服务端和客户端不同之处, 其中之一是客户端一般是根据需要主动发起连接,
    // 而服务端需一直等待(监听)多个客户端的请求, 并恰当地响应之;
    __unused int server_sock_ref = create_socket_server();

    return 0;
}

/// 通过域名获取ip地址, 如果获取失败,
/// 返回的in_addr机构体中的字段将为初始值0, 否则返回ip的long格式.
struct in_addr ipaddress_by_hostname(const char *host_name) {
    struct hostent *he = NULL;
    // result
    struct in_addr in_ip_addr = {0};
    
    he = gethostbyname(host_name);
    if (he == NULL){
        herror("gethostbyname error\n");
        return in_ip_addr;
    }
    
    // 很奇怪, char **类型的h_addr_list, 打印这个列表, 却得到一串乱码,
    for (int i = 0; he->h_addr_list[i] != NULL; i ++) {
        printf("%s\n", he->h_addr_list[i]);
    }
    // 所以参考前辈的方法, 此处莫名其妙地转为struct in_addr **
    struct in_addr **converted = (struct in_addr **)he->h_addr_list;
    for (int i = 0; converted[i] != NULL; i ++) {
        printf("%d\n", converted[i]->s_addr);
    }
    
    char *ip_addr_s = inet_ntoa(*(converted[0]));
    printf("%s resolved to: %s\n", host_name, ip_addr_s);
    
    // 此处取地址列表中的第一个ip地址
    in_ip_addr = *(converted[0]);
    return in_ip_addr;
}

int create_socket_server() {
    // 1.创建socket对象
    int socket_ref = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_ref == -1) return -1;
    
    // 2.配置连接数据
    struct sockaddr_in connection_info;
    connection_info.sin_family = AF_INET;
    // 任意ip
    connection_info.sin_addr.s_addr = INADDR_ANY;
    // 设定端口号
    connection_info.sin_port = htons(8997);
    
    // 3.将socket对象绑定至指定的端口.
    // By doing this we ensure that all incoming data
    // which is directed towards this port number is received by this application.
    // This makes it obvious that you cannot have 2 sockets bound to the same port.
    if (bind(socket_ref, (struct sockaddr *)&connection_info, sizeof(connection_info)) < 0) {
        printf("Bind failed!😂\n");
        return socket_ref;
    }
    printf("Bind succeed!🎉\n");
    
    // 4.监听可能到来的连接
    // listen函数将把socket对象转为监听模式
    listen(socket_ref, 3);
    printf("Waiting for incoming connections...\n");
    
    // 5.接受连接(如果有的话)
    // 可在本地终端键入telnet localhost 8991试试, telnet也是基于tcp的,
    // 会向127.0.0.1 8991建立tcp连接, 建立成功后, 下面的Connection accepted!🔥便会打印出来;
    int c = sizeof(struct sockaddr_in);
    // 用于保存连接过来的客户端的信息
    struct sockaddr_in client_info;
    // accept函数会返回一个新的socket对象
    int new_socket_ref = -1;
//    accept(socket_ref, (struct sockaddr *)&client_info, (socklen_t *)&c);
//    if (new_socket_ref < 0) {
//        printf("Accept failed!😂\n");
//        return socket_ref;
//    }
//    printf("Connection accepted!🔥\n");
//
//    // 6.获取连接的客户端的ip和端口号
//    char *client_ip = inet_ntoa(client_info.sin_addr);
//    int client_port = ntohs(client_info.sin_port);
//    printf("Client ip address: %s, Port: %d\n", client_ip, client_port);
    
    // 7.给客户端发数据
    char message[] = "Hello, client. I'm your server🐼\n";
//    write(new_socket_ref, message, strlen(message));
    
    // 8.既然是服务端, 则要永久保持对(多)连接的接收.
    // 循环accept后, 打开多个终端, 依次发送telnet localhost 8991, 就都可以连接到这个服务端了, 也都可收到回应信息;
    // 注意: 因为写了循环接收连接, 上面的单次接收则可注释, 其实是否注释上面的代码其实不会影响以下代码;
    while ( (new_socket_ref = accept(socket_ref, (struct sockaddr *)&client_info, (socklen_t *)&c)) >= 0) {
        printf("👉🏻: Connection accepted!🔥\n");
        char *client_ip = inet_ntoa(client_info.sin_addr);
        int client_port = ntohs(client_info.sin_port);
        printf("👉🏻: Client ip address: %s, Port: %d.\n", client_ip, client_port);
        
        // 注意必须在accept函数返回的socket对象中写数据;
        write(new_socket_ref, message, strlen(message));
        
        // 为每个连接开一个线程, 这样不会阻塞主服务器对其他连接的接收,
        // 即把处理连接的操作和accept连接的操作分开处理, 主线程的接收连接优先级较高;
        pthread_t handler_thread;
        // 把accept函数返回的socket对象拷贝到堆内存, pthread_create函数会把它当做参数传到hander函数;
        int *new_sock_ref_p = (int *)malloc(1 * sizeof(int));
        *new_sock_ref_p = new_socket_ref;
        if (pthread_create(&handler_thread, NULL, connection_handler, (void *)new_sock_ref_p) < 0) { // #1
            printf("👉🏻: Reply thread create failed!😂\n");
            return socket_ref;
        }
        printf("👉🏻: Handler assigned!🎉\n");
        printf("\n\n");
    }
    if (new_socket_ref < 0) {
        printf("👉🏻: Accept failed\n");
    }
    
    return socket_ref;
}

/// 负责处理和每一个客户端的连接
void *connection_handler(void *sender) {
    int socket_ref = *(int *)sender;
    char *message = "Greetings! I am your connection handler😁.\n";
    write(socket_ref, message, strlen(message));
    message = "Its my duty to communicate with you🌝.\n\n";
    write(socket_ref, message, strlen(message));
    
    // 永久等待客户端的数据并回复之
    ssize_t read_size = 0, client_message_len = 2000;
    char client_message[client_message_len];
    while ( (read_size = recv(socket_ref, client_message, client_message_len, 0)) >0 ) {
        char *temp = "Here's your message: \"";
        write(socket_ref, temp, strlen(temp));
        write(socket_ref, client_message, strlen(client_message));
        temp = ".\"";
        write(socket_ref, temp, strlen(temp));
        
        printf("Something to reply: \n");
        char ch = '\0', reply_buffer[client_message_len];
        size_t index = 0;
        while ( (ch = getchar()) != '\n') { // 回车结束输入
            reply_buffer[index ++] = ch;
        }
        reply_buffer[index ++] = '\n';
        reply_buffer[index] = '\0';
        if (strlen(reply_buffer) > 0) {
            write(socket_ref, reply_buffer, strlen(reply_buffer));
        }
    }
    if (read_size == 0) {
        puts("Client disconnected!🙊\n");
        fflush(stdout);
    } else if (read_size == -1) {
        perror("`revc` failed!\n");
    }
    
    // 因#1代码把新创建的内存的引用传入了当前handler,
    // 故此处有责任把传过来的参数所引用的内存释放掉;
    free(sender);
    return NULL;
}
