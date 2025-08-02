//Calculation of Metric Unit Complexity

module UComplexity

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

//Calculate cyclomatic complexity per unit by counting predicates and adding 1 (1 is starting value)
public int calcUnitCC(loc locations) {
    int count = 1;

    for (l <- readFileLines(locations)) {
        l = trim(uncapitalize(l));
        if (startsWith(l, "if")) {
            count=count+1;
        } if (startsWith(l, "while")) {
            count=count+1;
        } if (startsWith(l, "for")) {
            count=count+1;
        } if (startsWith(l, "case")) {
            count=count+1;
        } if (startsWith(l, "catch")) {
            count=count+1;
        } if (startsWith(l, "foreach")) {
            count=count+1;
        } if (contains(l, "||")) {
            count=count+1;
        } if (contains(l, "&&")) {
            count=count+1;
        } if (contains(l, "?")) {
            count=count+1;
        }
    }
    
    return count;
}

//Print the complexity results in the rascal terminal.
public void printComplexityResults(list[int] counts) {
    println("Unit Complexity:");
    println("  *  Simple: <counts[0]>%");
    println("  *  Moderate: <counts[1]>%");
    println("  *  High: <counts[2]>%");
    println("  *  Very High: <counts[3]>%");
}

//Calculate the complete unit complexity
public list[int] calculateUnitComplexity(M3 model) {
    list[int] counts = [0, 0, 0, 0];

    for(class <- classes(model)) {
        int cc = 0;
        methoden = { y | y <- model.containment[class], y.scheme=="java+method" || y.scheme=="java+constructor"};


        for(m <- methoden){
            cc += calcUnitCC(m);   
        }

        if (cc >= 1 && cc <= 10) {
            counts[0] += 1;
        } else if (cc >= 11 && cc <= 20) {
            counts[1] += 1;
        } else if (cc >= 21 && cc <= 50) {
            counts[2] += 1;
        } else if (cc >= 51) {
            counts[3] += 1;
    }
    }

    int total = sum(counts);
    counts[0] = percent(counts[0], total);
    counts[1] = percent(counts[1], total);
    counts[2] = percent(counts[2], total);
    counts[3] = percent(counts[3], total);
     
    return counts;
}