--1) Mostrar los datos de distintos afiliados que hayan retirado medicamentos 
--de mas de 5000 pesos que hayan sido vendidos por farmacias que no lleve 'P', sea minúscula o mayúscula

select distinct(u.*),a.*, m.precio_med, f.nom_farm
from afiliados a 
join medicamentos m on a.id_u = m.id_u
join usuarios u on u.id_u=a.id_u
join venden v on v.id_med=m.id_med
join farmacias f on v.nro_farm = v.nro_farm
where m.precio_med > 1500
and u.tipo_usu ilike 'a'
and f.nom_farm not in (select f2.nom_farm
						from farmacias f2
						where f2.nom_farm ilike '%p%')


--2) Mostrar los datos de los afiliados que hayan retirado al menos 1 medicamento 

select u.*
from afiliados a 
join medicamentos m on a.id_u = m.id_u
join usuarios u on u.id_u=a.id_u
where u.tipo_usu ilike 'a'
group by u.id_u,u.nombre,u.ape,u.tipo_usu
having count(distinct m.id_med) >0


--3) Mostrar los datos de los pacientes y la factura mas cara mas cara que hayan pagado, que se haya atendido entre enero y julio del 2025 y 
--que su DNI sea entre 40 y 47 miollones
select distinct (p.*), max(f.imp_fac) as factura_mas_cara
from pacientes p
join facturas f on f.nro_pac = p.nro_pac
join consultas c on c.nro_pac = p.nro_pac
where c.fec_cons between '1/1/2025' and '31/7/2025'
and p.dni_pac in (select p2.dni_pac
					from pacientes p2
					where p2.dni_pac between 46000000 and 470000000)
group by p.nro_pac, p.nom_pac, p.dni_pac,p.id_u 



--4)Mostrar los datos de los medicos de pediatria que atendieron a pacientes que tuvieron vomitos 
--y el maximo que llegaron a recaudar
select m.*, max(f.imp_fac)
from medicos m 
join pacientes p on m.id_u = p.id_u
join consultas c on c.nro_pac = p.nro_pac
join facturas f on p.nro_pac = f.nro_pac
and f.nro_cons = c.nro_cons
where c.razon_cons ilike 'vomitos'
and m.especializacion ilike'pediatría'
group by m.id_u,m.nro_matricula,m.usu,m.id_usuario,m.especializacion



--5)Mostrar los datos de las superintendencias y el id del jefe de area que haya recibido recibido reportes de tipo adminitrativo, 
--ademas la jurisdiccion de estas no debe empezar por la letra 'a' y mostrar en la misma lista la cantidad que cumplen con esta regla
select s.*, j.id_u, count(r.nro_rep)
from superintendencias s 
join reportes r on s.id_super = r.id_super
join jefes_de_area j on j.id_u = r.id_u
where r.tipo_rep ilike 'administrativos'
and s.jurisdiccion not in (select s2.jurisdiccion
							from superintendencias s2
							where s2.jurisdiccion ilike 'a%')

group by s.id_super,s.jurisdiccion,s.direccion_super,s.correo_super,j.id_u,r.tipo_rep

WITH superintendencias_filtradas AS (
    SELECT s.*,j.id_u AS id_jefe_area,COUNT(r.nro_rep) AS cantidad_reportes_admin
    FROM superintendencias s
    JOIN reportes r ON s.id_super = r.id_super
    JOIN jefes_de_area j ON j.id_u = r.id_u
    WHERE r.tipo_rep ILIKE 'administrativo%'
      AND s.jurisdiccion NOT ILIKE 'a%'
    GROUP BY s.id_super, s.jurisdiccion, s.direccion_super, s.correo_super, j.id_u
)
SELECT 
id_super,jurisdiccion,direccion_super,correo_super,id_jefe_area,cantidad_reportes_admin
FROM superintendencias_filtradas

UNION ALL

SELECT NULL AS id_super,'total_superintendencias' AS jurisdiccion,NULL AS direccion_super,
NULL AS correo_super,NULL AS id_jefe_area,COUNT(*) AS cantidad_reportes_admin
FROM superintendencias_filtradas;


--6)mostrar cuantos reportes fueron exportados 
--a la jurisdiccion 'Kalmar'

select s.jurisdiccion,count(r.nro_rep)
from reportes r 
join superintendencias s on r.id_super = s.id_super
group by s.jurisdiccion
having  s.jurisdiccion ILIKE 'Kalmar'




--7)Mostrar total que facturaron todos los medicos y sus datos
select sum(f.imp_fac), m.id_u as id_medico, u.nombre, u.ape,u.tipo_usu
from usuarios u 
left join tienen t on t.id_u = u.id_u
left join roles r on r.id_rol = t.id_rol
left join empleados e on e.id_u = u.id_u
left join medicos m on e.id_u = m.id_u
left join pacientes p on p.id_u = m.id_u
left join consultas c on c.nro_pac = p.nro_pac
left join facturas f on f.nro_cons = c.nro_cons
where c.fec_cons between '1/6/2025' and '31/12/2025'
and u.tipo_usu ilike 'e'
and r.tipo_rol ilike 'medico'
group by m.id_u,u.nombre, u.ape,u.tipo_usu
order by sum(f.imp_fac) desc

--8) Mostrar el nombre, apellido, numero de plan, el id y la edad de los afiliados que NO retiraron medicamentos  
--de tipo ibuprofeno. Los medicamentos que hayan retirado deben tener un stock mayor a 1000
select u.nombre,u.ape,a.id_u,a.nro_plan,a.edad
from usuarios u
join afiliados a on a.id_u = u.id_u
join medicamentos m on m.id_u = a.id_u
join venden v on m.id_med = v.id_med
join farmacias f on f.nro_farm = v.nro_farm
where u.tipo_usu ilike 'a'
and m.nom_med not in (select m2.nom_med
						from medicamentos m2
						where m2.nom_med ilike 'ibuprofeno') 
and m.stock>1000

--9) Mostrar el nro de plan de los afiliados que sacaron un turno entre julio y diciembre del 2025
--cuya edad sea mayor a la edad promedio
select u.nombre, a.nro_plan
from afiliados a 
join usuarios u on u.id_u = a.id_u
join turnos t on t.id_afiliado = a.id_u
where t.fec_turno between '1/7/2025' and '31/12/2025'
and u.tipo_usu ilike 'a'
and a.edad > (select avg (a2.edad)
				from afiliados a2)

--10) Mostrar los datos de los laboratorios que 
--tengan estudios de tipo 'analisis de sangre' y 'ecodopler' entre el 2023 y el 2024. 
(select l.*
from laboratorios l 
join estudios e on l.id_lab = e.id_lab
where e.fec_est between '1/1/2023' and '31/12/2024'
and e.tipo_est ilike 'ecodoppler')

intersect

(
select l.*
from laboratorios l 
join estudios e on l.id_lab = e.id_lab
where e.fec_est between '1/1/2023' and '31/12/2024'
and e.tipo_est ilike 'analisis de sangre'
)