//
//  main.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/1/29.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "MinValueOfRotatedSortedArray.hpp"
#include "PartitionApplication.hpp"
#include "AboutLinkedList.hpp"
#include "AboutBinaryTree.hpp"
#include "AboutString.hpp"
#include "AboutPermutation.hpp"
#include <string.h>
#include "AboutArray.hpp"
#include "AboutGraph.hpp"
#include "AboutBitOperation.hpp"

using namespace std;

void test_multimap() {
    multimap<int,int> container;
    
    container.insert(pair<int,int>(1,11));
    container.insert(pair<int,int>(1,12));
    container.insert(pair<int,int>(1,13));
    container.insert(pair<int,int>(2,21));
    container.insert(pair<int,int>(2,22));
    container.insert(pair<int,int>(3,31));
    container.insert(pair<int,int>(3,32));
    container.insert(pair<int,int>(3,33));
    container.insert(pair<int,int>(3,34));
    container.insert(pair<int,int>(3,35));
    container.insert(pair<int,int>(3,36));
    container.insert(pair<int,int>(3,37));
    container.insert(pair<int,int>(3,38));
    
    // 遍历一个multimap
    multimap<int,int>::iterator p_map;
    pair<multimap<int,int>::iterator, multimap<int,int>::iterator> ret;
    for(p_map = container.begin() ; p_map != container.end();)
    {
        cout<<p_map->first<<" => ";
        ret = container.equal_range(p_map->first);
        for(p_map = ret.first; p_map != ret.second; ++p_map)
            cout << (*p_map).second << "  ";
        cout<<endl;
    }
    
    // 测试multimap以某个键删除时候的情况;
    // 发现不会一次性删除所有key相同的pair, 而是按插入的顺序删除最前面的那个。
    while ( (p_map = container.find(3)) != container.end() ) {
        debug_log("%d", p_map->second);
        container.erase(p_map);
    }
    
    printf("\n");
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
//    test_min_value_of_rotated_sorted_array();
//    test_linked_list();
//    test_the_Kth_large_algorithm();
//    test_binary_tree();
    
//    test_merge_two_sorted_array_without_temp_memory();
//    test_multimap();
//    test_DALGraph_topological_sort();
    
    double result = my_power(2, 31, NULL);
    debug_log("%lf\n", result);
    
    return 0;
}

