//
//  AboutLinkedList.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/2/1.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef AboutLinkedList_hpp
#define AboutLinkedList_hpp

// 单向链表相关
#include <stdio.h>
#include <iostream>

/// 单向链表节点
struct LinkedListNode {
    int value;
    LinkedListNode *p_next = NULL;
};

/// 单向链表数据类型
struct LinkedList {
    LinkedListNode *head = NULL;
    size_t length = 0;
};

/// 链表节点指针
typedef LinkedListNode * LNodePt;
/// 链表指针
typedef LinkedList * LListPt;

#pragma mark - Methods
LListPt linked_list_init();
int linked_list_destory(LListPt list);
void linked_list_print(LListPt list);

/// 查找第index(从0开始计数)个节点
int linked_list_node_at(LListPt list, size_t index, LNodePt *target_node);

/// 在第index个元素前面插入新元素
/// - 链表头结点为空, 不论index输入何值, 都把新节点插到尾部
/// 插入过程不会发生拷贝, 此行为造成的后果由调用者负责(比如new_node的p_next指针极可能会被修改);
int insert_node_at(LListPt list, LNodePt new_node, size_t index);

/// 在指定节点之后插入新的节点, 由调用者负责保证指定节点在list中(意味着链表的长度一定>=1)
/// 插入过程不会发生拷贝, 此行为造成的后果由调用者负责(比如new_node的p_next指针极可能会被修改);
int insert_node_after(LListPt list, LNodePt target_node, LNodePt new_node);

/// 插入过程不会发生拷贝, 此行为造成的后果由调用者负责(比如new_node的p_next指针极可能会被修改);
int append_node(LListPt list, LNodePt new_node);


/// 按位置删除节点, 注意被删除的节点的内存不会被释放.
/// 参数`deleted_node`可引用被删除的节点, 调用者自行决定是否释放其内存.
int remove_node_at(LListPt list, size_t index, LNodePt *deleted_node);

/// 以平均时间复杂度O(1)删除指定地址的节点, 注意被删除的节点的内存不会被释放
/// (参数`deleted_node`可引用被删除的节点, 调用者自行决定是否释放其内存):
/// 方法是把待删除节点后继的内容拷贝到待删除节点中(实际上删除的是待删除节点的下一个节点);
/// 在有多个节点, 且删除的是尾节点时, 这个小技巧就不管用了,
/// 此时调用remove_node_at(...)函数, 以O(n)时间复杂度删除尾节点;
/// 注意, 考虑到效率, 此函数不检查target_node引用的节点是否在list内, 由调用者负责;
int remove_node(LListPt list, LNodePt target_node, LNodePt *deleted_node);

/// 以O(n)时间复杂度、O(1)空间复杂度反转链表
int linked_list_reverse(LListPt list);

/// 一次遍历内, 求链表倒数第K个节点(K从1开始计数)。
/// 有两种方法: 1.倒数第k个节点(为了符合人的习惯, k从1开始计数), 相当于第length-k个节点(从0开始计数);
/// 2.对于没有length字段的链表, 可用两个异步指针, 使它们的距离保持k-1,
/// 当步调快的指针到达末尾时, 步调慢的指针指向的节点自然就是整个链表的倒数第k个节点了;
/// 此处为了练习, 先写下"异步指针"代码后, 再用最直接的方法1;
int linked_list_the_last_Kth_node(LListPt list, size_t k, LNodePt *target_node);

/// 合并两个有序链表, 由调用者负责保证它们的排序类型相同(同时升序或降序);
/// 不会修改原来的链表, 合并后链表中的节点都已从原始链表拷贝;
int linked_list_merge_two_sorted_list(LListPt first, LListPt second, bool is_ascend, bool is_left_smaller(LNodePt, LNodePt), LListPt *output);

#pragma mark - Test
void test_linked_list();

#endif /* AboutLinkedList_hpp */






