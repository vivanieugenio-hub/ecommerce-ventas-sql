# 📊 Análisis de Ventas E-commerce — SQL + Power BI

Proyecto de análisis de datos sobre una base de ventas de e-commerce simulada.
Desarrollado como práctica de SQL y visualización de datos.

---

## 🛠️ Herramientas utilizadas

- **MySQL Workbench** — modelado y consultas SQL
- **Power BI** — visualización de resultados

---

## 🗄️ Estructura de la base de datos

La base de datos `ecommerce_ventas` contiene 5 tablas relacionadas:

| Tabla | Descripción |
|---|---|
| `categoria` | Categorías de productos |
| `producto` | Catálogo de productos con precio |
| `cliente` | Clientes registrados con ciudad |
| `venta` | Cabecera de cada venta (fecha, cliente) |
| `detalle_venta` | Líneas de cada venta (producto, cantidad) |

---

## 🔍 Análisis realizados

1. **Ingresos totales por venta** — JOIN de 4 tablas con cálculo de total
2. **Top 5 productos más vendidos** — ranking por unidades
3. **Ingresos por categoría** — agrupación con GROUP BY
4. **Clientes con mayor gasto** — ranking de clientes
5. **Tendencia mensual de ventas** — evolución mes a mes
6. **Ciudades con más ventas** — distribución geográfica
7. **Gasto promedio por cliente** — subconsulta
8. **Clientes recurrentes** — filtrado con HAVING

---

## ▶️ Cómo usar este proyecto

1. Abrí MySQL Workbench
2. Ejecutá el archivo `ecommerce_ventas.sql` completo
3. Las queries de análisis están al final del archivo, listas para correr

---

## 👤 Autor

**Eugenio Vivani**
[LinkedIn](https://www.linkedin.com/in/eugenio-vivani)
[Ver dashboard en Looker Studio](https://datastudio.google.com/s/qojPKpX5PDk)
