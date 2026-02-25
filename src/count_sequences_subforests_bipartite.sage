"""
Count unique degree sequences of subforests in a bipartite graph.

This script processes all subgraphs of a bipartite graph, identifies which ones
are forests, extracts their degree sequences, and tracks the number of unique
degree sequences found.
"""


def get_degree_sequence(graph):
    """
    Get the sorted degree sequence of a graph.
    
    Args:
        graph: A Sage Graph object
    
    Returns:
        A tuple representing the sorted degree sequence
    """
    degrees = sorted(graph.degree())
    return tuple(degrees)


def count_subforests_with_unique_degree_sequences_bipartite(graph):
    """
    Count subforests in a bipartite graph and track unique degree sequences.
    
    Args:
        graph: A Sage Graph object (must be bipartite)
    
    Returns:
        Tuple of (count_forests, unique_degree_sequences_set)
    
    Raises:
        ValueError: If the graph is not bipartite
    """
    if not graph.is_bipartite():
        raise ValueError("The input graph must be bipartite!")
    
    vertices = list(graph.vertices())
    edges = list(graph.edges(labels=False))
    n_edges = len(edges)
    
    count_forests = 0
    unique_degree_sequences = set()
    
    # Iterate through all possible subsets of edges
    for edge_subset_bits in range(2**n_edges):
        # Create a subgraph from this subset of edges
        selected_edges = []
        for i in range(n_edges):
            if edge_subset_bits & (1 << i):
                selected_edges.append(edges[i])
        
        # Create subgraph with the selected edges
        subgraph = graph.subgraph(vertices=vertices, edges=selected_edges)
        
        # Check if it's a forest
        if subgraph.is_forest():
            count_forests += 1
            
            # Extract degree sequence and add to set
            degree_seq = get_degree_sequence(subgraph)
            unique_degree_sequences.add(degree_seq)
    
    return count_forests, unique_degree_sequences