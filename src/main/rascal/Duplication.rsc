//Calculation of metric duplication

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

//Size of the minimal duplication block to be checked
int blockSize = 6;

//Print duplication result in rascal terminal.
public void printDuplicationResults(int count, int LOC) {
    int per = percent(count, LOC);
    println("Duplication: <per>%");
}

//Calculate amount of lines duplication.
public int calculateDuplication(M3 model) {
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

            //Check wether the line is relevant (eg not empty or only containing accolade)
            bool relevance = checkRelevance(trimmedLine);

            //Only if line is relevant:
            if (i < blockSize && relevance) {
                blockLines += trimmedLine;
                i += 1;
            } else if (i >= blockSize && relevance) {
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

    return count;
}

//Checks whether a given line is relevant
public bool checkRelevance(str line) {
    if (startsWith(line, "//")) {
        return false;
    } else if (startsWith(line, "/***")) {
        return false;
    } else if (startsWith(line, "*")) {
        return false;
    } else if (isEmpty(line)) {
        return false;
    } else if (startsWith(line, "}")) {
        return false;
    } else if (startsWith(line, "import")) {
        return false;
    } else if (startsWith(line, "package")) {
        return false;
    } else {
        return true;
    }
}