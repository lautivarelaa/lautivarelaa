
SELECT C.ID_CLI, C.NOM_CLI, SUM(F.IMP_FAC) AS TOTAL_GENERADO FROM CLIENTES C JOIN FACTURAS F ON C.ID_CLI = F.ID_CLI WHERE F.IMP_FAC > 20000 GROUP BY C.NOM_CLI, C.ID_CLI


select c.nom_cli, c.id_cli from clientes c join facturas f on c.id_cli = f.id_cli group by c.nom_cli, c.id_cli having sum(f.imp_fac) > (select avg(f.imp_fac) from facturas f)


select r.*, max(f.imp_fac) from facturas f join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by r.cod_rub, r.nom_rub order by max(f.imp_fac)


select c.id_cli, count(*) as cuantos from clientes c join facturas f on c.id_cli = f.id_cli join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by c.id_cli having count(*) > 2


select f.fec_fac, sum(imp_fac) as evolucion from facturas f group by f.fec_fac order by f.fec_fac desc 


select c.nom_cli, max(f.imp_fac) as mayor_gasto from clientes c join facturas f on f.id_cli = c.id_cli group by c.id_cli,c.nom_cli order by max(f.imp_fac) desc limit 1


select c.id_cli, avg(f.imp_fac) as promedio_gasto from clientes c join facturas f on c.id_cli = f.id_cli group by c.id_cli


select a.cod_art, sum(d.cant_det) as mas_vendidos from clientes c join facturas f on f.id_cli = c.id_cli join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by a.cod_art order by sum(d.cant_det) desc limit 3


select f.num_fac from facturas f join detalles d on f.num_fac = d.num_fac join articulos a on a.cod_art = d.cod_art group by f.num_fac having count(*) >= 3


select r.nom_rub, sum(d.cant_det * a.precio_art) as total_facturado from clientes c join facturas f on c.id_cli = f.id_cli join detalles d on f.num_fac = d.num_fac join articulos a on d.cod_art = a.cod_art join rubros r on r.cod_rub = a.cod_rub group by r.nom_rub 