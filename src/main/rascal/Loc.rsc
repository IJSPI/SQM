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
import String;

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

    int linesOfCode = 0;
    int linesOfOthers = 0;
    //LOC
    for (loc files <- files(model)) {
        for (line <- readFileLines(files)) {
            linesOfCode += 1;

            if (startsWith(trim(line), "//")) {
                linesOfOthers += 1;
            } else if (startsWith(trim(line), "/***")) {
                linesOfOthers += 1;
            } else if (startsWith(trim(line), "*")) {
                linesOfOthers += 1;
            } else if (isEmpty(trim(line))) {
                linesOfOthers += 1;
            } else if (startsWith(trim(line), "}")) {
                linesOfOthers += 1;
            }
        }
    }
    
    linesOfCode -= linesOfOthers;
    println("Lines of Code: <linesOfCode>");
}