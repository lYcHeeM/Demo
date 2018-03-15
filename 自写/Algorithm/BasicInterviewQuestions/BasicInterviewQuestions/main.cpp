//
//  main.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/1/29.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include <iostream>
#include <cassert>
#include <unistd.h>
#include "MinValueOfRotatedSortedArray.hpp"
#include "PartitionApplication.hpp"
#include "AboutLinkedList.hpp"
#include <set>
#include "AboutBinaryTree.hpp"
#include "AboutString.hpp"
#include "AboutPermutation.hpp"
#include <string.h>

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

void test_the_Kth_large_algorithm() {
    for (int i = 0; i < 99999; ++ i) {
        int data[] = {4,5,6,7,8,9,10,11,0,1,2};
        int result = -1;
        size_t length = sizeof(data)/sizeof(int);
        int ret = the_Kth_large_element_in(data, length, 6, &result);
        print_int_array(data, length);
        printf("return state = %d\n", ret);
        printf("result = %d\n", result);
        printf("==========================\n");
        printf("i = %d\n", i);
        assert(result == 6);
        usleep(10000);
    }
//    std::multiset<int> aa;
//    std::greater<> bb;
    
    printf("test_the_Kth_large_algorithm succeed🎉!\n");
}

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

void binary_tree_node_print(BTNodePt node) {
    if (node) {
        printf("%d\t", node->value);
    }
}

void test_binary_tree() {
    BinaryTreeNode n_10;
    n_10.value = 10;
    
    BinaryTreeNode n_2;
    n_2.value = 2;
    
    BinaryTreeNode n_5;
    n_5.value = 5;
    n_5.p_right = &n_10;
    
    BinaryTreeNode n_3;
    n_3.value = 3;
    n_3.p_left = &n_5;
    n_3.p_right = &n_2;
    
    BinaryTreeNode n_minus_1;
    n_minus_1.value = -1;
    
    BinaryTreeNode n_0;
    n_0.value = 0;
    
    BinaryTreeNode n_4;
    n_4.value = 4;
    n_4.p_left = &n_minus_1;
    n_4.p_right = &n_0;
    
    BinaryTreeNode n_1;
    n_1.value = 1;
    n_1.p_left = &n_3;
    n_1.p_right = &n_4;
    
    int state = binary_tree_traversal_preorder(&n_1, binary_tree_node_print);
    printf("\nstate = %d\n", state);
    state = binary_tree_traversal_lastorder(&n_1, binary_tree_node_print);
    printf("\nstate = %d\n", state);
    
    // 重建二叉树
    int pre_order_s[] = {1,    3,    5,    10,    2,    4,    -1,    0};
    int in_order_s[]  = {5,    10,    3,    2,    1,    -1,    4,    0};
    
    BTNodePt result = NULL;
    binary_tree_construct_according_pre_and_in_order_sequence(pre_order_s, in_order_s, sizeof(pre_order_s)/sizeof(pre_order_s[0]), &result);
    binary_tree_traversal_preorder(result, binary_tree_node_print);
    printf("\n");
    binary_tree_traversal_inorder(result, binary_tree_node_print);
    printf("\n");
    
    // 输出所有路径
    binary_tree_print_all_paths(result);
    
    // 创建一颗二叉搜索树
    int seq[] = {8, 5, 13, 3, 4, 7, 9, 11};
    BTNodePt bst = NULL;
    binary_search_tree_create_by_sequence(seq, sizeof(seq)/sizeof(seq[0]), &bst);
    binary_tree_traversal_inorder(bst, binary_tree_node_print);
    printf("\n");
    
    printf("--convert to bi linkedlist--");
    BTNodePt converted_list_head = NULL;
    BTNodePt converted_list_tail = NULL;
    binary_search_tree_convert_to_bi_linkedlist(bst, &converted_list_head, &converted_list_tail);
    BTNodePt p_node = converted_list_head;
    printf("\nAscend(according `p_right`): ");
    while (p_node != NULL) {
        printf("%d   ", p_node->value);
        p_node = p_node->p_right;
    }
    printf("\nDescend(according `p_left`): ");
    p_node = converted_list_tail;
    while (p_node != NULL) {
        printf("%d   ", p_node->value);
        p_node = p_node->p_left;
    }
    printf("\n");
}



int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
//    int data[] = {4,5,6,7,8,9,10,11,0,1,2};
//    int result = -1;
//
//    size_t length = sizeof(data)/sizeof(int);
//    min_value_of_rotated_sorted_array(data, length, &result);
//    printf("%d\n", result);
//
//    int data2[] = {-1, -1, -1, 0, 0, 1, 2, 3, 4, 5, 6};
//    int result2 = -1;
//    binary_search_value_recursively_in(data2, sizeof(data2)/sizeof(int), 1, &result2);
//    printf("%d\n", result2);
    
//    test_linked_list();
//    test_the_Kth_large_algorithm();
//    test_binary_tree();
    
//    int error_code = 0;
//    int number = atoint32("+++++---+2147483648", &error_code);
//    printf("error code: %d\n", error_code);
//    printf("number: %d\n", number);
    
    // 测试代码
    char **result = NULL;
    size_t permutations_count = 0;
    int error_code = string_permutations("ABCD", &result, &permutations_count);
    if (error_code < 0) printf("error code: %d\n", error_code);
    for (size_t i = 1; i <= permutations_count; ++ i) {
        printf("%s    ", result[i-1]);
        if (i % 10 == 0) printf("\n");
    }
    printf("\n");
    return 0;
}

