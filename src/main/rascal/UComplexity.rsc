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

    visit (locations) {
        case \if(_,_): count=count+1;
        case \if(_,_,_): count=count+1;
        case \while(_,_): count=count+1;
        case \for(_,_,_): count=count+1;
        case \for(_,_,_,_): count=count+1;
        case \case(_): count=count+1;
        case \catch(_,_): count=count+1;
        case \conditional(_,_,_): count=count+1;
    }
    
    return count;
}

//Print the complexity results in the rascal terminal.
public void printComplexityResults(list[int] counts) {
    int total = sum(counts);
    int perUSSimple = percent(counts[0], total);
    int perUSModerate = percent(counts[1], total);
    int perUSHigh = percent(counts[2], total);
    int perUSVeryHigh = percent(counts[3], total);

    println("Unit Complexity:");
    println("  *  Simple: <perUSSimple>%");
    println("  *  Moderate: <perUSModerate>%");
    println("  *  High: <perUSHigh>%");
    println("  *  Very High: <perUSVeryHigh>%");
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
     
    return counts;
}