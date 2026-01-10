CREATE TABLE usuarios (id_u int primary key, 
						nombre varchar (50), 
						tipo_usu char (1),
						ape varchar (50));
create table roles (id_rol int primary key, 
					tipo_rol varchar(50));


create table sistemas_digitales (id_usuario int primary key,
								tel varchar(100),
								contrasena varchar(20));
								


create table sistemas_internos (usu int primary key, 
								confirmar_asistencia boolean);	

								
create table empleados (id_u int primary key, usu int ,correo varchar(50), direccion varchar(30),
foreign key (id_u) references usuarios (id_u),
foreign key (usu) references sistemas_internos(usu));


create table tienen (id_u int,
					id_rol int,
					
					primary key(id_u, id_rol),
					
					foreign key (id_u) references usuarios (id_u),
					foreign key (id_rol) references roles (id_rol));



								
create table app_movil(id_usuario int primary key,
						ubi_consultorio varchar(50),
						medicos_disponibles varchar(25),
foreign key (id_usuario) references sistemas_digitales (id_usuario));


create table pags_web(id_usuario int primary key,
						cartilla_medica varchar(100),
						avisos varchar (50),
						horarios varchar(10),
foreign key (id_usuario) references sistemas_digitales (id_usuario));


create table formularios (dni_form int primary key,
							id_usuario int, 
							nombre varchar(20),
							mensaje text,
							fec_form date,
foreign key (id_usuario) references pags_web (id_usuario));


create table acceden (id_usuario int, id_u int,
						primary key (id_usuario, id_u),
						foreign key (id_usuario) references sistemas_digitales(id_usuario),
						foreign key (id_u) references usuarios (id_u));

	

create table medicos(id_u int primary key,
					nro_matricula int, 
					usu int,
					id_usuario int,
					especializacion varchar(30),
foreign key (id_u) references empleados(id_u),
foreign key (usu) references sistemas_internos(usu),
foreign key (id_usuario) references app_movil (id_usuario));

create table afiliados (
    id_u int primary key,
    id_medico int,
    nro_plan int,
    id_usuario int,
    edad int,
    hist_atencion varchar(100),
    tipo_aviso varchar(100),
    foreign key (id_usuario) references app_movil (id_usuario),
    foreign key (id_u) references usuarios (id_u),
    foreign key (id_medico) references medicos (id_u)
);







create table medicamentos (id_med int primary key,
							id_u int,
							nom_med varchar (100),
							precio_med float,
							stock int,
foreign key (id_u) references afiliados (id_u));
						

create table farmacias (nro_farm int primary key, 
						nom_farm varchar(100), 
						loc_farm varchar(100));


create table venden (id_med int,
					nro_farm int,
primary key(id_med,nro_farm),
foreign key (id_med) references medicamentos (id_med),
foreign key (nro_farm) references farmacias (nro_farm));


create table turnos (nro_turno int primary key, 
					id_afiliado int,
					id_medico int,
					usu int,
					id_usuario int,
					fec_turno date,
					profesional varchar(100),
					horario varchar(20),
foreign key (id_medico) references medicos (id_u),
foreign key (id_afiliado) references afiliados (id_u),
foreign key (id_usuario) references app_movil (id_usuario));



create table enfermeros (id_u int primary key,
foreign key (id_u) references empleados(id_u));

create table pacientes (nro_pac int primary key,
						nom_pac varchar(100),
						dni_pac int,
						id_u int,
foreign key (id_u) references medicos (id_u));

create table consultas (nro_cons int primary key,
						nro_pac int,
						usu int,
						razon_cons varchar(100),
						fec_cons date,
foreign key (nro_pac) references pacientes (nro_pac),
foreign key (usu) references sistemas_internos (usu));

create table facturas (num_fac int primary key,
						nro_pac int,
						nro_cons int,
						fec_fac date,
						imp_fac float,
foreign key (nro_pac) references pacientes (nro_pac),
foreign key (nro_cons) references consultas (nro_cons));

create table jefes_de_area (id_u int primary key,
foreign key (id_u) references empleados (id_u));

create table atencion_al_publico(id_u int primary key,
foreign key (id_u) references empleados (id_u));

create table agendas_turnos (id_agenda int, 
						usu int primary key,
						id_u int,
						fec_apertura date,
						fec_cierre date,
						capacidad_agenda int,
foreign key (id_u) references medicos (id_u),
foreign key (usu) references sistemas_internos (usu));

create table modifican (id_u int, usu int,
primary key(id_u,usu),
foreign key (id_u) references atencion_al_publico (id_u),
foreign key (usu) references agendas_turnos (usu));

create table superintendencias (id_super int primary key, 
								jurisdiccion varchar(100),
								direccion_super varchar(100),
								correo_super VARCHAR(100));

create table reportes (nro_rep int,
						usu int primary key,
						id_u int,
						id_super int,
						tipo_rep varchar(100),
foreign key (id_u) references jefes_de_area (id_u),
foreign key (usu) references sistemas_internos (usu),
foreign key (id_super) references superintendencias (id_super));


create table laboratorios (id_lab int primary key,
							ubi_lab varchar(100));

create table estudios (nro_est int, 
						usu int primary key,
						id_lab int,
						fec_est date,
						tipo_est varchar(100),
foreign key (usu) references sistemas_internos (usu),
foreign key (id_lab) references laboratorios (id_lab))



