module Vis

import Duplication;
import Loc;
import Nou;
import UComplexity;
import USize;

import IO;
import analysis::graphs::Graph;
import lang::java::m3::Core;
import lang::java::m3::AST;
import vis::Charts;
import vis::Graphs;
import Content;
import Map;
import List;
import Set;
import Relation;
import Vis;

public Content vis() {
    loc project = |file:///Users/20214192/Downloads/1SQMSmallSQL/|;
    M3 model = createM3FromDirectory(project);
    rel[str, num] regels = { <l.file, a> | <l,a> <- toRel(regelsPerBestand(model)) };
    calculateCCDensity(model);
    return barChart(sort(regels, aflopend), title="Regels per Javabestand");
}

public map[loc, int] regelsPerBestand (M3 model) {
    set[loc] bestanden = files(model);
    return (a:calculateFileLOC(a) | a <- bestanden);
}

public rel[str, num] calculateCCDensity(M3 model) {
    rel[str, num] functions = {};

    for(class <- classes(model)) {
        methoden = { y | y <- model.containment[class], y.scheme=="java+method" || y.scheme=="java+constructor"};

        for(m <- methoden){
            int size = calcSize(m);
            int unitCC = calcUnitCC(m);
            println("Size: <size> CC: <unitCC>");
        }
    }

    return functions;
}
