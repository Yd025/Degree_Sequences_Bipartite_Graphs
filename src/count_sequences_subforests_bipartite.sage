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
        # Extract degree sequence and add to set
        degree_seq = get_degree_sequence(subgraph)
        unique_degree_sequences.add(degree_seq)
        
        # Check if it's a forest
        if subgraph.is_forest():
            count_forests += 1t
    
    return count_forests, unique_degree_sequences

def count_subforests_recursive(G):
    """
    Finds subforests by recursively building them and pruning cycles.
    """
    if not G.is_bipartite():
        raise ValueError("The input graph must be bipartite!")

    edges = list(G.edges(labels=False))
    vertices = list(G.vertices())
    n_edges = len(edges)
    unique_sequences = set()
    
    # We use a single graph object and add/remove edges to save memory
    current_forest = Graph([vertices, []], format='vertices_and_edges')

    def backtrack(edge_idx):
        # Base case when all egdes are implemented
        if edge_idx == n_edges:
            seq = tuple(current_forest.degree_sequence())
            unique_sequences.add(seq)
            return 1

        count = 0
        
        # First branch to skip the current edge
        count += backtrack(edge_idx + 1)

        # Second branch to add the current edge if it doesn't create a cycle
        u, v = edges[edge_idx]
        if not current_forest.connected_component_containing_vertex(u) == \
               current_forest.connected_component_containing_vertex(v):
            
            current_forest.add_edge(u, v)
            count += backtrack(edge_idx + 1)
            current_forest.delete_edge(u, v) # Backtrack
            
        return count

    total_forests = backtrack(0)
    return total_forests, unique_sequences