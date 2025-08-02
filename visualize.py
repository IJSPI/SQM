import plotly.express as px
import pandas as pd

col_names = ["name",
            "parent",
            "density",
            "complexity",
            "size"]
df = pd.read_csv('res.csv', names=col_names)
dn = df.loc[df['parent'] == "junit"]

fig = px.scatter(dn, x="complexity", y="size",
	         size="density", color="density",
                 hover_name="name", log_x=True, size_max=60)
fig.show()