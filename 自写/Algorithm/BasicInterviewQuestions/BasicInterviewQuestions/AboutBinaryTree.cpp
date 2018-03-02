//
//  AboutBinaryTree.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/2/2.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutBinaryTree.hpp"

BTNodePt binary_tree_node_create(int value) {
    BTNodePt node = (BTNodePt)malloc(sizeof(BinaryTreeNode));
    if (!node) return NULL;
    node->value = value;
    node->p_left = NULL;
    node->p_right = NULL;
    return node;
}

bool doesTree1ContainsTree2_recursively(BTNodePt tree1, BTNodePt tree2) {
    if (!tree1) return false;
    // 此处规定, 如果tree2为空树, 表示tree2是tree1的子树
    if (!tree2) return true;
    
    if (tree1->value != tree2->value)
        return false;
    
    return
    doesTree1ContainsTree2_recursively(tree1->p_left, tree2->p_left) &&
    doesTree1ContainsTree2_recursively(tree1->p_right, tree2->p_right);
}

/// 计算tree2是否tree1的子树
int binary_tree_has_subtree_recursively(BTNodePt tree1, BTNodePt tree2, bool *result) {
    if (!tree1 || !tree2 || !result) return -1;
    
    *result = false;
    
    if (tree1->value == tree2->value)
        *result = doesTree1ContainsTree2_recursively(tree1, tree2);
    if (!(*result))
        binary_tree_has_subtree_recursively(tree1->p_left, tree2, result);
    if (!(*result))
        binary_tree_has_subtree_recursively(tree1->p_right, tree2, result);
    
    return 0;
}

/// 求一颗二叉树的镜像
int binary_tree_mirror_recursively(BTNodePt tree) {
    if (!tree) return -1;
    if (!tree->p_left && !tree->p_right) return -2;
    
    // 交换根节点的左右子树
    BTNodePt temp_left_subtree = tree->p_left;
    tree->p_left = tree->p_right;
    tree->p_right = temp_left_subtree;
    
    // 对左右子树应用同样的操作
    binary_tree_mirror_recursively(tree->p_left);
    binary_tree_mirror_recursively(tree->p_right);
    
    return 0;
}


/// 求一颗二叉树的镜像, 循环方式
int binary_tree_mirror(BTNodePt tree) {
    if (!tree) return -1;
    if (!tree->p_left && !tree->p_right) return -2;
    
    // 交换根节点的左右子树
    BTNodePt temp_left_subtree = tree->p_left;
    tree->p_left = tree->p_right;
    tree->p_right = temp_left_subtree;
    
    BTNodePt left_subtree = tree->p_left;
    while (left_subtree->p_left || left_subtree->p_right) {
        BTNodePt temp = left_subtree->p_left;
        left_subtree->p_left = left_subtree->p_right;
        left_subtree->p_right = temp;
        left_subtree = left_subtree->p_left;
    }
    
    BTNodePt right_subtree = tree->p_right;
    while (right_subtree->p_left || right_subtree->p_right ) {
        BTNodePt temp = right_subtree->p_left;
        right_subtree->p_left = right_subtree->p_right;
        right_subtree->p_right = temp;
        right_subtree = right_subtree->p_right;
    }
    
    return 0;
}

/// 由前序遍历序列和中序遍历序列构造一颗二叉树;
/// 可见解决很多问题, 都可以先具象一个状态出来, 再看这个状态与前驱和后继的关系,
/// 最后处理边界值和异常;
int binary_tree_construct_according_pre_and_in_order_sequence(int *pre_order_sequence, int *in_order_sequence, size_t length, BTNodePt *result) {
    if (!pre_order_sequence || !in_order_sequence || length == 0 || !result) return -1;
    
    // 注意到先序遍历序列中的首值即为根节点的值
    int root_value = pre_order_sequence[0];
    // 在中序遍历序列中找到根节点的值
    size_t root_value_index_of_inorder_sequence = 0;
    for (; root_value_index_of_inorder_sequence < length; ++ root_value_index_of_inorder_sequence) {
        if (in_order_sequence[root_value_index_of_inorder_sequence] == root_value) break;
    }
    if (root_value_index_of_inorder_sequence >= length) return -2; // 输入有误
    
    size_t left_subtree_len  = root_value_index_of_inorder_sequence;
    size_t right_subtree_len = length - root_value_index_of_inorder_sequence - 1;
    
    // 创建根节点
    BTNodePt root = (BTNodePt)malloc(sizeof(BinaryTreeNode));
    root->value = root_value;
    // 实践发现, 分配的堆内存是不会被初始化的, 此处必须手动置空;
    root->p_left = root->p_right = NULL;
    if (!root) return -3; // memorry not enough
    
    // 构建左子树
    binary_tree_construct_according_pre_and_in_order_sequence(pre_order_sequence + 1, in_order_sequence, left_subtree_len, &root->p_left);
    // 构建右子树
    binary_tree_construct_according_pre_and_in_order_sequence(pre_order_sequence + 1 + left_subtree_len, in_order_sequence + root_value_index_of_inorder_sequence + 1, right_subtree_len, &root->p_right);
    
    *result = root;
    return 0;
}


#pragma mark -
#include <stack>

/// 先序遍历二叉树, 递归方式;
int binary_tree_traversal_preorder_recursively(BTNodePt tree, void (* visit)(BTNodePt)) {
    if (!tree) return -1;
    if (visit) visit(tree);
    binary_tree_traversal_preorder_recursively(tree->p_left, visit);
    binary_tree_traversal_preorder_recursively(tree->p_right, visit);
    return 0;
}

/// 先序遍历二叉树, 循环方式;
int binary_tree_traversal_preorder(BTNodePt tree, void (* visit)(BTNodePt)) {
    if (!tree) return -1;
    std::stack<BTNodePt> stack;
    while (tree || !stack.empty()) {
        if (visit) visit(tree);
        stack.push(tree);
        tree = tree->p_left;
        while (!tree && !stack.empty()) {
            BTNodePt parent = stack.top();
            // pop的时机选得好, 可以省去很多不必要的判断,
            // 比如下面被屏蔽的那份代码, 就需要用额外的变量来区分当前树是否已完全遍历
            stack.pop();
            tree = parent->p_right;
        }
    }
    return 0;
    
#if 0 // 代码更多但更直观的方法
    if (!tree) return -1;
    
    std::stack<BTNodePt> stack;
    // 标识当前树是否已完全遍历
    bool current_tree_has_visited = false;
    do {
        if (tree) {
            if (!current_tree_has_visited) {
                if (visit) visit(tree);
                stack.push(tree);
                tree = tree->p_left;
            } else {
                BTNodePt popped_tree = stack.top();
                stack.pop();
                if (stack.empty()) break;
                BTNodePt parent = stack.top();
                // 从左子树返回上一层, 则上一层的右子树还未遍历
                // 而如果右子树返回上一层, 说明上一层节点代表的整棵树都已经遍历过了;
                if (parent->p_left == popped_tree) {
                    tree = parent->p_right;
                    current_tree_has_visited = false;
                }
            }
        } else {
            BTNodePt parent = stack.top();
            tree = parent->p_right;
            if (!tree) {
                tree = parent;
                // 从右子树返回上一层, 说明上一层节点代表的整棵树都已经遍历过了;
                current_tree_has_visited = true;
            } else {
                current_tree_has_visited = false;
            }
        }
    } while (!stack.empty());

    return 0;
#endif
}


/// 中序遍历二叉树, 递归方式;
int binary_tree_traversal_inorder_recursively(BTNodePt tree, void (* visit)(BTNodePt)) {
    if (!tree) return -1;
    binary_tree_traversal_inorder_recursively(tree->p_left, visit);
    if (visit) visit(tree);
    binary_tree_traversal_inorder_recursively(tree->p_right, visit);
    return 0;
}

/// 中序遍历二叉树, 循环方式;
int binary_tree_traversal_inorder(BTNodePt tree, void (* visit)(BTNodePt)) {
    if (!tree) return -1;
    
    std::stack<BTNodePt> stack;
    while (tree || !stack.empty()) {
        if (tree) { // 向左走到底
            stack.push(tree);
            tree = tree->p_left;
        } else {
            BTNodePt top = stack.top();
            if (visit) visit(top);
            stack.pop();
            tree = top->p_right;
        }
    }
    
    return 0;
}

/// 后序遍历二叉树, 递归方式;
int binary_tree_traversal_lastorder_recursively(BTNodePt tree, void (* visit)(BTNodePt)) {
    if (!tree) return -1;
    binary_tree_traversal_lastorder_recursively(tree->p_left, visit);
    binary_tree_traversal_lastorder_recursively(tree->p_right, visit);
    if (visit) visit(tree);
    return 0;
}

/// 后序遍历二叉树, 循环方式;
int binary_tree_traversal_lastorder(BTNodePt tree, void (* visit)(BTNodePt)) {
    if (!tree) { return -1; }
    
    std::stack<BTNodePt> stack;
    // 保存上一颗遍历完全的树, 防止无限重复遍历某棵树的右子树
    BTNodePt last_visited_tree = NULL;
    while (tree || !stack.empty()) {
        if (tree) {
            stack.push(tree);
            tree = tree->p_left;
        } else {
            BTNodePt parent = stack.top();
            if (!parent->p_right || parent->p_right == last_visited_tree) {
                // 右子树为空或上一次遍历完全的树恰好是栈顶树的右子树: 表明栈顶树的左右子树都已遍历完成.
                // 此时打印栈顶树的根节点, 并标识栈顶树为"已完全遍历"(后序遍历最后打印根节点);
                // 注意tree指针依然保持NULL, 是为了令下一次循环继续进入第一个else代码区;
                if (visit) { visit(parent); }
                stack.pop();
                last_visited_tree = parent;
            } else {
                tree = parent->p_right;
            }
        }
    }
    return 0;
    
#if 0 // 改进前的代码
    if (!tree) return -1;
    std::stack<BTNodePt> stack;
    stack.push(tree);
    tree = tree->p_left;
    bool current_tree_has_visited = false;
    while (!stack.empty()) {
        if (tree && !current_tree_has_visited) {
            stack.push(tree);
            tree = tree->p_left;
        } else {
            BTNodePt top = stack.top();
            if (!current_tree_has_visited) {
                tree = top->p_right;
                if (!tree) {
                    // 以下代码和下一个else块中的代码一致
                    stack.pop();
                    if (visit) visit(top);
                    if (stack.empty()) break;
                    BTNodePt popped_tree = top;
                    top = stack.top();
                    current_tree_has_visited = popped_tree == top->p_right;
                    if (!current_tree_has_visited) {
                        tree = top->p_right;
                    }
                }
            } else {
                stack.pop();
                if (visit) visit(top);
                if (stack.empty()) break;
                BTNodePt popped_tree = top;
                top = stack.top();
                current_tree_has_visited = popped_tree == top->p_right;
                if (!current_tree_has_visited) {
                    tree = top->p_right;
                }
            }
        }
    }
    return 0;
#endif
}

#pragma mark -
#include <vector>
/// 打印一颗二叉树的所有路径
int binary_tree_print_all_paths(BTNodePt tree) {
    if (!tree) return -1;
    printf("\n=====All paths=====\n");
    // 因打印路径要从头开始遍历, 而std::vector既可以当作栈使用,
    // 也可以当作普通的数组使用, 故此处不用栈保存遍历节点;
    std::vector<BTNodePt> stack;
    BTNodePt last_visited_tree = NULL;
    while (tree || stack.size() > 0) {
        if (tree) { // 向左走到底
            stack.push_back(tree);
            tree = tree->p_left;
        } else {
            BTNodePt parent = *(stack.end() - 1);
            bool should_pop_back = false;
            if (!parent->p_left && !parent->p_right) { // 到达叶子节点
                std::vector<BTNodePt>::iterator iter = stack.begin();
                for (; iter != stack.end(); ++ iter) {
                    BTNodePt node = *iter;
                    printf("%d\t", node->value);
                }
                printf("\n");
                should_pop_back = true;
            }
            if (!parent->p_right || last_visited_tree == parent->p_right) {
                // 表示parent树已经遍历完全, 可从缓存中移除
                last_visited_tree = parent;
                should_pop_back = true;
            } else {
                tree = parent->p_right;
            }
            if (should_pop_back) {
                stack.pop_back();
                // 因while循环的条件比较宽泛, 在pop时, 必须检查容器是否为空, 否则循环将永远保持
                if (!stack.size()) break;
            }
        }
    }
    printf("\n=====End all paths=====\n");
    return 0;
}

#pragma mark - BST
int binary_search_tree_insert(BTNodePt *tree, int value);
/// 用一个不含相等元素的线性序列创建一颗二叉搜索树(非平衡)
int binary_search_tree_create_by_sequence(const int *sequence, size_t length, BTNodePt *tree) {
    if (!sequence || length == 0 || !tree) return -1;
    for(int i = 0; i < length; ++ i)
        binary_search_tree_insert(tree, sequence[i]);
    return 0;
}

bool binary_search_tree_search(BTNodePt tree, int target_value, BTNodePt *position) {
    if (position && tree) *position = tree;
    if (!tree) return false;
    if (tree->value == target_value) return true;
    
    if (tree->value > target_value)
        return binary_search_tree_search(tree->p_left,  target_value, position);
    else
        return binary_search_tree_search(tree->p_right, target_value, position);
}

int binary_search_tree_insert(BTNodePt *tree, int value) {
#if 0 // 未写binary_search_tree_search函数之前的代码, 包含了查找
    if (!(*tree)) {
        BTNodePt node = binary_tree_node_create(value);
        if (!node) return -1;
        *tree = node;
        return 0;
    }
    
    if ((*tree)->value > value) {
        if (!(*tree)->p_left) {
            BTNodePt node = binary_tree_node_create(value);
            if (!node) return -1;
            (*tree)->p_left = node;
        } else {
            binary_search_tree_insert(&((*tree)->p_left), value);
        }
    }
    else {
        if (!(*tree)->p_right) {
            BTNodePt node = binary_tree_node_create(value);
            if (!node) return -1;
            (*tree)->p_right = node;
        } else {
            binary_search_tree_insert(&((*tree)->p_right), value);
        }
    }
    return 0;
#endif
    
    BTNodePt position = NULL;
    if (!binary_search_tree_search(*tree, value, &position)) {
        BTNodePt node = binary_tree_node_create(value);
        if (!node) return -1;
        
        if (!(*tree)) *tree = node; // 初态: 树为空的时候
        else if (position->value > value)
            position->p_left = node;
        else
            position->p_right = node;
    }
    return 0;
}

void __binary_search_tree_convert_to_bi_linkedlist(BTNodePt tree, BTNodePt *list_head, BTNodePt *list_tail, BTNodePt *last_visited_node);
/// 把一颗二叉搜索树转换成一个有序(升序)的双向链表;
/// 用二叉树节点中的p_right指向链表中的下一个节点, p_left指向上一个节点;
/// list_head参数为转换后链表的头结点, list_tail为尾节点;
int binary_search_tree_convert_to_bi_linkedlist(BTNodePt tree, BTNodePt *list_head, BTNodePt *list_tail) {
    if (!tree || !list_head || !list_tail) return -1;
    BTNodePt last_visited_node = NULL;
    __binary_search_tree_convert_to_bi_linkedlist(tree, list_head, list_tail, &last_visited_node);
    return 0;
}

/// last_visited_node: 上一次访问的节点, 也为当前转换得到的链表中的尾节点;
void __binary_search_tree_convert_to_bi_linkedlist(BTNodePt tree, BTNodePt *list_head, BTNodePt *list_tail, BTNodePt *last_visited_node) {
    if (!last_visited_node) return;
    
    if (tree->p_left)
        __binary_search_tree_convert_to_bi_linkedlist(tree->p_left, list_head, list_tail, last_visited_node);
    
    if (!(*last_visited_node)) {
        *list_head = tree;
    } else {
        (*last_visited_node)->p_right = tree;
        tree->p_left = *last_visited_node;
    }
    *last_visited_node = tree;
    *list_tail = tree;
    
    if (tree->p_right)
        __binary_search_tree_convert_to_bi_linkedlist(tree->p_right, list_head, list_tail, last_visited_node);
}

