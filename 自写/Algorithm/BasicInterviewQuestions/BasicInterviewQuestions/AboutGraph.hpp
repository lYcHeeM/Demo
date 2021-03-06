//
//  AboutGraph.hpp
//  BasicInterviewQuestions
//
//  Created by luozhijun on 2018/2/11.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

#ifndef AboutGraph_hpp
#define AboutGraph_hpp

// 图相关

#include <stdio.h>
#include <map>
#include <vector>

/// 顶点
struct Vertex {
    int value = 0;
    unsigned int index = 0;
    unsigned int indegree = 0;
    unsigned int outdegree = 0;
    struct Arc *firstarc;
};

/// 弧
struct Arc {
    // 弧头顶点在顶点序列中的位置, 无向图中则为对方顶点
    unsigned int head_vertex_index;
    // 弧尾顶点在顶点序列中的位置, 无向图中则为引用当前弧链表的顶点
    unsigned int tail_vertex_index;
    // 权值
    int weight;
    
    struct Arc *nextarc;
};

/// 图的邻接表形式 Adjacency List Graph
struct ALGraph {
    // 由于存储的全是顶点指针，所以此处要高一级抽象，得用二级指针
    struct Vertex **vertexes;
    unsigned int vertexnum;
    unsigned int arcnum;
};

typedef struct Vertex Vertex;
typedef struct Arc Arc;
typedef struct ALGraph ALGraph;
typedef struct Vertex * VertexPt;
typedef struct Arc * ArcPt;
typedef struct ALGraph * ALGraphPt;

/// 标识从源节点到目标节点的一条路径
struct DALPath {
    unsigned int source_vertex_index = 0;
    unsigned int destination_vertex_index = 0;
    int totoal_weight = 0;
    std::vector<int> path;
};

typedef struct DALPath DALPath;

#pragma mark - Methods
/// 构造一个以邻接表为存储结构的有向图;
/// 由输入输出法分析容易得知，时间复杂度为O(n+e);
/// @param arcs 弧节点用二元组 <弧尾顶点在顶点序列中的位置, <弧头顶点在顶点序列中的位置, 弧的权值>> 来表示；
int DALGraph_create(int *vertexes, size_t vertexnum, const std::multimap<int ,int> arcs, ALGraphPt *result);

/// 领接表形式下的深度优先搜索，可指定搜索的起始顶点
/// @param start 搜索的起始顶点，可为空
/// @param dfs_exit_vertex_orders 由于是递归遍历，此参数记录函数栈的退出先后顺序对应的顶点序号(在顶点序列中的位置)，
/// 如果是有向无环图，调用者可以此序列来求出拓扑有序序列。因为无环，所以最先退出DFS函数的顶点即为出度为零的顶点，
/// 也就是拓扑有序序列中的最后一个顶点。由此，按退出DFS函数的先后顺序记录下的顶点序列即为逆向的拓扑有序序列。
/// 时间复杂度为O(n+e);
int ALGraph_dfs(ALGraphPt graph, VertexPt start, void (*visit)(VertexPt), std::vector<int> &dfs_exit_vertex_orders);
    
/// 邻接表形式下的广度优先搜索；
/// 时间复杂度为O(n+e);
int ALGraph_bfs(ALGraphPt graph, VertexPt start, void (*visit)(VertexPt));

/// 对有向图进行拓扑排序；时间复杂度为O(n+e); 拓扑有序序列可能不唯一。
/// @param result 拓扑有序序列, 如果不为NULL，内存由调用者负责管理
/// @param result_len 拓扑有序序列的长度
/// @param has_loop 有向图是否有环
int DALGraph_topological_sort(ALGraphPt graph, int **result, size_t *result_len, bool *has_loop);

// 对带权有向图应用迪杰斯特拉算法求单源最短路径：从一个指定顶点出发，求它到图中其余顶点的最短路径集合，并令集合按路径权值之和的升序排列；
// O(n^2)
int DALGraph_shortest_path_dij(ALGraphPt graph, VertexPt start, std::vector<DALPath> &pathes);

void test_DALGraph();

void ALGraph_vertex_print(VertexPt vertex);

#endif /* AboutGraph_hpp */
