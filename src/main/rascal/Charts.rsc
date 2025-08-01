// Copied from rascal library in github
module Charts

import lang::html::IO;
import lang::html::AST;
import Content;
import Set;
import List;


@synopsis{A bar chart from labeled numbers}
Content barChart(rel[str label, num val] values, str title="Bar Chart", ChartAutoColorMode colorMode=\data())
    = content(title, chartServer(chartData(values), \type=\bar(), title=title, colorMode=colorMode, legend=false));

Content barChart(lrel[str label, num val] values, str title="Bar Chart", ChartAutoColorMode colorMode=\data())
    = content(title, chartServer(chartData(values), \type=\bar(), title=title, colorMode=colorMode, legend=true));

Content barChart(list[str] labels, rel[str label, num val] values..., str title="Bar Chart", ChartAutoColorMode colorMode=\dataset())
    = content(title, chartServer(chartData(labels, values), \type=\bar(), title=title, colorMode=colorMode, legend=false));

Content barChart(list[str] labels, lrel[str label, num val] values..., str title="Bar Chart", ChartAutoColorMode colorMode=\dataset())
    = content(title, chartServer(chartData(labels, values), \type=\bar(), title=title, colorMode=colorMode, legend=true));

@synopsys{
converts plain data sources into chart.js datasets
}
ChartDataSet chartDataSet(str label, rel[num x, num y] r)
    = chartDataSet([point(x,y) | <x,y> <- r],
        label=label
    );

ChartDataSet chartDataSet(str label, map[num x, num y] r)
    = chartDataSet([point(x,r[x]) | x <- r],
        label=label
    );    

ChartDataSet chartDataSet(str label, rel[num x, num y, num rad] r)
    = chartDataSet([point(x,y,r=rad) | <x,y,rad> <- r],
        label=label
    );

ChartDataSet chartDataSet(str label, lrel[num x,num y] r)
    = chartDataSet([point(x,y) | <x,y> <- r],
        label=label
    );

ChartDataSet chartDataSet(str label, lrel[num x, num y, num r] r)
    = chartDataSet([point(x,y,r=rad) | <x,y,rad> <- r],
        label=label
    );    

@synopsys{
converts plain data sources into the chart.js data representation
}
ChartData chartData(rel[str label, num val] v)
    = chartData(
        labels=[l | <l,_> <- v],
        datasets=[
            chartDataSet([n | <_, n> <- v])
        ]
    );  

ChartData chartData(map[str label, num val] v)
    = chartData(
        labels=[l | l <- v],
        datasets=[
            chartDataSet([v[l] | l <- v])
        ]
    );        

ChartData chartData(lrel[str label, num val] v)
    = chartData(
        labels=[l | <l,_> <- v],
        datasets=[
            chartDataSet([n | <_, n> <- v])
        ]
    );

ChartData chartData(list[str] labels, lrel[num x, num y] values...)
    = chartData(
        labels=labels,
        datasets=[chartDataSet(labels[i], values[i]) | i <- [0..size(labels)]]
    );

ChartData chartData(list[str] labels, lrel[num x , num y , num r] values...)
    = chartData(
        labels=labels,
        datasets=[chartDataSet(labels[i], values[i]) | i <- [0..size(labels)]]
    );    

ChartData chartData(list[str] labels, rel[num x, num y] values...)
    = chartData(
        labels=labels,
        datasets=[chartDataSet(labels[i], values[i]) | i <- [0..size(labels)]]
    );

ChartData chartData(list[str] labels, rel[num x, num y, num r] values...)
    = chartData(
        labels=labels,
        datasets=[chartDataSet(labels[i], values[i]) | i <- [0..size(labels)]]
    );

ChartData chartData(list[str] setLabels, lrel[str label, num val] values...)
    = chartData(
        // first merge the label sets, while keeping the order as much as possible
        labels=labels, 
        // now sort the datasets accordingly, missing data is represented by `0`
        datasets=[chartDataSet([*(values[i][l]?[0]) | l <- labels], label=setLabels[i]) | i <- [0..size(setLabels)]]
    )
    when list[str] labels := ([] | (l in it) ? it : it + l | r <- values, l <- r<0>)
    ;

ChartData chartData(list[str] setLabels, rel[str label, num val] values...)
    = chartData(
        // first merge the label sets, while keeping the order as much as possible
        labels=labels, 
        // now sort the datasets accordingly, missing data is represented by `0`
        datasets=[chartDataSet([*(values[i][l]?{0}) | l <- labels], label=setLabels[i]) | i <- [0..size(setLabels)]]
    )
    when list[str] labels := ([] | (l in it) ? it : it + l | r <- values, l <- r<0>)
    ;

ChartData chartData(list[str] labels, list[num] values...)
    = chartData(
        labels=labels,
        datasets=[chartDataSet(v) | v <- values]
    );

ChartData chartData(str label, lrel[num x, num y] values)
    = chartData(
        datasets=[
            chartDataSet(label, values)
        ]
    );

ChartData chartData(str label, map[num x, num y] values)
    = chartData(
        datasets=[
            chartDataSet(label, values)
        ]
    );

ChartData chartData(str label, lrel[num x, num y, num r] values)
    = chartData(
        datasets=[
            chartDataSet(label, values)
        ]
    );    

ChartData chartData(str label, rel[num x, num y] values)
    = chartData(
        datasets=[
            chartDataSet(label, values)
        ]
    );

ChartData chartData(str label, rel[num x, num y, num r] values)
    = chartData(
        datasets=[
            chartDataSet(label, values)
        ]
    );
    
@synopsis{Toplevel chart structure}    
data Chart 
    = chart(
        ChartType \type = scatter(),
        ChartOptions options = chartOptions(),
        ChartData \data = chartData()
    );

@synopsis{Wrapper for a set of datasets, each with a label}
data ChartData 
    = chartData(
        list[str]  labels=[],
        list[ChartDataSet] datasets = []
    );

@synopsis{A dataset is a list of values to chart, with styling properties.}
@description{
The `data` field is a list of supported values, of which the constraints
are not expressible by data types. These are currently supported:

* ((ChartDataPoint)), with an without a `r`adius
* `num`, but within `double` precision (!) and no `rat`
}
data ChartDataSet(
        str label="",
        list[str] backgroundColor=[],
        list[str] borderColor=[],
        list[str] color=[]
    )
    = chartDataSet(list[value] \data)
    ;

@synopsis{A data point is one of the types of values in a ChartDataSet}
data ChartDataPoint
    = point(num x, num y, num r = 0);

data ChartType
    = scatter()
    | bar()
    | bubble()
    | line()
    | polarArea()
    | radar()
    | pie()
    | doughnut()
    ;

data ChartOptions  
    = chartOptions(
        bool responsive=true,
        bool animations=true,
        ChartPlugins plugins = chartPlugins()  
    );

data ChartPlugins
    = chartPlugins(
        ChartTitle title = chartTitle(),
        ChartLegend legend = chartLegend(),
        ChartColors colors = chartColors(),
        ChartAutoColors autocolors = chartAutoColors()
    );

data ChartAutoColors
    = chartAutoColors(
        ChartAutoColorMode \mode = \data()
    );

data ChartAutoColorMode 
    = \data()
    | \dataset()
    ;

data ChartLegend   
    = chartLegend(
        LegendPosition position = top(),
        bool display=true
    );

data LegendPosition
    = \top()
    | \bottom()
    | \left()
    | \right()
    ;

data ChartTitle
    = chartTitle(
        str text="",
        bool display = true
    );

data ChartColors
    = chartColors(
        bool enabled = true
    );

@synopsis{Utility function that constructs a Chart from ChartData and a given Chart type and a title.}
@description{
A chart has a typical default layout that we can reuse for all kinds of chart types. This function
provides the template and immediately instantiates the client and the server to start displaying the chart
in a browser.
}
Response(Request) chartServer(ChartData theData, ChartType \type=\bar(), str title="Chart", ChartAutoColorMode colorMode=\data(), bool legend=true, bool animations=false)
    = chartServer(
        chart(
            \type=\type,
            \data=theData,
            options=chartOptions(
                responsive=true,
                animations=animations, 
                plugins=chartPlugins(
                    legend=chartLegend(
                        position=top(),
                        display=legend
                    ),
                    title=chartTitle(
                        display=true,
                        text=title
                    ),
                    colors=chartColors(
                        enabled=true
                    ),
                    autocolors=chartAutoColors(
                        mode=colorMode
                    )
                ) 
            )
        )
    );

@synopsis{this is the main server generator for any chart value}
@description{
Given a Chart value this server captures the value and serves it
as a JSON value to the HTML client generated by ((vis::Charts::plotHTML)).
}
Response (Request) chartServer(Chart ch) {
    Response reply(get(/^\/chart/)) {
        return response(ch);
    }

    // returns the main page that also contains the callbacks for retrieving data and configuration
    default Response reply(get(_)) {
        return response(writeHTMLString(plotHTML()));
    }

    return reply;
}

@synopsis{default HTML wrapper for a chart}
private HTMLElement plotHTML()
    = html([
        div([ // put div here instead of `head` to work around issue
            script([], src="https://cdn.jsdelivr.net/npm/chart.js"),
            script([], src="https://cdn.jsdelivr.net/npm/chartjs-plugin-autocolors"),
            script([], src="C:/Users/20214192/sqm/vis.js")
        ]),
        body([
            div([
                canvas([],id="visualization")
            ]),
            script([
                \data(
                    "var container = document.getElementById(\'visualization\');
                    'const autocolors = window[\'chartjs-plugin-autocolors\'];
                    'Chart.register(autocolors);
                    'fetch(\'/chart\').then(resp =\> resp.json()).then(chart =\> {
                    '   new Chart(container, chart);   
                    '})
                    '")
            ], \type="text/javascript")
        ], style="position: fixed; top:50%; left:50%; transform: translate(-50%, -50%); width:min(75%,800px);")
    ]);