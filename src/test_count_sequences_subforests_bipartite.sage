load("count_sequences_subforests_bipartite.sage")


if __name__ == "__main__":
    # Example: Create small bipartite graphs and analyze degree sequences
    
    # Example 1: Complete bipartite graph K_{2,2}
    print("Example 1: Complete bipartite graph K_{2,2}")
    G1 = graphs.CompleteBipartiteGraph(2, 2)
    print(f"Vertices: {G1.vertices()}")
    print(f"Edges: {G1.edges(labels=False)}")
    print(f"Is bipartite: {G1.is_bipartite()}")
    print(f"Number of edges: {G1.num_edges()}")
    
    count1, unique_seqs1 = count_subforests_with_unique_degree_sequences_bipartite(G1)
    print(f"Number of subforests: {count1}")
    print(f"Number of unique degree sequences: {len(unique_seqs1)}")
    print(f"Unique degree sequences: {sorted(unique_seqs1)}\n")
    
    # Example 2: Path graph (which is bipartite)
    print("Example 2: Path graph with 4 vertices")
    G2 = graphs.PathGraph(4)
    print(f"Vertices: {G2.vertices()}")
    print(f"Edges: {G2.edges(labels=False)}")
    print(f"Is bipartite: {G2.is_bipartite()}")
    print(f"Number of edges: {G2.num_edges()}")
    
    count2, unique_seqs2 = count_subforests_with_unique_degree_sequences_bipartite(G2)
    print(f"Number of subforests: {count2}")
    print(f"Number of unique degree sequences: {len(unique_seqs2)}")
    print(f"Unique degree sequences: {sorted(unique_seqs2)}\n")
    
    # Example 3: Cycle graph with 4 vertices (bipartite)
    print("Example 3: Cycle with 4 vertices")
    G3 = graphs.CycleGraph(4)
    print(f"Vertices: {G3.vertices()}")
    print(f"Edges: {G3.edges(labels=False)}")
    print(f"Is bipartite: {G3.is_bipartite()}")
    print(f"Number of edges: {G3.num_edges()}")
    
    count3, unique_seqs3 = count_subforests_with_unique_degree_sequences_bipartite(G3)
    print(f"Number of subforests: {count3}")
    print(f"Number of unique degree sequences: {len(unique_seqs3)}")
    print(f"Unique degree sequences: {sorted(unique_seqs3)}\n")
    
    # Example 4: Complete bipartite graph K_{3,3}
    print("Example 4: Complete bipartite graph K_{3,3}")
    G4 = graphs.CompleteBipartiteGraph(3, 3)
    print(f"Is bipartite: {G4.is_bipartite()}")
    print(f"Number of vertices: {G4.num_verts()}")
    print(f"Number of edges: {G4.num_edges()}")
    
    count4, unique_seqs4 = count_subforests_with_unique_degree_sequences_bipartite(G4)
    print(f"Number of subforests: {count4}")
    print(f"Number of unique degree sequences: {len(unique_seqs4)}")
    print(f"Unique degree sequences: {sorted(unique_seqs4)}\n")
    
    # Example 5: Non-bipartite graph (triangle) - should raise error
    print("Example 5: Triangle (non-bipartite) - should raise error")
    G5 = graphs.CycleGraph(3)
    print(f"Is bipartite: {G5.is_bipartite()}")
    
    try:
        count5, unique_seqs5 = count_subforests_with_unique_degree_sequences_bipartite(G5)
    except ValueError as e:
        print(f"Error caught: {e}\n")
