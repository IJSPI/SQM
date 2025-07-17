//Calculation of Metric NOU - Number of Units

module USize

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

public int calcSize(loc locations) {
    int linesOfCode = 0;
    int linesOfOthers = 0;

    for (line <- readFileLines(locations)) {
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


public void calculateUnitSize() {
    loc project = |file:///Users/20214192/Downloads/1SQMTestDocs/|;
    M3 model = createM3FromDirectory(project);

    for(class <- classes(model)) {
        methoden = { y | y <- model@containment[class], y.scheme=="java+method" || y.scheme=="java+constructor"};

        for(m <- methoden){
            println(calcSize(m));
            
        }
    }

}