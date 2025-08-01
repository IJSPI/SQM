import plotly.express as px
import pandas as pd

col_names = ["name",
            "parent",
            "density",
            "complexity",
            "size"]
df = pd.read_csv('res.csv', names=col_names)

fig = px.treemap(
    names = df["name"],
    parents = df["parent"]
)

fig.update_traces(root_color="lightgrey")
fig.update_layout(margin = dict(t=50, l=25, r=25, b=25))
fig.show()