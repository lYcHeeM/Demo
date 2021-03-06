//
//  AboutBinaryTree.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/2/2.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef AboutBinaryTree_hpp
#define AboutBinaryTree_hpp

// 二叉树相关

#include <stdio.h>
#include <iostream>
#include "common.hpp"

struct BinaryTreeNode {
    int value = 0;
    BinaryTreeNode *p_left = NULL;
    BinaryTreeNode *p_right = NULL;
};
/// 二叉树节点指针
typedef BinaryTreeNode * BTNodePt;

/// 计算tree2是否tree1的子树
int binary_tree_has_subtree_recursively(BTNodePt tree1, BTNodePt tree2, bool *result);
/// 求一颗二叉树的镜像
int binary_tree_mirror_recursively(BTNodePt tree);

/// 由前序遍历序列和中序遍历序列构造一颗二叉树
int binary_tree_construct_according_pre_and_in_order_sequence(int *pre_order_sequence, int *in_order_sequence, size_t length, BTNodePt *result);

#pragma mark - Traversal
/// 先序遍历二叉树, 递归方式;
int binary_tree_traversal_preorder_recursively(BTNodePt tree, void (* visit)(BTNodePt));
/// 先序遍历二叉树, 循环方式;
int binary_tree_traversal_preorder(BTNodePt tree, void (* visit)(BTNodePt));

/// 中序遍历二叉树, 递归方式;
int binary_tree_traversal_inorder_recursively(BTNodePt tree, void (* visit)(BTNodePt));
/// 中序遍历二叉树, 循环方式;
int binary_tree_traversal_inorder(BTNodePt tree, void (* visit)(BTNodePt));

/// 后序遍历二叉树, 递归方式;
int binary_tree_traversal_lastorder_recursively(BTNodePt tree, void (* visit)(BTNodePt));
/// 后序遍历二叉树, 循环方式;
int binary_tree_traversal_lastorder(BTNodePt tree, void (* visit)(BTNodePt));

/// 打印一颗二叉树的所有路径
int binary_tree_print_all_paths(BTNodePt tree);

/// 求一颗二叉树的深度，思路同后续遍历，即先求左右子树的深度，
/// 把其中较大者加一即为当前根节点所引用子树的深度
size_t binary_tree_deepth_recursively(BTNodePt tree);

/// 判断一个二叉树是否平衡
bool binary_tree_balance(BTNodePt tree);

#pragma mark - BST
/// 用一个不含相等元素的线性序列创建一颗二叉搜索树(非平衡)，
/// 简便起见，暂不考虑相等元素的情况（比较复杂，可能涉及到树的删除操作）;
/// - 由于每次把剩余序列中的一个元素插入到已构建好的二叉搜索树中，所需平均时间为O(logk)，
/// k为当前二叉搜索树的元素个数，则构建含n个元素的二叉搜索树的总平均时间复杂度为：
/// <O(log0)> + O(log1) + O(log2) + O(log3) + ... + O(log(n-1)) =
/// O(log1 + log2 + ... + log(n-1)) = O(log1*2*...*(n-1)) = O(log(n-1)!) 约等于
/// O(log(n-1)^2) = O(2log(n-1)) -> O(logn);
/// - 当二叉搜索树的每个节点都只有左子树或只有右子树时，它将退化到线性表，此时达到最差时间复杂度，为：
/// O(1) + O(2) + ... + O(n-1) = O(n^2/2) -> O(n^2)
int binary_search_tree_create_by_sequence(const int *sequence, size_t length, BTNodePt *tree);
/// 二叉搜索树查找, position返回最后遍历节点的地址(意味着, 搜索成功时, position指向目标节点);
bool binary_search_tree_search(BTNodePt tree, int target_value, BTNodePt *position);
/// 在一颗二叉搜索树中插入一个值为`value`的元素(节点，新的节点申请的内存将放入堆区);
/// 可见在绝大多数数据结构中，插入一个元素都需要先查找到合适的插入位置;
int binary_search_tree_insert(BTNodePt *tree, int value);
/// 把一颗二叉搜索树转换成一个有序(升序)的双向链表;
/// 用二叉树节点中的p_right指向链表中的下一个节点, p_left指向上一个节点;
/// list_head参数为转换后链表的头结点, list_tail为尾节点;
int binary_search_tree_convert_to_bi_linkedlist(BTNodePt tree, BTNodePt *list_head, BTNodePt *list_tail);

#pragma mark - Test
void test_binary_tree();

#endif /* AboutBinaryTree_hpp */
