-- ============================================================
-- PROYECTO: Análisis de Ventas E-commerce
-- Autor: Eugenio Vivani
-- Herramienta: MySQL Workbench
-- Descripción: Base de datos de ventas con análisis exploratorio
-- ============================================================

-- -----------------------------------------------------
-- CREACIÓN DE BASE DE DATOS
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS ecommerce_ventas;
USE ecommerce_ventas;

-- -----------------------------------------------------
-- TABLAS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS categoria (
  id        INT NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS producto (
  id            INT NOT NULL AUTO_INCREMENT,
  nombre        VARCHAR(100) NOT NULL,
  categoria_id  INT NOT NULL,
  precio        DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE IF NOT EXISTS cliente (
  id        INT NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(100) NOT NULL,
  ciudad    VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS venta (
  id          INT NOT NULL AUTO_INCREMENT,
  cliente_id  INT NOT NULL,
  fecha       DATE NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS detalle_venta (
  id          INT NOT NULL AUTO_INCREMENT,
  venta_id    INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad    INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (venta_id) REFERENCES venta(id),
  FOREIGN KEY (producto_id) REFERENCES producto(id)
);

-- -----------------------------------------------------
-- DATOS DE EJEMPLO
-- -----------------------------------------------------

INSERT INTO categoria (nombre) VALUES
  ('Electrónica'),
  ('Ropa'),
  ('Hogar'),
  ('Deportes'),
  ('Libros');

INSERT INTO producto (nombre, categoria_id, precio) VALUES
  ('Notebook Lenovo',     1, 850.00),
  ('Auriculares Sony',    1, 120.00),
  ('Zapatillas Nike',     2,  95.00),
  ('Remera Adidas',       2,  35.00),
  ('Silla Ergonómica',    3, 310.00),
  ('Lámpara LED',         3,  25.00),
  ('Pelota de Fútbol',    4,  40.00),
  ('Mancuernas 10kg',     4,  60.00),
  ('El Principito',       5,  12.00),
  ('Atomic Habits',       5,  18.00);

INSERT INTO cliente (nombre, ciudad) VALUES
  ('Ana Rodríguez',   'Buenos Aires'),
  ('Martín López',    'Córdoba'),
  ('Sofía García',    'Rosario'),
  ('Lucas Martínez',  'Buenos Aires'),
  ('Valentina Torres','Mendoza'),
  ('Tomás Fernández', 'La Plata'),
  ('Camila Pérez',    'Buenos Aires'),
  ('Nicolás Díaz',    'Córdoba');

INSERT INTO venta (cliente_id, fecha) VALUES
  (1, '2024-01-05'),
  (2, '2024-01-12'),
  (3, '2024-02-03'),
  (4, '2024-02-18'),
  (5, '2024-03-07'),
  (6, '2024-03-22'),
  (7, '2024-04-10'),
  (8, '2024-04-25'),
  (1, '2024-05-01'),
  (3, '2024-05-15'),
  (2, '2024-06-08'),
  (4, '2024-06-20');

INSERT INTO detalle_venta (venta_id, producto_id, cantidad) VALUES
  (1,  1, 1),
  (1,  2, 2),
  (2,  3, 1),
  (2,  4, 3),
  (3,  5, 1),
  (3,  6, 2),
  (4,  7, 2),
  (4,  8, 1),
  (5,  9, 3),
  (5, 10, 2),
  (6,  1, 1),
  (6,  3, 1),
  (7,  2, 1),
  (7,  4, 2),
  (8,  5, 1),
  (8,  6, 3),
  (9,  7, 1),
  (9,  8, 2),
  (10, 9, 4),
  (10,10, 1),
  (11, 1, 1),
  (11, 2, 1),
  (12, 3, 2),
  (12, 4, 1);

-- ============================================================
-- ANÁLISIS / QUERIES
-- ============================================================

-- -----------------------------------------------------
-- 1. Ingresos totales por venta
--    (precio unitario x cantidad sumado por venta)
-- -----------------------------------------------------
SELECT
  v.id                                          AS venta_id,
  v.fecha,
  c.nombre                                      AS cliente,
  SUM(p.precio * dv.cantidad)                   AS total_venta
FROM venta v
JOIN cliente c        ON c.id = v.cliente_id
JOIN detalle_venta dv ON dv.venta_id = v.id
JOIN producto p       ON p.id = dv.producto_id
GROUP BY v.id, v.fecha, c.nombre
ORDER BY v.fecha;

-- -----------------------------------------------------
-- 2. Top 5 productos más vendidos (por unidades)
-- -----------------------------------------------------
SELECT
  p.nombre                  AS producto,
  SUM(dv.cantidad)          AS unidades_vendidas
FROM detalle_venta dv
JOIN producto p ON p.id = dv.producto_id
GROUP BY p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;

-- -----------------------------------------------------
-- 3. Ingresos totales por categoría
-- -----------------------------------------------------
SELECT
  cat.nombre                        AS categoria,
  SUM(p.precio * dv.cantidad)       AS ingresos_totales
FROM detalle_venta dv
JOIN producto p    ON p.id = dv.producto_id
JOIN categoria cat ON cat.id = p.categoria_id
GROUP BY cat.nombre
ORDER BY ingresos_totales DESC;

-- -----------------------------------------------------
-- 4. Clientes con mayor gasto total
-- -----------------------------------------------------
SELECT
  c.nombre                          AS cliente,
  c.ciudad,
  SUM(p.precio * dv.cantidad)       AS gasto_total
FROM venta v
JOIN cliente c        ON c.id = v.cliente_id
JOIN detalle_venta dv ON dv.venta_id = v.id
JOIN producto p       ON p.id = dv.producto_id
GROUP BY c.id, c.nombre, c.ciudad
ORDER BY gasto_total DESC;

-- -----------------------------------------------------
-- 5. Ventas por mes (tendencia mensual)
-- -----------------------------------------------------
SELECT
  DATE_FORMAT(v.fecha, '%Y-%m')     AS mes,
  COUNT(DISTINCT v.id)              AS cantidad_ventas,
  SUM(p.precio * dv.cantidad)       AS ingresos_mes
FROM venta v
JOIN detalle_venta dv ON dv.venta_id = v.id
JOIN producto p       ON p.id = dv.producto_id
GROUP BY mes
ORDER BY mes;

-- -----------------------------------------------------
-- 6. Ciudades con más ventas
-- -----------------------------------------------------
SELECT
  c.ciudad,
  COUNT(DISTINCT v.id)              AS cantidad_ventas,
  SUM(p.precio * dv.cantidad)       AS ingresos_totales
FROM venta v
JOIN cliente c        ON c.id = v.cliente_id
JOIN detalle_venta dv ON dv.venta_id = v.id
JOIN producto p       ON p.id = dv.producto_id
GROUP BY c.ciudad
ORDER BY ingresos_totales DESC;

-- -----------------------------------------------------
-- 7. Promedio de gasto por cliente
-- -----------------------------------------------------
SELECT
  AVG(gasto_total) AS gasto_promedio_cliente
FROM (
  SELECT
    v.cliente_id,
    SUM(p.precio * dv.cantidad) AS gasto_total
  FROM venta v
  JOIN detalle_venta dv ON dv.venta_id = v.id
  JOIN producto p       ON p.id = dv.producto_id
  GROUP BY v.cliente_id
) subquery;

-- -----------------------------------------------------
-- 8. Clientes que compraron más de una vez (recurrentes)
-- -----------------------------------------------------
SELECT
  c.nombre          AS cliente,
  COUNT(v.id)       AS cantidad_compras
FROM venta v
JOIN cliente c ON c.id = v.cliente_id
GROUP BY c.id, c.nombre
HAVING COUNT(v.id) > 1
ORDER BY cantidad_compras DESC;
