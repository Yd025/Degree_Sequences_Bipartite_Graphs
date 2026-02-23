"""
Count the number of subforests in a graph.

A subforest is any subgraph that is acyclic (a forest contains no cycles).
This includes the empty graph and all forests that are subgraphs of the original graph.
"""

load("helpers.sage")


if __name__ == "__main__":
    # Example: Create a small bipartite graph and count subforests
    
    # Example 1: Simple bipartite graph K_{2,2}
    print("Example 1: Complete bipartite graph K_{2,2}")
    G1 = graphs.CompleteBipartiteGraph(2, 2)
    print(f"Vertices: {G1.vertices()}")
    print(f"Edges: {G1.edges(labels=False)}")
    print(f"Number of edges: {G1.num_edges()}")
    
    count1, subforests1 = count_subforests(G1)
    print(f"Number of subforests: {count1}\n")
    
    # Example 2: Path graph (which is bipartite)
    print("Example 2: Path graph with 4 vertices")
    G2 = graphs.PathGraph(4)
    print(f"Vertices: {G2.vertices()}")
    print(f"Edges: {G2.edges(labels=False)}")
    print(f"Number of edges: {G2.num_edges()}")
    
    count2 = count_subforests_fast(G2)
    print(f"Number of subforests: {count2}\n")
    
    # Example 3: Cycle graph with 4 vertices (bipartite)
    print("Example 3: Cycle with 4 vertices")
    G3 = graphs.CycleGraph(4)
    print(f"Vertices: {G3.vertices()}")
    print(f"Edges: {G3.edges(labels=False)}")
    print(f"Number of edges: {G3.num_edges()}")
    
    count3 = count_subforests_fast(G3)
    print(f"Number of subforests: {count3}\n")
    
    # Example 4: Complete bipartite graph K_{3,3}
    print("Example 4: Complete bipartite graph K_{3,3}")
    G4 = graphs.CompleteBipartiteGraph(3, 3)
    print(f"Number of vertices: {G4.num_verts()}")
    print(f"Number of edges: {G4.num_edges()}")
    
    count4 = count_subforests_fast(G4)
    print(f"Number of subforests: {count4}\n")
