module Main

import Duplication;
import Loc;
import Nou;
import UComplexity;
import USize;

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;

public void main(int testArgument=0) {
    loc project = |file:///Users/20214192/Downloads/1SQMTestDocs/|;
    M3 model = createM3FromDirectory(project);

    str pName = "Example";

    println(pName);
    println("----");

    int LOC = calculateLOC(model);
    println("Lines of Code: <LOC>");

    int NOU = calculateNOU(model);
    println("Number of Units <NOU>");

    list[int] USize = calculateUnitSize(model);
    printUsizeResults(USize);

    list[int] UComplexity = calculateUnitComplexity(model);
    printComplexityResults(UComplexity);

    int duplication = calculateDuplication(model);
    printDuplicationResults(duplication, LOC);

    println("");

    printVolScore();
    printUSizeScore();
    printUComplexityScore();
    printDuplicationScore();
}

public void printVolScore() {

}

public void printUSizeScore() {

}

public void printUComplexityScore() {

}

public void printDuplicationScore() {

}
