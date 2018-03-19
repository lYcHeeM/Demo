//
//  AboutGraph.cpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/2/11.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#include "AboutGraph.hpp"
#include "common.hpp"
#include <queue>

VertexPt ALGraph_vertex_init() {
    VertexPt ret = (VertexPt)malloc(sizeof(Vertex));
    if (!ret) return NULL;
    ret->firstarc = NULL;
    ret->indegree = 0;
    ret->outdegree = 0;
    return ret;
}

ArcPt ALGraph_arc_init() {
    ArcPt ret = (ArcPt)malloc(sizeof(Arc));
    if (!ret) return NULL;
    ret->head_vertex_index = 0;
    ret->tail_vertex_index = 0;
    ret->nextarc = NULL;
    return ret;
}

/// 构造一个以邻接表为存储结构的有向图;
/// 由输入输出法分析容易得知，时间复杂度为O(n+e);
/// @param arcs 弧节点用二元组 <弧尾顶点在顶点序列中的位置, 弧头顶点在顶点序列中的位置> 来表示；
int DALGraph_create(int *vertexes, size_t vertexnum, const std::multimap<int ,int> arcs, ALGraphPt *result) {
    if (!vertexes || vertexnum == 0 || !result) return -1;
    
    // 创建有向图结构
    ALGraphPt graph = (ALGraphPt)malloc(sizeof(ALGraph));
    if (!graph) return -2;
    graph->vertexnum = (unsigned int)vertexnum;
    graph->arcnum = (unsigned int)arcs.size();
    debug_log("%d", graph->arcnum);
    
    // 创建所有顶点, O(n)
    graph->vertexes = (VertexPt *)malloc(sizeof(VertexPt) * vertexnum);
    if (!graph->vertexes) return -2;
    for (int i = 0; i < vertexnum; ++ i) {
        VertexPt vertex = ALGraph_vertex_init();
        if (!vertex) return -2;
        vertex->value = vertexes[i];
        vertex->index = i;
        graph->vertexes[i] = vertex;
    }
    
    // 链接所有弧节点, O(n+e)
    // 因为要动态删除使用过的弧，此处用拷贝构造函数复制一份输入
    std::multimap<int, int> arcs_copy = arcs;
    for (int i = 0; i < vertexnum; ++ i) {
        VertexPt vertex = graph->vertexes[i];
        
        // 以序号i为key，创建以i为弧尾的所有弧节点，并链接到第i个顶点后面
        std::multimap<int, int>::iterator it;
        ArcPt last_linked_arc = NULL;
        while ( (it = arcs_copy.find(i)) != arcs_copy.end()) {
            ArcPt arc = ALGraph_arc_init();
            if (!arc) return -2;
            // 弧尾顶点的序号
            arc->tail_vertex_index = i;
            // 弧头顶点的序号
            arc->head_vertex_index = it->second;
            
            // 把弧节点链接到顶点后面
            if (!last_linked_arc) {
                vertex->firstarc = arc;
            } else {
                last_linked_arc->nextarc = arc;
            }
            last_linked_arc = arc;
            
            // 当前顶点的出度加1
            ++ vertex->outdegree;
            // 对面顶点(弧头顶点)的入度加1
            ++ graph->vertexes[it->second]->indegree;
            
            // STL multimap不会一次性删除所有key相同的pair,
            // 而是按插入的顺序删除最前面的那个，所以这么做没有问题。
            arcs_copy.erase(it);
        }
    }
    *result = graph;
    return 0;
}

void __ALGraph_dfs_on_vertex(ALGraphPt graph, VertexPt start, bool *visitedflags, void (*visit)(VertexPt), std::vector<int> &dfs_exit_vertex_orders);
/// 深度优先搜索，可指定搜索的起始顶点
/// @param start 搜索的起始顶点，可为空
/// @param dfs_exit_vertex_orders 由于是递归遍历，此参数记录函数栈的退出先后顺序对应的顶点序号(在顶点序列中的位置)，
/// 如果是有向无环图，调用者可以此序列来求出拓扑有序序列。因为无环，所以最先退出DFS函数的顶点即为出度为零的顶点，
/// 也就是拓扑有序序列中的最后一个顶点。由此，按退出DFS函数的先后顺序记录下的顶点序列即为逆向的拓扑有序序列。
/// 时间复杂度为O(n+e);
int ALGraph_dfs(ALGraphPt graph, VertexPt start, void (*visit)(VertexPt), std::vector<int> &dfs_exit_vertex_orders) {
    if (!graph || !graph->vertexes || graph->vertexnum == 0) return -1;
    
    bool visited[graph->vertexnum];
    for (int i = 0; i < graph->vertexnum; ++ i)
        visited[i] = false;
    
    int start_index = 0;
    if (start) start_index = start->index;
    
    for (int i = start_index; i < graph->vertexnum; ++ i)
        if (!visited[i])
            __ALGraph_dfs_on_vertex(graph, graph->vertexes[i], visited, visit, dfs_exit_vertex_orders);
    for (int i = 0; i < start_index; ++ i)
        if (!visited[i])
            __ALGraph_dfs_on_vertex(graph, graph->vertexes[i], visited, visit, dfs_exit_vertex_orders);
    
    return 0;
}
/// 只对某一个顶点进行深度优先搜索，若遇到出度为零的顶点则停止，函数返回
void __ALGraph_dfs_on_vertex(ALGraphPt graph, VertexPt start, bool *visitedflags, void (*visit)(VertexPt), std::vector<int> &dfs_exit_vertex_orders) {
    // 访问当前顶点，并把对应标志位置为true
    if (visit) visit(start);
    visitedflags[start->index] = true;
    
    // 遍历所有邻接点
    for (ArcPt arc = start->firstarc; arc != NULL; arc = arc->nextarc) {
        VertexPt adjacency_vertex = graph->vertexes[arc->head_vertex_index];
        if (!visitedflags[adjacency_vertex->index])
            __ALGraph_dfs_on_vertex(graph, adjacency_vertex, visitedflags, visit, dfs_exit_vertex_orders);
    }
    
    dfs_exit_vertex_orders.push_back(start->value);
}

void __ALGraph_bfs_on_vertex(ALGraphPt graph, VertexPt start, bool *visitedflags, void (*visit)(VertexPt));
/// 广度优先搜索；
/// 时间复杂度为O(n+e);
int ALGraph_bfs(ALGraphPt graph, VertexPt start, void (*visit)(VertexPt)) {
    if (!graph || !graph->vertexes || graph->vertexnum == 0) return -1;
    
    bool visited[graph->vertexnum];
    for (int i = 0; i < graph->vertexnum; ++ i)
        visited[i] = false;
    
    if (!start) start = graph->vertexes[0];
    
    for (int i = start->index; i < graph->vertexnum; ++ i)
        __ALGraph_bfs_on_vertex(graph, graph->vertexes[i], visited, visit);
    for (int i = 0; i < start->index; ++ i)
        __ALGraph_bfs_on_vertex(graph, graph->vertexes[i], visited, visit);
    
    return 0;
}
/// 只对某一个顶点进行广度优先搜索，若遇到出度为零的顶点则停止，函数返回
void __ALGraph_bfs_on_vertex(ALGraphPt graph, VertexPt start, bool *visitedflags, void (*visit)(VertexPt)) {
    if (visitedflags[start->index]) return;
    
    std::queue<VertexPt> queue;
    queue.push(start);
    if (visit) visit(start);
    visitedflags[start->index] = true;
    
    while (!queue.empty()) {
        VertexPt current = queue.front();
        queue.pop();
        
        for (ArcPt arc = current->firstarc; arc != NULL; arc = arc->nextarc) {
            VertexPt adjacency_vertex = graph->vertexes[arc->head_vertex_index];
            if (!visitedflags[adjacency_vertex->index]) {
                if (visit) visit(adjacency_vertex);
                visitedflags[adjacency_vertex->index] = true;
                queue.push(adjacency_vertex);
            }
        }
    }
}

/// 对有向图进行拓扑排序；时间复杂度为O(n+e);
/// @param result 拓扑有序序列
/// @param result_len 拓扑有序序列的长度
/// @param has_loop 有向图是否有环
int DALGraph_topological_sort(ALGraphPt graph, int **result, size_t *result_len, bool *has_loop) {
    if (!graph || !graph->vertexes || graph->vertexnum == 0) return -1;
    
    // 存放所有顶点的入度
    unsigned int indegrees[graph->vertexnum];
    // 创建辅助空间，用于存放所有入度为零的顶点，避免每次更新剩余未访问顶点的入度之后，
    // 又要再查找一遍以获取第一个入度为零的顶点。这是典型的双管齐下、空间换时间的做法。
    //  (之所以说是双管齐下，是在更新剩余顶点入度的同时，即可得知哪个顶点的入度变为0，
    // 此时马上记录下来，可以避免很多麻烦，好处还很多，比如可以用来当作while循环的退出条件)
    std::queue<VertexPt> zero_indegree_vertexes;
    // 把初态下没有前驱(入度为零)的顶点输入辅助空间
    for (int i = 0; i < graph->vertexnum; ++ i) {
        indegrees[i] = graph->vertexes[i]->indegree;
        if (indegrees[i] == 0) zero_indegree_vertexes.push(graph->vertexes[i]);
    }
    
    unsigned int visited_vertexnum = 0;
    int *topological_sorted_seq = (int *)malloc(sizeof(int) * graph->vertexnum);
    if (!topological_sorted_seq) return -2;
    
    while (!zero_indegree_vertexes.empty()) {
        // 从辅助空间弹出入度为零的某个顶点并记录之
        VertexPt current = zero_indegree_vertexes.front();
        zero_indegree_vertexes.pop();
        topological_sorted_seq[visited_vertexnum] = current->value;
        ++ visited_vertexnum;
        
        // 把这个顶点的所有邻接点的入度减1
        ArcPt arc = current->firstarc;
        for (; arc != NULL; arc = arc->nextarc) {
            // 获取当前弧节点中表示弧头顶点在顶点集合中的序号，因一条弧引用了两个节点，
            // 除了当前节点之外的那个节点(弧头结点)即为当前节点的邻接点.
            // 为了避免
            if ( (-- indegrees[arc->head_vertex_index]) == 0)
                zero_indegree_vertexes.push(graph->vertexes[arc->head_vertex_index]);
        }
    }
    
    // 检查拓扑有序序列顶点个数是否等于有向图顶点个数
    bool loop_exist = visited_vertexnum < graph->vertexnum;
    if (has_loop)
        *has_loop = loop_exist;
    
    if (result_len)
        *result_len = visited_vertexnum;
    if (result)
        *result = topological_sorted_seq;
    else
        free(topological_sorted_seq);
        
    return 0;
}

void ALGraph_vertex_print(VertexPt vertex) {
    if (vertex) printf("%d   ", vertex->value);
}

void test_DALGraph_topological_sort() {
    
    typedef std::pair<int, int> intpair;
    
    std::multimap<int, int> arcs;
    arcs.insert(intpair(0, 2));
    arcs.insert(intpair(0, 7));
    arcs.insert(intpair(1, 0));
    arcs.insert(intpair(3, 2));
    arcs.insert(intpair(3, 7));
    arcs.insert(intpair(4, 1));
    arcs.insert(intpair(4, 3));
    arcs.insert(intpair(4, 5));
    arcs.insert(intpair(5, 0));
    arcs.insert(intpair(5, 1));
    arcs.insert(intpair(6, 3));
    arcs.insert(intpair(6, 4));
    arcs.insert(intpair(7, 2));
    
    // 加上这一条边则形成了有向无环图，可以去尝试一下输出结果
//    arcs.insert(intpair(2, 2));
    
    int vertexes[] = {0, 1, 2, 3, 4, 5, 6, 7};
    ALGraphPt DALGraph = NULL;
    int state = DALGraph_create(vertexes, sizeof(vertexes)/sizeof(vertexes[0]), arcs, &DALGraph);
    debug_log("state = %d\n", state);
    debug_log("vertexnum = %d\n", DALGraph->vertexnum);
    
    int *result = NULL;
    size_t result_len = 0;
    bool has_loop = false;
    DALGraph_topological_sort(DALGraph, &result, &result_len, &has_loop);
    if (has_loop)
        debug_log("has loop!");
    
    print_int_array(result, result_len);
    
    std::vector<int> dfs_exit_vertex_orders;
    ALGraph_dfs(DALGraph, NULL, ALGraph_vertex_print, dfs_exit_vertex_orders);
    /// 对于有向无环图，顶点退出dfs函数的先后顺序和拓扑有序序列的正好互逆
    debug_log("reversed dfs exit vertex order:\n");
    for (std::vector<int>::iterator it = dfs_exit_vertex_orders.end() - 1; it >= dfs_exit_vertex_orders.begin(); -- it) {
        printf("%d   ", *it);
    }
    printf("\n");
    
    ALGraph_bfs(DALGraph, NULL, ALGraph_vertex_print);
    printf("\n");
}
