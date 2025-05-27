
int: nodesNumber; 
int: minColorsNumber; 
array[1..nodesNumber, 1..nodesNumber] of bool: edges; 


array[int] of int: maxClique;


array[1..nodesNumber] of var 1..nodesNumber: nodes_colors;


var 1..nodesNumber: colorsNumber;




constraint colorsNumber = max(nodes_colors);


constraint forall(i in 1..nodesNumber, j in 1..nodesNumber where i < j /\ edges[i,j])(
    nodes_colors[i] != nodes_colors[j]
);



constraint forall(i in 1..minColorsNumber)(
    nodes_colors[i] = i
);


solve minimize colorsNumber;


output [
    "Nodes colors: ", show(nodes_colors), "\n",
    "Minimum colors used: ", show(colorsNumber), "\n"
];