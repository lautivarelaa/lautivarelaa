import pandas as pd
import psycopg2
connect=psycopg2.connect(
    host="localhost",
    database="proyecto",
    user="postgres",
    password="bocayoteamo2005")


cursor=connect.cursor()



df_rubros=pd.read_csv("rubros.csv")
df_articulos=pd.read_csv("articulos.csv")
df_clientes=pd.read_csv("clientes.csv")
df_facturas=pd.read_csv("facturas.csv")
df_detalles=pd.read_csv("detalles.csv")

df_rubros = df_rubros[["cod_rub","nom_rub"]].drop_duplicates()
df_articulos = df_articulos[["cod_art","cod_rub","descrip_art","stock_art","precio_art"]].drop_duplicates()
df_clientes = df_clientes[["id_cli","nom_cli","loc_cli","email_cli"]].drop_duplicates()
df_facturas = df_facturas[["num_fac","fec_fac","imp_fac","id_cli"]].drop_duplicates()
df_detalles = df_detalles[["num_fac","cod_art","cant_det"]].drop_duplicates()

df_rubros.columns = df_rubros.columns.str.strip().str.lower()
df_articulos.columns=df_articulos.columns.str.strip().str.lower()
df_clientes.columns=df_clientes.columns.str.strip().str.lower()
df_facturas.columns=df_facturas.columns.str.strip().str.lower()
df_detalles.columns=df_detalles.columns.str.strip().str.lower()

for _, row in df_rubros.iterrows():
   cursor.execute(
       "INSERT INTO rubros VALUES (%s, %s)",
        (row["cod_rub"], row["nom_rub"])
    )

for _, row in df_articulos.iterrows():
   cursor.execute(
        "insert into articulos values (%s, %s, %s, %s, %s)",
        (row["cod_art"], row["cod_rub"], row["descrip_art"], row["stock_art"], row["precio_art"])
    )

for _, row in df_clientes.iterrows():
    cursor.execute(
        "insert into clientes values (%s, %s, %s, %s)",
        (row["id_cli"], row["nom_cli"], row["loc_cli"], row["email_cli"])
    )

for _,row in df_facturas.iterrows():
    cursor.execute(
        "insert into facturas values (%s,%s,%s,%s)",
        (row["num_fac"], row["fec_fac"], row["imp_fac"], row["id_cli"])
    )

for _,row in df_detalles.iterrows():
    cursor.execute(
        "insert into detalles values(%s,%s,%s)",
        (int(row["num_fac"]), int(row["cod_art"]), int(row["cant_det"]))
    )
connect.commit()
