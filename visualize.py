import plotly.express as px
import pandas as pd

col_names = ["name",
            "parent",
            "density",
            "complexity",
            "size"]
df = pd.read_csv('res.csv', names=col_names)
dn = df.loc[df['parent'] == "junit"]
classes = dn["name"].tolist()
for i in range(0, len(df.index)):
    row = df.iloc[[i]]
    currParent = df['parent'].loc[df.index[i]]
    if (currParent in classes and i % 5 == 0):
        dn = pd.concat([dn, row], ignore_index=True)

fig = px.treemap(
    names = dn["name"],
    parents = dn["parent"],
    values = dn["density"],
    color = dn["density"],
    title = "Visualization of Cyclomatic Complexity Density"
)

fig.update_traces(root_color="lightgrey", marker=dict(cornerradius=5))
fig.update_layout(margin = dict(t=50, l=25, r=25, b=25))
fig.show()