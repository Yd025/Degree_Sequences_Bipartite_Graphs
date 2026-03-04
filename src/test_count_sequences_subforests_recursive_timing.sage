import time
# Ensure your original file is in the same directory
load("count_sequences_subforests_bipartite.sage")

def run_performance_test():
    # Define test cases: (Name, Graph Object, Max Edges for Original Method)
    test_cases = [
        ("Path 8", graphs.PathGraph(8), 20),
        ("K_{3,3}", graphs.CompleteBipartiteGraph(3, 3), 10),
        ("Cycle 10", graphs.CycleGraph(10), 20),
        ("K_{4,4}", graphs.CompleteBipartiteGraph(4, 4), 14), 
        ("K_{5,5}", graphs.CompleteBipartiteGraph(5, 5), 0)   
    ]

    print(f"{'Graph':<12} | {'Edges':<6} | {'Match?':<8} | {'Orig Time (s)':<15} | {'Rec Time (s)':<15}")
    print("-" * 75)

    for name, G, limit in test_cases:
        m = G.num_edges()

        # Time the Recursive approach
        t_start_recursive = cputime()
        count_r, seqs_r = count_subforests_recursive(G)
        t_recursive = cputime(t_start_recursive)

        # Time the Original approach
        if m <= limit:
            t_start_orig = cputime()
            count_o, seqs_o = count_subforests_with_unique_degree_sequences_bipartite(G)
            t_orig = cputime(t_start_orig)
            
            # Check if both methods found the same number of subforests and unique sequences
            match = "Yes" if (count_r == count_o and len(seqs_r) == len(seqs_o)) else "FAIL"
            orig_str = f"{t_orig:.5f}"
        else:
            match = "N/A"
            orig_str = f"Skipped (2^{m})"

        print(f"{name:<12} | {m:<6} | {match:<8} | {orig_str:<15} | {t_recursive:.5f}")

if __name__ == "__main__":
    print("Starting Runtime Comparison...")
    run_performance_test()