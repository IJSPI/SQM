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

//Calculate lines of code
public int calculateLOC(M3 model) {
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
    return linesOfCode;
}