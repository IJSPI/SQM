module Main

import Duplication;
import Loc;
import Nou;
import UComplexity;
import USize;

import IO;
import analysis::graphs::Graph;
import lang::java::m3::Core;
import lang::java::m3::AST;
import vis::Charts;
import vis::Graphs;
import Content;
import Map;
import List;
import Set;
import Relation;

public void main(int testArgument=0) {
    loc project = |file:///Users/20214192/Downloads/1SQMSmallSQL/|;
    M3 model = createM3FromDirectory(project);

    str pName = "Small SQL";

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

    int volScore = printVolScore(LOC);
    int sizScore = printUSizeScore(USize);
    int comScore = printUComplexityScore(UComplexity);
    int dupScore = printDuplicationScore(duplication);

    println("");

    printMaintainabilityScores(volScore, sizScore, comScore, dupScore);

    VisRegelsPerBestand(model);
}

public int printVolScore(int LOC) {
    str volScore = "";
    if (LOC >= 0 && LOC <= 66000) {
        volScore = "++";
    } else if (LOC >= 66001 && LOC <= 246000) {
        volScore = "+";
    } else if (LOC >= 246001 && LOC <= 665000) {
        volScore = "o";
    } else if (LOC >= 655001 && LOC <= 1310000) {
        volScore = "-";
    } else if (LOC >= 1310001) {
        volScore = "--";
    }
    println("Volume score: " + volScore);
    return calcNum(volScore);
}

public int printUSizeScore(list[int] per) {
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
    return calcNum(sizScore);
}

public int printUComplexityScore(list[int] per) {
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
    return calcNum(comScore);
}

public int printDuplicationScore(int dup) {
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
    return calcNum(dupScore);
}

public void printMaintainabilityScores(int volScore, int sizScore, int comScore, int dupScore) {
    int analysability = (volScore + dupScore + sizScore) / 3;
    println("Analysability score: " + calcStr(analysability));

    int changeability = (comScore + dupScore) / 2;
    println("Changeability score: " + calcStr(changeability));

    int testability = (comScore + sizScore) / 2;
    println("Testability score: " + calcStr(testability));

    println("");

    int overall = (volScore + dupScore + sizScore + comScore) / 4;
    println("Overall maintainability score: " + calcStr(overall));
}

//Helper function to return number based on string score
int calcNum(str score) {
    visit (score) {
        case "++": return 5;
        case "+": return 4;
        case "o": return 3;
        case "-": return 2;
        case "--": return 1;
    }
}

//Helper function to return string based on number
str calcStr(int score) {
    visit (score) {
        case 1: return "--";
        case 2: return "-";
        case 3: return "o";
        case 4: return "+";
        case 5: return "++";
    }
}

public map[loc, int] regelsPerBestand (M3 model) {
    set[loc] bestanden = files(model);
    return ( a:size(readFileLines(a)) | a <- bestanden );
}

public Content Vis() {
    loc project = |file:///Users/20214192/Downloads/1SQMSmallSQL/|;
    M3 model = createM3FromDirectory(project);
    rel[str, num] regels = { <l.file, a> | <l,a> <- toRel(regelsPerBestand(model)) };
    return barChart(sort(regels, aflopend), title="Regels per Javabestand");
}

public Content VisComponenten() {
    return graph(gebruikt,title="Componenten", \layout=defaultGridLayout(rows=2,cols=3));
}