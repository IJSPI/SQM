//Calculation of Metric LOC

module Loc

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

public bool aflopend(tuple[&a, num] x, tuple[&a, num] y) {
    return x[1] > y[1];
} 

public map[loc, int] regelsPerBestand (M3 model) {
    set[loc] bestanden = files(model);
    return ( a:size(readFileLines(a)) | a <- bestanden );
}

public void calculateLOC() {
    loc project = |file:///Users/20214192/Downloads/1SQMTestDocs/|;
    M3 model = createM3FromDirectory(project);
    set[loc] bestanden = files(model);

    // aantal Java-bestanden uit tutorial
    println(size(bestanden));

    //Aantal regels per bestand uit tutorial
    map[loc, int] regels = regelsPerBestand(model);
    for (<a, b> <- sort(toList(regels), aflopend))
        println("<a.file>: <b> regels");
}