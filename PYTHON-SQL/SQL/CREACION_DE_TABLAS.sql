-- Tabla de Rubros
CREATE TABLE Rubros (
    cod_rub INT PRIMARY KEY,
    nom_rub VARCHAR(255)
);

-- Tabla de Art�culos
CREATE TABLE Articulos (
    cod_art INT PRIMARY KEY,
    cod_rub INT,
    descrip_art VARCHAR(255),
    stock_art INT,
    precio_art DECIMAL(10, 2),
    FOREIGN KEY (cod_rub) REFERENCES Rubros(cod_rub)
);

-- Tabla de Clientes
CREATE TABLE Clientes (
    id_cli INT PRIMARY KEY,
    nom_cli VARCHAR(255),
    loc_cli VARCHAR(255),
    email_cli VARCHAR(255)
);

-- Tabla de Facturas
CREATE TABLE Facturas (
    num_fac INT PRIMARY KEY,
    fec_fac DATE,
    imp_fac DECIMAL(10, 2),
    id_cli INT,
    FOREIGN KEY (id_cli) REFERENCES Clientes(id_cli)
);

-- Tabla de Detalles
CREATE TABLE Detalles (
    num_fac INT,
    cod_art INT,
    cant_det INT,
    PRIMARY KEY (num_fac, cod_art),
    FOREIGN KEY (num_fac) REFERENCES Facturas(num_fac),
    FOREIGN KEY (cod_art) REFERENCES Articulos(cod_art)
);