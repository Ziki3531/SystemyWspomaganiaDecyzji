predicate cumulative(array[int] of var int: s,  % start times
                     array[int] of int: d,      % durations
                     array[int] of int: r,      % resource use
                     int: b) =                  % resource bound
    forall(t in min(s)..max(s) + max(d)) (
        sum(i in index_set(s)) (
            bool2int(s[i] <= t /\ t < s[i] + d[i]) * r[i]
        ) <= b
    );