import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
from IPython.display import display

connect=psycopg2.connect(
    host="localhost",
    database="proyecto",
    user="postgres",
    password="bocayoteamo2005"
)

#id y nombre de los clientes que hayan generado facturas por un importe mayor a 20000 en total.
query1="SELECT C.ID_CLI, C.NOM_CLI, SUM(F.IMP_FAC) AS TOTAL_GENERADO FROM CLIENTES C JOIN FACTURAS F ON C.ID_CLI = F.ID_CLI WHERE F.IMP_FAC > 20000 GROUP BY C.NOM_CLI, C.ID_CLI "
#nombre e id de los clientes que hayan generado facturas por un importe mayor al promedio de todas las facturas.
query2="select c.nom_cli, c.id_cli from clientes c join facturas f on c.id_cli = f.id_cli group by c.nom_cli, c.id_cli having sum(f.imp_fac) > (select avg(f.imp_fac) from facturas f)"
#nombre del rubro y el importe máximo facturado por ese rubro.
query3="select r.*, max(f.imp_fac) from facturas f join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by r.cod_rub, r.nom_rub order by max(f.imp_fac) desc"
#id de los clientes y la cantidad de rubros distintos que hayan comprado, mostrando solo aquellos clientes que hayan comprado más de 2 rubros distintos.
query4="select c.id_cli, count(*) as cant_rubros from clientes c join facturas f on c.id_cli = f.id_cli join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by c.id_cli having count(*) > 2"
#fecha de factura y la evolución del importe total facturado por fecha, mostrando solo las fechas en las que se hayan generado facturas.
query5="select f.fec_fac, sum(imp_fac) as evolucion from facturas f group by f.fec_fac order by f.fec_fac desc"
#nombre del cliente que haya generado la factura de mayor importe, mostrando el nombre del cliente y el importe de la factura.
query6="select c.nom_cli, max(f.imp_fac) as mayor_gasto from clientes c join facturas f on f.id_cli = c.id_cli group by c.id_cli,c.nom_cli order by max(f.imp_fac) desc limit 1"
#id del cliente y el promedio de gasto por factura.
query7="select c.id_cli, avg(f.imp_fac) as promedio_gasto from clientes c join facturas f on c.id_cli = f.id_cli group by c.id_cli"
#código del artículo y la cantidad total vendida de ese artículo, mostrando solo los 3 artículos más vendidos.
query8="select a.cod_art, sum(d.cant_det) as mas_vendidos from clientes c join facturas f on f.id_cli = c.id_cli join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by a.cod_art order by sum(d.cant_det) desc limit 3"
#número de factura y la cantidad de artículos distintos que se hayan vendido en esa factura, mostrando solo las facturas en las que se hayan vendido 3 o más artículos distintos.
query9="select f.num_fac from facturas f join detalles d on f.num_fac = d.num_fac join articulos a on a.cod_art = d.cod_art group by f.num_fac having count(*) >= 3"
#nombre del rubro y el importe total facturado por ese rubro.
query10="select r.nom_rub, sum(d.cant_det * a.precio_art) as total_facturado from clientes c join facturas f on c.id_cli = f.id_cli join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by r.nom_rub "

df = pd.read_sql(query1, connect)
df["total_generado"].plot(kind="hist")
plt.ticklabel_format(style='plain', axis='both')
plt.show()

df2= pd.read_sql(query2, connect) 
display(df2)

df3= pd.read_sql(query3,connect)
df3.plot(kind="bar", x="cod_rub", y="max")
plt.ticklabel_format(style='plain', axis='y')
plt.show()

df4= pd.read_sql(query4, connect)
display(df4)

df5=pd.read_sql(query5, connect)
df5.plot(kind="bar", x="fec_fac", y="evolucion")
plt.ticklabel_format(style='plain', axis='y')
plt.show()

df6=pd.read_sql(query6, connect)
display(df6)

df7=pd.read_sql(query7, connect)
df7.plot(kind="bar", x="id_cli", y="promedio_gasto")
plt.ticklabel_format(style='plain', axis='y')
plt.show()

df8=pd.read_sql(query8, connect)
display(df8)

df9=pd.read_sql(query9, connect)
display(df9)

df10=pd.read_sql(query10,connect)
df10.plot(kind="bar", x="nom_rub", y="total_facturado")
plt.ticklabel_format(style='plain', axis='y')
plt.show()
connect.close()