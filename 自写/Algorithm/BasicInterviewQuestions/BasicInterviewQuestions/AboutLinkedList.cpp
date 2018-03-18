//
//  AboutLinkedList.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/2/1.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutLinkedList.hpp"

#pragma mark lifecycle
LListPt linked_list_init() {
    LListPt list = (LListPt)malloc(sizeof(LinkedList));
    if (!list) return NULL;
    list->head = NULL;
    list->length = 0;
    return list;
}

int linked_list_destory(LListPt list) {
    if (!list) return -1;
    while (list->head != NULL) {
        LNodePt temp = list->head;
        list->head = temp->p_next;
        free(temp);
        temp = NULL;
        -- list->length;
    }
    free(list);
    list = NULL;
    return 0;
}

void linked_list_print(LListPt list) {
    if (!list || !list->head || list->length == 0) return;
    LNodePt iter = list->head;
    while (iter != NULL) {
        printf("%d\t", iter->value);
        iter = iter->p_next;
    }
    printf("\n==============\n");
}

#pragma mark search
/// 查找第index(从0开始计数)个节点
int linked_list_node_at(LListPt list, size_t index, LNodePt *target_node) {
    if (!list || !list->head || list->length == 0) return -1;
    if (index >= list->length) return -2;
    if (!target_node) return -3;
    
    LNodePt iter = list->head;
    long counter = -1;
    while (iter) {
        ++ counter;
        if (counter == index) break;
        iter = iter->p_next;
    }
    *target_node = iter;
    return 0;
}

#pragma mark insert
/// 在第index个元素前面插入新元素
/// - 链表头结点为空, 不论index输入何值, 都把新节点插到尾部
/// 插入过程不会发生拷贝, 此行为造成的后果由调用者负责(比如new_node的p_next指针极可能会被修改);
int insert_node_at(LListPt list, LNodePt new_node, size_t index) {
    if (!list || !new_node) return -1;
    
    // 链表头结点为空, 不论index输入何值, 都把新节点插到尾部
    if (!list->head || list->length == 0 || index == 0) {
        LNodePt temp_next = list->head;
        list->head = new_node;
        new_node->p_next = temp_next;
        ++ list->length;
        return 0;
    }
    
    if (index >= list->length) return -3;
    
    LNodePt target_node = NULL;
    linked_list_node_at(list, index - 1, &target_node);
    if (!target_node) return -4;
    
    LNodePt temp = target_node->p_next;
    target_node->p_next = new_node;
    new_node->p_next = temp;
    ++ list->length;
    
    return 0;
}

/// 在指定节点之后插入新的节点, 由调用者负责保证指定节点在list中(意味着链表的长度一定>=1)
/// 插入过程不会发生拷贝, 此行为造成的后果由调用者负责(比如new_node的p_next指针极可能会被修改);
int insert_node_after(LListPt list, LNodePt target_node, LNodePt new_node) {
    if (!list) return -1;
    if (!target_node) return -2;
    if (!new_node) return -3;
    
    LNodePt temp = target_node->p_next;
    target_node->p_next = new_node;
    new_node->p_next = temp;
    ++ list->length;
    
    return 0;
}

/// 插入过程不会发生拷贝, 此行为造成的后果由调用者负责(比如new_node的p_next指针极可能会被修改);
int append_node(LListPt list, LNodePt new_node) {
    if (!list) return -1;
    if (!new_node) return -2;
    
    if (!list->head || list->length == 0 ) {
        list->head = new_node;
        new_node->p_next = NULL;
        ++ list->length;
        return 0;
    }
    
    LNodePt target_node = NULL;
    linked_list_node_at(list, list->length - 1, &target_node);
    if (!target_node) return -3;
    
    LNodePt temp_next = target_node->p_next;
    target_node->p_next = new_node;
    new_node->p_next = temp_next;
    ++ list->length;
    
    return 0;
}

#pragma mark remove
/// 按位置删除节点, 注意被删除的节点的内存不会被释放.
/// 参数`deleted_node`可引用被删除的节点, 调用者自行决定是否释放其内存.
int remove_node_at(LListPt list, size_t index, LNodePt *deleted_node) {
    if (!list || !list->head || list->length == 0 || index > list->length - 1) return -1;
    
    LNodePt target_node = list->head;
    long counter = -1;
    LNodePt target_node_prev = NULL;
    while (target_node) {
        ++ counter;
        if (counter == index) break;
        target_node = target_node->p_next;
        target_node_prev = target_node;
    }
    
    if (target_node_prev) {
        target_node_prev->p_next = target_node->p_next;
    } else {
        list->head = NULL;
    }
    -- list->length;
    if (deleted_node) *deleted_node = target_node;
    
    return 0;
}

/// 以平均时间复杂度O(1)删除指定节点, 注意被删除的节点的内存不会被释放
/// (参数`deleted_node`可引用被删除的节点, 调用者自行决定是否释放其内存):
/// 方法是把待删除节点后继的内容拷贝到待删除节点中(实际上删除的是待删除节点的下一个节点);
/// 在有多个节点, 且删除的是尾节点时, 这个小技巧就不管用了,
/// 此时调用remove_node_at(...)函数, 以O(n)时间复杂度删除尾节点;
/// 注意, 考虑到效率, 此函数不检查target_node引用的节点是否在list内, 由调用者负责;
int remove_node(LListPt list, LNodePt target_node, LNodePt *deleted_node) {
    if (!list || !list->head || list->length == 0 || !target_node) return -1;
    
    if (list->length == 1) { // 删除的是头结点
        list->head = NULL;
        if (deleted_node) *deleted_node = target_node;
    } else if (target_node->p_next == NULL) { // 删除的是尾节点
        return remove_node_at(list, list->length - 1, deleted_node);
    } else {
        target_node->value = target_node->p_next->value;
        target_node->p_next = target_node->p_next->p_next;
        if (deleted_node) *deleted_node = target_node->p_next;
    }
    return 0;
}

#pragma other
/// 以O(n)时间复杂度、O(1)空间复杂度反转链表
int linked_list_reverse(LListPt list) {
    if (!list || !list->head || list->length < 2) return -1;
    
    LNodePt current_list_head  = list->head;
    LNodePt reversed_list_head = NULL;
    while (current_list_head != NULL) {
        LNodePt temp = current_list_head->p_next;
        // "箭头反转"
        current_list_head->p_next = reversed_list_head;
        // 指针迭代
        reversed_list_head = current_list_head;
        current_list_head  = temp;
    }
    // 修改链表的头结点为反转后链表的起始节点
    list->head = reversed_list_head;
    return 0;
}

// 1, 2, 3, 4, 5
//       👆    👆
/// 一次遍历内, 求链表倒数第K个节点(K从1开始计数)。
/// 有两种方法: 1.倒数第k个节点(为了符合人的习惯, k从1开始计数), 相当于第length-k个节点(从0开始计数);
/// 2.对于没有length字段的链表, 可用两个异步指针, 使它们的距离保持k-1,
/// 当步调快的指针到达末尾时, 步调慢的指针指向的节点自然就是整个链表的倒数第k个节点了;
/// 此处为了练习, 先写下"异步指针"代码后, 再用最直接的方法1;
int linked_list_the_last_Kth_node(LListPt list, size_t k, LNodePt *target_node) {
    if (!list || !list->head || list->length == 0) return -1;
    if (k > list->length || k == 0) return -2;
    if (!target_node) return -3;
    
    LNodePt faster_pt = list->head;
    LNodePt slower_pt = NULL;
    size_t step_count = 0;
    while (faster_pt != NULL) {
        faster_pt = faster_pt->p_next;
        if (step_count == k-1) slower_pt = list->head;
        // 注意此处须判断快步调指针是否为空, 为空说明达到了链表尾端, 此时不应该再迭代慢步调指针了.
        if (slower_pt && faster_pt) slower_pt = slower_pt->p_next;
        ++ step_count;
    }
    *target_node = slower_pt;
    return 0;
}

/// 合并两个有序链表, 由调用者负责保证它们的排序类型相同(同时升序或降序);
/// 不会修改原来的链表, 合并后链表中的节点都已从原始链表拷贝;
int linked_list_merge_two_sorted_list(LListPt first, LListPt second, bool is_ascend, bool (* is_left_smaller)(LNodePt, LNodePt), LListPt *output) {
    if (!output) return -3;
    if (!first || !first->head || first->length == 0) {
        *output = second;
        return -1;
    }
    if (!second || !second->head || second->length == 0) {
        *output = first;
        return -2;
    }
    
    LListPt merged_list = linked_list_init();
    if (!merged_list) return -4;
    
    int state = 0;
    LNodePt merged_list_last_node = merged_list->head;
    LNodePt ft_node = first->head;
    LNodePt sd_node = second->head;
    while (ft_node != NULL && sd_node != NULL ) {
        LNodePt appending_node = NULL;
        if (is_ascend) {
            if (is_left_smaller(ft_node, sd_node)) {
                appending_node = ft_node;
            } else {
                appending_node = sd_node;
            }
        } else {
            if (is_left_smaller(ft_node, sd_node)) {
                appending_node = sd_node;
            } else {
                appending_node = ft_node;
            }
        }
        // 拷贝一份节点
        LNodePt copyed_node = (LNodePt)malloc(sizeof(LinkedListNode));
        if (!copyed_node) return -5;
        copyed_node->value = appending_node->value;
        
        /// 此处不宜用每次都是O(n)时间复杂度的append_node函数
        //                append_node(merged_list, ft_node);
        if (!merged_list_last_node) {
            state = append_node(merged_list, copyed_node);
        } else {
            state = insert_node_after(merged_list, merged_list_last_node, copyed_node);
        }
        if (state != 0) return state;
        
        if (appending_node == ft_node) {
            ft_node = ft_node->p_next;
        } else {
            sd_node = sd_node->p_next;
        }
        
        merged_list_last_node = copyed_node;
    }
    
    // 链接剩余的节点, 注意到剩余的节点一定全部>=(或<=)merged_list尾节点
    LNodePt remaining_list_head = ft_node ? ft_node : sd_node;
    while (remaining_list_head != NULL) {
        // ***保留第一份代码(未拷贝节点)20180201***
        // insert_node_after函数会修改被添加节点的p_next指针, 此处要提前保存;
//        LNodePt next = ft_node->p_next;
//        insert_node_after(merged_list, merged_list_last_node, ft_node);
//        merged_list_last_node = ft_node;
//        ft_node->p_next = next;
        
        // 拷贝一份节点
        LNodePt copyed_node = (LNodePt)malloc(sizeof(LinkedListNode));
        if (!copyed_node) return -5;
        copyed_node->value = remaining_list_head->value;
        state = insert_node_after(merged_list, merged_list_last_node, copyed_node);
        if (state != 0) return state;
        merged_list_last_node = copyed_node;
        remaining_list_head = remaining_list_head->p_next;
    }
    
    *output = merged_list;
    return 0;
}

#pragma mark -
bool node_is_left_smaller(LNodePt left, LNodePt right) {
    return left->value < right->value;
}

void test_linked_list() {
    LListPt list = linked_list_init();
    for (int i = 0; i < 5; i ++) {
        LNodePt new_node = (LNodePt)malloc(sizeof(LinkedListNode));
        new_node->value = i + 1;
        new_node->p_next = NULL;
        append_node(list, new_node);
    }
    linked_list_print(list);
    
    LNodePt target_node = NULL;
    int state = linked_list_the_last_Kth_node(list, 0, &target_node);
    if (state == 0) {
        printf("%d\n", target_node->value);
    } else {
        printf("error code = %d\n", state);
    }
    
    LListPt list2 = linked_list_init();
    for (int i = 2; i < 7; i ++) {
        LNodePt new_node = (LNodePt)malloc(sizeof(LinkedListNode));
        new_node->value = i + 1;
        new_node->p_next = NULL;
        append_node(list2, new_node);
    }
    linked_list_print(list2);
    
    LNodePt new_node = (LNodePt)malloc(sizeof(LinkedListNode));
    new_node->value = 0;
    new_node->p_next = NULL;
    insert_node_at(list2, new_node, 0);
    
    LNodePt new_node1 = (LNodePt)malloc(sizeof(LinkedListNode));
    new_node1->value = -1;
    new_node1->p_next = NULL;
    insert_node_at(list2, new_node1, 0);
    
    LNodePt new_node2 = (LNodePt)malloc(sizeof(LinkedListNode));
    new_node2->value = 10;
    new_node2->p_next = NULL;
    append_node(list2, new_node2);
    
    LListPt merged_list = NULL;
    linked_list_merge_two_sorted_list(list, list2, true, node_is_left_smaller, &merged_list);
    linked_list_print(merged_list);
}

