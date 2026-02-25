import sys

def havel_hakimi_steps(seq):
    # Convert to Sage Integers and sort
    d = sorted([Integer(x) for x in seq], reverse=True)
    steps = [list(d)]
    
    print(f"Starting sequence: {d}")
    
    while any(x > 0 for x in d):
        # 1. Remove the largest degree
        delta = d.pop(0)
        
        # 2. Check if we have enough vertices left
        if delta > len(d):
            print(f"!!! Error: Cannot connect degree {delta} to only {len(d)} remaining vertices.")
            return None
        
        # 3. Subtract 1 from the next 'delta' elements
        print(f"Removing {delta}: subtracting 1 from the next {delta} elements...")
        for i in range(delta):
            d[i] -= 1
            if d[i] < 0:
                print(f"!!! Error: Sequence became negative at index {i}.")
                return None
        
        # 4. Re-sort for the next step
        d.sort(reverse=True)
        steps.append(list(d))
        print(f"  Resulting sequence: {d}")
        
    return steps

# --- Execution ---
if len(sys.argv) < 2:
    print("Usage: sage realize.sage 3 3 2 2 2")
else:
    input_seq = sys.argv[1:]
    history = havel_hakimi_steps(input_seq)
    
    if history:
        print("\nConclusion: The sequence is GRAPHIC.")
        # Now use Sage's built-in to show the final graph
        G = graphs.DegreeSequence([Integer(x) for x in input_seq])
        G.plot(title="Final Realization").save("realization.png")
        print("Final realization saved to realization.png")
    else:
        print("\nConclusion: The sequence is NOT graphic.")
