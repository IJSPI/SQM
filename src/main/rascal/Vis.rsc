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
import lang::csv::IO;

bool reducedSet = true;

//Export the results to CSV file in relevant form
public void exportToCSV() {
    loc project = |file:///Users/20214192/Downloads/1SQMSmallSQL|;
    M3 model = createM3FromDirectory(project);

    rel[str, str, num, num, num] relData = calculateCCDensity(model);
    
    writeCSV(#rel[str, str, num, num, num], relData, |file:///Users/20214192/sqm/res.csv|, header = false, separator = ",");
}

//Calculate list of CC density, size and CC and put in list with name of method and of the parent.
public rel[str, str, num, num, num] calculateCCDensity(M3 model) {
    rel[str, str, num, num, num] functionsRel = {};
    rel[str, str, num, num, num] classesRel = {};

    for(class <- classes(model)) {
        methoden = { y | y <- model.containment[class], y.scheme=="java+method" || y.scheme=="java+constructor"};
        str className = class.file;
        int classCC = 0;
        int classSize = 0;

        for(m <- methoden){
            int size = calcSize(m);
            classSize += size;
            int unitCC = calcUnitCC(m);
            classCC += unitCC;
            real CCDensity = round(toReal(unitCC) / toReal(max(size,1)), 0.001);
            str name = extractMethodName(m);
            if (!reducedSet) {
                functionsRel += <name, className, CCDensity, unitCC, size>;
            }
        }

        loc classParent = class.parent;
        str parentName = classParent.file;
        //println(parentName);
        real classCCDensity = round(toReal(classCC) / toReal(max(classSize, 1)), 0.001);

        functionsRel += <className, parentName, classCCDensity, classCC, classSize>;
        classesRel += <className, parentName, classCCDensity, classCC, classSize>;
    }

    rel[str, str, num, num, num] withFolders = computeClassRelation(functionsRel, classesRel);
    return withFolders;
}

//Compute relation with all nodes for visualization
public rel[str, str, num, num, num] computeClassRelation(rel[str, str, num, num, num] functionsRel, rel[str, str, num, num, num] classesRel) {
    rel[str, str, num, num, num] newRel = functionsRel;
    list[str] classesHad = [];

    for (curClassRel <- classesRel) {

        str name = curClassRel[0];
        int folderCC = 0;
        int folderSize = 0;
        str parent = curClassRel[1];
        bool check = parent in classesHad;

        if (!check) {
            sameParentRel = { <a,b,c,d,e> | <a,b,c,d,e> <- classesRel, b == curClassRel[1]};

            for (classRel <- sameParentRel) {
                folderCC += classRel[3];
                folderSize += classRel[4];
                classesRel -= curClassRel;
            }
            
            real folderCCDensity = round(toReal(folderCC) / toReal(max(folderSize,1)), 0.001);
            classesHad = classesHad + parent;

            newRel += <curClassRel[1], "", folderCCDensity, folderCC, folderSize>;
        }
    }

    return newRel;
}

//Extraxt the method name from the given location.\
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
