//Calculation of Metric NOU - Number of Units

module Nou

import IO;
import List;
import Map;
import Relation;
import Set;
import analysis::graphs::Graph;
import lang::java::m3::Core;
import lang::java::m3::AST;
import vis::Charts;
import vis::Graphs;
import Content;
import String;

//Compare tuples
public bool aflopend(tuple[&a, num] x, tuple[&a, num] y) {
   return x[1] > y[1];
} 

//Calculate the number of units
public int calculateNOU(M3 model) {
    int numberOfUnits = 0;
    
    // aantal methoden per klasse (gesorteerd)
    methoden =  { <x,y> | <x,y> <- model.containment
                        , x.scheme=="java+class"
                        , y.scheme=="java+method" || y.scheme=="java+constructor" 
                        };
    telMethoden = { <a, size(methoden[a])> | a <- domain(methoden) };
    for (<a,n> <- sort(telMethoden, aflopend)) {
        numberOfUnits += n;
    }
        
    return numberOfUnits;
}