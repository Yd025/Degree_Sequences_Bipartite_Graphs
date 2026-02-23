"""
Helper functions for graph analysis.
"""

def is_forest(graph):
    """
    Check if a graph is a forest (acyclic).
    A graph is a forest if and only if it has no cycles.
    
    Args:
        graph: A Sage Graph object
    
    Returns:
        True if the graph is a forest, False otherwise
    """
    return graph.is_forest()


def _count_subforests(graph, return_subforests=False):
    """
    Core implementation for counting subforests in a graph.
    
    Args:
        graph: A Sage Graph object
        return_subforests: If True, returns (count, subforests list)
                          If False, returns only count
    
    Returns:
        If return_subforests is True: (count, subforests)
        If return_subforests is False: count
    """
    vertices = list(graph.vertices())
    edges = list(graph.edges(labels=False))
    n_edges = len(edges)
    
    count = 0
    subforests = [] if return_subforests else None
    
    for edge_subset_bits in range(2**n_edges):
        # Create a subgraph from this subset of edges
        selected_edges = []
        for i in range(n_edges):
            if edge_subset_bits & (1 << i):
                selected_edges.append(edges[i])
        
        # Create subgraph with the selected edges
        subgraph = graph.subgraph(vertices=vertices, edges=selected_edges)
        
        # Check if it's a forest
        if is_forest(subgraph):
            count += 1
            if return_subforests:
                subforests.append((selected_edges, subgraph))
    
    return (count, subforests) if return_subforests else count


# Public API for generic graphs

def count_subforests(graph):
    """
    Count the number of subforests in a graph.
    
    Args:
        graph: A Sage Graph object
    
    Returns:
        Tuple of (count, list of subforests)
    """
    return _count_subforests(graph, return_subforests=True)


def count_subforests_fast(graph):
    """
    Fast version that only counts subforests without storing them.
    
    Args:
        graph: A Sage Graph object
    
    Returns:
        The total number of subforests
    """
    return _count_subforests(graph, return_subforests=False)


# Public API for bipartite graphs

def count_subforests_bipartite(graph):
    """
    Count the number of subforests in a bipartite graph.
    
    Args:
        graph: A Sage Graph object (must be bipartite)
    
    Returns:
        Tuple of (count, list of subforests)
    
    Raises:
        ValueError: If the graph is not bipartite
    """
    if not graph.is_bipartite():
        raise ValueError("The input graph must be bipartite!")
    
    return _count_subforests(graph, return_subforests=True)


def count_subforests_bipartite_fast(graph):
    """
    Fast version that only counts subforests without storing them.
    Only accepts bipartite graphs.
    
    Args:
        graph: A Sage Graph object (must be bipartite)
    
    Returns:
        The total number of subforests
    
    Raises:
        ValueError: If the graph is not bipartite
    """
    if not graph.is_bipartite():
        raise ValueError("The input graph must be bipartite!")
    
    return _count_subforests(graph, return_subforests=False)
