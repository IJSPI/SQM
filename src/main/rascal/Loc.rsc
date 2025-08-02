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

//Calculate LOC per file
public int calculateFileLOC(loc file) {
    int linesOfCode = 0;
    int linesOfOthers = 0;

    for (line <- readFileLines(file)) {
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

    linesOfCode -= linesOfOthers;
    return linesOfCode;
}

//Calculate lines of code
public int calculateLOC(M3 model) {
    int linesOfCode = 0;
    //LOC
    for (loc file <- files(model)) {
        linesOfCode += calculateFileLOC(file);
    }
    
    return linesOfCode;
}