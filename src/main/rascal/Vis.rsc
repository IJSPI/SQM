module Vis

import Duplication;
import Loc;
import Nou;
import UComplexity;
import USize;

import IO;
import analysis::graphs::Graph;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::html::IO;
import lang::html::AST;
import Content;
import Charts;
import Map;
import List;
import Set;
import Relation;
import String;
import util::Math;

public Content vis() {
    loc project = |file:///Users/20214192/Downloads/1SQMTest/|;
    M3 model = createM3FromDirectory(project);
    rel[str, num] regels = { <l.file, a> | <l,a> <- toRel(regelsPerBestand(model)) };

    str title = "Cyclomatic Complexity Density per Method";
    ChartData visData = chartData(calculateCCDensity(model));
    return barChart(sort(regels, aflopend), title="Regels per Javabestand");
}

public map[loc, int] regelsPerBestand (M3 model) {
    set[loc] bestanden = files(model);
    return (a:calculateFileLOC(a) | a <- bestanden);
}

//Calculate list of CC density's and put in list with name of method.
public rel[str, num] calculateCCDensity(M3 model) {
    rel[str, num] functions = {};

    for(class <- classes(model)) {
        methoden = { y | y <- model.containment[class], y.scheme=="java+method" || y.scheme=="java+constructor"};

        for(m <- methoden){
            int size = calcSize(m);
            int unitCC = calcUnitCC(m);
            real CCDensity = round(toReal(unitCC) / toReal(size), 0.001);
            str name = extractMethodName(m);
            functions += <name, CCDensity>;
        }
    }
    println(functions);
    return functions;
}

//Return method name
public str extractMethodName(loc method) {
    bool gotName = false;
    str methodName = "";
    int irrLine = 0;

    for (l <- readFileLines(method)) {
        if (!checkRelevance(l)) {
            irrLine += 1;
        } else {
            str haak = stringChar(28);
            list[int] pos = findAll(l, "(");
            list[str] splitLine = split("(", l);
            splitLine = split(" ", splitLine[0]);
            methodName = last(splitLine);
            return methodName;
        }
        
    }
}
