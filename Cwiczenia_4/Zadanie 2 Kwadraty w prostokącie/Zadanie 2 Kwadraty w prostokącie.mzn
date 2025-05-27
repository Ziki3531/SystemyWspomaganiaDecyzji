include "diffn.mzn";
include "cumulative.mzn";

int: n;

array[1..n] of int: dx = [i | i in 1..n];
array[1..n] of int: dy = [i | i in 1..n];

% Calculate the maximum possible dimension for bounds
int: max_dim = sum(dx); % Which is 21 for n=6

array[1..n] of var 0..max_dim: x; % X-coordinate with explicit upper bound
array[1..n] of var 0..max_dim: y; % Y-coordinate with explicit upper bound

var 1..max_dim: width;
var 1..max_dim: height;

% Domain for coordinates and dimensions
constraint forall(i in 1..n) (
    x[i] >= 0 /\ x[i] + dx[i] <= width /\
    y[i] >= 0 /\ y[i] + dy[i] <= height
);

% No overlap between squares [cite: 7]
constraint diffn(x, y, dx, dy);

% Minimize the area of the container
solve minimize width * height;

% --- Additional Constraints (not obligatory but introduce spatial rules) ---

% 1. The largest square (square 'n') adheres to the left edge [cite: 9]
constraint x[n] = 0;

% 2. Enforce a proportion for the container [cite: 10]
constraint width <= 3 * height div 2;

% 3. At least one square touches the upper edge [cite: 11]
constraint exists(i in 1..n)(y[i] + dy[i] = height);

output [
    "width = \(width)\n",
    "height = \(height)\n",
    "x = \(x)\n",
    "y = \(y)\n"
];