//
//  HeapSort.cpp
//  Sort
//
//  Created by luozhijun on 2018/4/3.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "HeapSort.hpp"
#include <cassert>

bool is_left_smaller(const void *p_left, const void *p_right) {
    if (!p_left && !p_right)
        return true;
    else if (!p_left || !p_right)
        return false;
    
    int left_value  = *((int *)p_left);
    int right_value = *((int *)p_right);
    return left_value < right_value;
}

void __adjust_heap_in_array(int *array, size_t cur_node_index, size_t length, bool greater_heap, bool (*is_left_smaller)(const void *, const void *));
int heap_sort(int *array, size_t length, bool ascending) {
    if (!array || length == 0) return -1;
    // 初始化大顶堆
    for (long i = long(length/2) - 1; i >= 0; -- i) {
        __adjust_heap_in_array(array, i, length, ascending, is_left_smaller);
    }

    for (long i = long(length) - 1; i > 0; -- i) {
        // 由于大顶堆的头元素最大，故把最大值和当前带排序子序列的尾值交换，使最大值跑到子序列的
        // 末尾，这样便可一步步实现原始序列的升序排序。
        int temp = array[0];
        array[0] = array[i];
        array[i] = temp;
        
        // 使剩余元素依然满足大顶堆性质，从刚刚被交换的节点开始调整
        __adjust_heap_in_array(array, 0, i, ascending, is_left_smaller);
    }
    return 0;
}

/// 调整堆，使其满足大顶堆或小顶堆的性质，可以理解为把cur_node_index指向的节点步步
/// 下沉的过程：若该节点的值和其两个子节点中的任一个发生了交换，则修改cur_node_index的指向，
/// 使其指向被交换的节点（此时可把这个节点看做是新的可能需要步步下层的节点，至此，问题落到解决相同形式的子规模问题上，
/// 显然这可用递归的思想考虑），重复这个过程直到cur_node_index指向的节点的值不需要和子节点的值交换，
/// 或者到达了树的叶子节点为止。
/// @param cur_node_index 当前待调整的节点在array中的位置
/// @param greater_heap 是否大顶堆，否的话则认为是小顶堆
/// @param is_left_smaller 用于比较的谓词
void __adjust_heap_in_array(int *array, size_t cur_node_index, size_t length, bool greater_heap, bool (*is_left_smaller)(const void *, const void *)) {
    if (!array || length <= 1 || !is_left_smaller) return;
    assert(cur_node_index < length);
    
    // 当前待调整节点的值
    int initial_node_value = array[cur_node_index];
    // 从当前待调整节点开始，如果需要的话，一步步把该节点下层至合适的子树
    for (size_t subtree_index = cur_node_index*2 + 1; subtree_index < length; subtree_index = subtree_index*2 + 1) {
        size_t right_subtree_index = subtree_index + 1;
        // 如果有右子树，则判断右子树根节点的值是否比左子树的大(大顶堆情况下)，如果是的话则指向它
        if (right_subtree_index < length) {
            bool left_subtree_maller = is_left_smaller(&array[subtree_index], &array[right_subtree_index]);
            if ( (greater_heap && left_subtree_maller) ||
                (!greater_heap && !left_subtree_maller) ) {
                ++ subtree_index;
            }
        }
        
        // 此处有一个用于优化性能的小技巧，本来每次比较须发生在arrar[cur_node_index]和array[subtree_index]
        // 之间的，但此处可把左右子树的较大值(大顶堆情况下)固定和第一个待调整节点比较，这是考虑到每发生一次交换，
        // 第一个待调整的节点就会下沉一次，一般的想法是通过交换操作实现下层，但正是由于每次都和initial_node_value比较，
        // 才可不需要物理上的交换操作(注意下面只是修改需要调整节点的值，而没有和子树较大值交换)，但逻辑上却可认为发生了"交换"，
        // 因为在下一层相同形式的子规模问题中，与两子树节点较大值比较的正是上一层需要被沉下去节点的值。这个思想和partiton函数
        // 中的"空位置"做法类似，都是逻辑上的形容。
        bool cur_node_smaller = is_left_smaller(&initial_node_value, &array[subtree_index]);
        if ( (greater_heap && cur_node_smaller) ||
             (!greater_heap && !cur_node_smaller) ) {
            array[cur_node_index] = array[subtree_index];
            cur_node_index = subtree_index;
        } else {
            break;
        }
    }
    array[cur_node_index] = initial_node_value;
}
