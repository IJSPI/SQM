#Using Plotly to generate the circles
import dash
from dash import html, dcc, Input, Output
import plotly.express as px
import pandas as pd

# Dash app maken
app = dash.Dash(__name__)
col_names = ["name",
            "parent",
            "density",
            "complexity",
            "size"]
df = pd.read_csv("res.csv", names=col_names)

# Functie die een willekeurige dataset maakt
def create_new_dataset(parName):
    if parName in ["database", "junit", "tools",  "language"]:
        return df.loc[df["parent"] == parName]
    else:
        return df


# Layout van de app
app.layout = html.Div([
    html.H1("Software Quality BubbleChart", style={"textAlign": "center"}),

    dcc.Graph(id="bubblechart-plot"),

    html.Button("General Overview", id='general-button', n_clicks=0, style={"marginTop": "20px", "marginRight": "20px", "marginLeft": "500px"}),
    html.Button("Database View", id='database-button', n_clicks=0, style={"marginTop": "20px", "marginRight": "20px"}),
    html.Button("JUnit View", id='junit-button', n_clicks=0, style={"marginTop": "20px", "marginRight": "20px"}),
    html.Button("Tools View", id='tools-button', n_clicks=0, style={"marginTop": "20px", "marginRight": "20px"}),
    html.Button("Language View", id='language-button', n_clicks=0, style={"marginTop": "20px", "marginRight": "20px"}),

    html.Div(id="output-info", style={"marginTop": "10px", "fontStyle": "italic"})
])

# Callback: voer uit bij klik op button
@app.callback(
    Output('bubblechart-plot', 'figure'),
    Output('output-info', 'children'),
    Input('general-button', 'n_clicks'),
    Input('database-button', 'n_clicks'),
    Input('junit-button', 'n_clicks'),
    Input('tools-button', 'n_clicks'),
    Input('language-button', 'n_clicks')
)
def update_plot(n_gen, n_dat, n_junit, n_tools, n_lan):
    ctx = dash.callback_context

    if not ctx.triggered:
        raise dash.exceptions.PreventUpdate
    
    button_id = ctx.triggered[0]["prop_id"].split(".")[0]

    if button_id == 'general-button':
        select = "general"
    elif button_id == 'database-button':
        select = "database"
    elif button_id == 'junit-button':
        select = "junit"
    elif button_id == 'tools-button':
        select = "tools"
    elif button_id == 'language-button':
        select = "language"
    else:
        select = "general"

    df = create_new_dataset(select)
    fig = px.scatter(df, 
                     x="complexity", y="size",
                     size="density", color="density",
                     hover_name="name", log_x=True, size_max=60)
    info = f"Amount of Points in BubbleChart: {len(df)}"
    return fig, info

# App starten
if __name__ == "__main__":
    app.run(debug=True)