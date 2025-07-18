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

//calculate individual unit size
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

//Print unit size results in the rascal terminal
public void printUsizeResults(list[int] counts) {
    println("Unit Size:");
    println("  *  Simple: <counts[0]>%");
    println("  *  Moderate: <counts[1]>%");
    println("  *  High: <counts[2]>%");
    println("  *  Very High: <counts[3]>%");
}

//Calculate the unit classification in unit (method) sizes
public list[int] calculateUnitSize(M3 model) {
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

    int total = sum(counts);
    counts[0] = percent(counts[0], total);
    counts[1] = percent(counts[1], total);
    counts[2] = percent(counts[2], total);
    counts[3] = percent(counts[3], total);

    return counts;
}