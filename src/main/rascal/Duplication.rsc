//Calculation of Metric Duplication - Percentage of duplication of more than 6 lines

module Duplication

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

int blockSize = 6;

public int calcUnitCC(loc locations) {
    int count = 0;

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

public void printDuplicationResults(list[int] counts) {
    int total = sum(counts);
    int perUSSimple = percent(counts[0], total);
    int perUSModerate = percent(counts[1], total);
    int perUSHigh = percent(counts[2], total);
    int perUSVeryHigh = percent(counts[3], total);

    println("Unit Complexity:");
    println("Simple: <perUSSimple>");
    println("Moderate: <perUSModerate>");
    println("High: <perUSHigh>");
    println("Very High: <perUSVeryHigh>");
}


public void calculateDuplication() {
    loc project = |file:///Users/20214192/Downloads/1SQMTestDocs/|;
    M3 model = createM3FromDirectory(project);

    list[int] counts = [0, 0, 0, 0];

    allBlocks{};

    for (loc files <- files(model)) {
        list[str] blockLines = [];
        int i = blockSize; 

        for (line <- readFileLines(files)) {
            trimmedLine = trim(line);
            linesOfCode += 1;

            if (i < blockSize) {
                blocklines += trimmedLine;
                i += 1;
            } else if (i >= blockSize) {
                drop(1, blockLines);
                blocklines += trimmedLine;

                allBlocks += block;
            } 
        }
    }

    
    printDuplicationResults(counts);
}