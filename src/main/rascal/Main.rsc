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

    list[int] USize = calculateUnitSize(model); //List of percentage
    printUsizeResults(USize);

    list[int] UComplexity = calculateUnitComplexity(model); //List of percentage
    printComplexityResults(UComplexity);

    int duplication = calculateDuplication(model);
    printDuplicationResults(duplication, LOC);

    println("");

    printVolScore(LOC);
    printUSizeScore(USize);
    printUComplexityScore(UComplexity);
    printDuplicationScore(duplication);
}

public void printVolScore(int LOC) {
    if (LOC >= 0 && LOC <= 66000) {
        println("Volume score: ++");
    } else if (LOC >= 66001 && LOC <= 246000) {
        println("Volume score: +");
    } else if (LOC >= 246001 && LOC <= 665000) {
        println("Volume score: o");
    } else if (LOC >= 655001 && LOC <= 1310000) {
        println("Volume score: -");
    } else if (LOC >= 1310001) {
        println("Volume score: --");
    }
}

public void printUSizeScore(list[int] per) {
    str sizScore = "";
    if (per[1] <= 25  && per[2] <= 0 && per[3] <= 0) {
        sizScore = "++";
    } else if (per[1] <= 30  && per[2] <= 5 && per[3] <= 0) {
        sizScore = "+";
    } else if (per[1] <= 40  && per[2] <= 10 && per[3] <= 0) {
        sizScore = "o";
    } else if (per[1] <= 50  && per[2] <= 15 && per[3] <= 5) {
        sizScore = "-";
    } else {
        sizScore = "--";
    }
    println("Unit Complexity score: " + sizScore);
}

public void printUComplexityScore(list[int] per) {
    str comScore = "";
    if (per[1] <= 25  && per[2] <= 0 && per[3] <= 0) {
        comScore = "++";
    } else if (per[1] <= 30  && per[2] <= 5 && per[3] <= 0) {
        comScore = "+";
    } else if (per[1] <= 40  && per[2] <= 10 && per[3] <= 0) {
        comScore = "o";
    } else if (per[1] <= 50  && per[2] <= 15 && per[3] <= 5) {
        comScore = "-";
    } else {
        comScore = "--";
    }
    println("Unit Complexity score: " + comScore);
}

public void printDuplicationScore(int dup) {
    str dupScore = "";
    if (dup >= 0 && dup <= 3) {
        dupScore = "++";
    } else if (dup >= 4 && dup <= 5) {
        dupScore = "+";
    } else if (dup >= 6 && dup <= 10) {
        dupScore = "o";
    } else if (dup >= 11 && dup <= 20) {
        dupScore = "-";
    } else if (dup >= 21) {
        dupScore = "--";
    }
    println("Duplication score: " + dupScore);
}
