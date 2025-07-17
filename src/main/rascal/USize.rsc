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
import util::Math;
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

public void printResults(list[int] counts) {
    int total = sum(counts);
    int perUSSimple = percent(counts[0], total);
    int perUSModerate = percent(counts[1], total);
    int perUSHigh = percent(counts[2], total);
    int perUSVeryHigh = percent(counts[3], total);

    println("Unit Size:");
    println("Simple: <perUSSimple>");
    println("Moderate: <perUSModerate>");
    println("High: <perUSHigh>");
    println("Very High: <perUSVeryHigh>");
}


public void calculateUnitSize() {
    loc project = |file:///Users/20214192/Downloads/1SQMTestDocs/|;
    M3 model = createM3FromDirectory(project);

    list[int] counts = [0, 0, 0, 0];

    for(class <- classes(model)) {
        methoden = { y | y <- model.containment[class], y.scheme=="java+method" || y.scheme=="java+constructor"};

        for(m <- methoden){
            int size = calcSize(m);

            if (size >= 1 && size <= 30) {
                counts[0] += 1;
            } else if (size >= 31 && size <= 44) {
                counts[1] += 1;
            } else if (size >= 45 && size <= 74) {
                counts[2] += 1;
            } else if (size >= 75) {
                counts[3] += 1;
            } 
        }
    }

    printResults(counts);
}