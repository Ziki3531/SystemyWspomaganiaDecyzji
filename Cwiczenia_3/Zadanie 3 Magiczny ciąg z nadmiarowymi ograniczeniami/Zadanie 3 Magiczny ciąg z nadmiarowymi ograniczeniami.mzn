% Input data
int: n; % Length of the sequence

% Decision variables
% magic[i] = number of occurrences of 'i' in the sequence
array[0..n-1] of var 0..n-1: magic; % Each element is in the range [0, n-1]

% Constraints
% 1. Self-referential condition (main definition)
% For each i, magic[i] must be equal to the count of 'i' in the sequence
constraint forall(i in 0..n-1)(
    sum(j in 0..n-1)(bool2int(magic[j] = i)) = magic[i]
);

% Redundant Constraints (comment/uncomment to test their effect)
% 2. Sum of elements
% The sum of all elements in the magic sequence must equal n
constraint sum(magic) = n; % Removed

% 3. Weighted sum
% The sum of magic[i] * i should equal n
constraint sum(i in 0..n-1)(magic[i] * i) = n; % Removed

% Solve statement: Satisfy the constraints
solve satisfy;

% Output
output ["magic = ", show(magic)];