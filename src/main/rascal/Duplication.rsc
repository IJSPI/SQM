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
import Prelude;

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

public void printDuplicationResults(int count) {
    println("Duplication: <count>");
}


public void calculateDuplication() {
    loc project = |file:///Users/20214192/Downloads/1SQMTestDocs/|;
    M3 model = createM3FromDirectory(project);

    int count = 0;
    int amountLines = blockSize;
    rel[list[str],loc,int] allBlocks = {};

    for (loc files <- files(model)) {
        list[str] blockLines = [];
        int i = 0;
        int lineNum = 0; 
        
        //Put all possible blocks of 6 lines in a set.
        for (line <- readFileLines(files)) {
            trimmedLine = trim(line);
            lineNum += 1;

            if (i < blockSize) {
                blockLines += trimmedLine;
                i += 1;
            } else if (i >= blockSize) {
                blockLines = drop(1, blockLines);
                blockLines += trimmedLine;

                allBlocks += {<blockLines, files, lineNum>};
            } 
        }
    }
    
    //creates list of duplications of blocks of 6. If longer than 6, then multiple blocks are incorporated.
    lrel[loc,int,list[str]] duplications = [ <y,z,x> | <x,y,z> <- allBlocks, size(allBlocks[x]) > 1];
    duplications = sort(duplications);
    

    //Longer duplications than 6 - meaning duplication on next line is present in the list.
    for (dup <- duplications) {
        tuple[loc,int,list[str]] nextDuplication = <dup[0],dup[1]+1,dup[2]>;

        bool nextPresent = false;
        for (dup2 <- duplications) {
		    if(dup2[0] == nextDuplication[0] && dup2[1] == nextDuplication[1]) {
			    nextPresent =  true;
		    }
	    }

        if (nextPresent) {
            amountLines += 1;
        } else {
			count += amountLines;
			amountLines = blockSize;
        }
    }

    printDuplicationResults(count);
}