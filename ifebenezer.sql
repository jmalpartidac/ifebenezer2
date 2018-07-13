-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-07-2018 a las 23:52:40
-- Versión del servidor: 10.1.30-MariaDB
-- Versión de PHP: 7.0.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ifebenezer`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AlmacenConsultar` (IN `xOpcion` INT, IN `xPeriodoInicio` VARCHAR(6), IN `xPeriodoFin` VARCHAR(6), IN `xValor01` DECIMAL(6,2), IN `xValor02` DECIMAL(6,2))  BEGIN
	DECLARE xTotal INT DEFAULT 0;
    DECLARE xClasA INT DEFAULT 0;
    DECLARE xClasB INT DEFAULT 0;
    DECLARE xClasC INT DEFAULT 0;
	IF xOpcion = 1 THEN	 -- CLASIFICACION POR PRECIO UNUITARIO
    
		DROP TEMPORARY TABLE IF EXISTS tmp_articulo;
        CREATE TEMPORARY TABLE tmp_articulo(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo (idarticulo, cantidad, preciounitario)
        SELECT 	idarticulo, 0, AVG(preciounitario)
        FROM 	articuloinventario
        WHERE 	periodo BETWEEN xPeriodoInicio AND xPeriodoFin
        group by idarticulo;
        
        INSERT INTO tmp_articulo (idarticulo, cantidad, preciounitario)
        SELECT 	A.idarticulo, 0, IF(preciocompraunitario IS NULL,0,preciocompraunitario)
        FROM 	articulo A
				LEFT JOIN (
					SELECT 	idarticulo,preciocompraunitario
                    FROM 	articuloxdocumento
                    WHERE 	CONCAT(YEAR(fechareg),IF(MONTH(fechareg)<10,'0',''),MONTH(fechareg)) BETWEEN xPeriodoInicio AND xPeriodoFin
                    GROUP BY
						idarticulo
                ) B ON A.idarticulo = B.idarticulo
        WHERE 	A.idarticulo NOT IN (
				SELECT 	idarticulo
				FROM 	articuloinventario
				WHERE 	periodo BETWEEN xPeriodoInicio AND xPeriodoFin
				group by idarticulo
        );
        
        
        
        
        DROP TEMPORARY TABLE IF EXISTS tmp_articulo2;
        CREATE TEMPORARY TABLE tmp_articulo2(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo2(idarticulo, cantidad, preciounitario)
        SELECT idarticulo, cantidad, preciounitario
        FROM  	tmp_articulo
        ORDER BY preciounitario DESC;
        
        SELECT COUNT(*) INTO xTotal FROM tmp_articulo;
        
        SET xClasA = xTotal * 0.15;
        SET xClasB = xTotal * 0.2;
        SET xClasA = IF(xClasA = 0, 1, xClasA);
        SET xClasB = IF(xClasB = 0, 1, xClasB);
        
        UPDATE tmp_articulo2
        SET 	clasificacion = 'A'
        WHERE 	indice <= xClasA;
        
        UPDATE tmp_articulo2
        SET 	clasificacion = 'B'
        WHERE 	indice > xClasA AND indice <= (xClasB + xClasA);
        
		UPDATE tmp_articulo2
		SET 	clasificacion = 'C'
        WHERE 	indice > (xClasB + xClasA);
        
        DELETE FROM reporte_clasificacion WHERE tipo = '1';
        INSERT INTO reporte_clasificacion(cantidad, preciounitario, valortotal, nombrearticulo, 
        clasificacion, tipo, idarticulo)
        SELECT 	0,
				A.preciounitario,
                0,
				B.articulo,
                A.clasificacion,
                '1', 
                A.idarticulo
        FROM 	tmp_articulo2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
                
        SELECT 	A.indice,
				A.preciounitario,
				B.articulo,
                A.clasificacion
        FROM 	tmp_articulo2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
        
    END IF;
    
    
    IF xOpcion = 2 THEN	 -- CLASIFICACION POR VALOR TOTAL
    
		DROP TEMPORARY TABLE IF EXISTS tmp_articulo;
        CREATE TEMPORARY TABLE tmp_articulo(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            valortotal DECIMAL(12,2) default 0,
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo (idarticulo, cantidad, preciounitario, valortotal)
        SELECT 	idarticulo, stock, AVG(preciounitario), stock * AVG(preciounitario)
        FROM 	articuloinventario
        WHERE 	periodo BETWEEN xPeriodoInicio AND xPeriodoFin
        group by idarticulo;
        
        INSERT INTO tmp_articulo (idarticulo, cantidad, preciounitario, valortotal)
        SELECT 	A.idarticulo, IF(A.stock IS NULL,0,A.stock), IF(preciocompraunitario IS NULL,0,preciocompraunitario),
				IF(A.stock IS NULL,0,A.stock) * IF(preciocompraunitario IS NULL,0,preciocompraunitario)
        FROM 	articulo A
				LEFT JOIN (
					SELECT 	idarticulo,preciocompraunitario
                    FROM 	articuloxdocumento
                    WHERE 	CONCAT(YEAR(fechareg),IF(MONTH(fechareg)<10,'0',''),MONTH(fechareg)) BETWEEN xPeriodoInicio AND xPeriodoFin
                    GROUP BY
						idarticulo
                ) B ON A.idarticulo = B.idarticulo
        WHERE 	A.idarticulo NOT IN (
				SELECT 	idarticulo
				FROM 	articuloinventario
				WHERE 	periodo BETWEEN xPeriodoInicio AND xPeriodoFin
				group by idarticulo
        );
        
        
        DROP TEMPORARY TABLE IF EXISTS tmp_articulo2;
        CREATE TEMPORARY TABLE tmp_articulo2(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            valortotal DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo2(idarticulo, cantidad, preciounitario, valortotal)
        SELECT idarticulo, cantidad, preciounitario, valortotal
        FROM  	tmp_articulo
        ORDER BY valortotal DESC;
        
        SELECT COUNT(*) INTO xTotal FROM tmp_articulo;
        
        SET xClasA = xTotal * xValor01;
        SET xClasB = xTotal * xValor02;
        SET xClasA = IF(xClasA = 0, 1, xClasA);
        SET xClasB = IF(xClasB = 0, 1, xClasB);
        
        UPDATE tmp_articulo2
        SET 	clasificacion = 'A'
        WHERE 	indice <= xClasA;
        
        UPDATE tmp_articulo2
        SET 	clasificacion = 'B'
        WHERE 	indice > xClasA AND indice <= (xClasB + xClasA);
        
         UPDATE tmp_articulo2
          SET 	clasificacion = 'C'
        WHERE 	indice > (xClasB + xClasA);
	
		DELETE FROM reporte_clasificacion WHERE tipo = '2';
        INSERT INTO reporte_clasificacion(cantidad, preciounitario, valortotal, nombrearticulo, 
        clasificacion, tipo, idarticulo)
        SELECT 	A.cantidad,
				A.preciounitario,
                A.valortotal,
				B.articulo,
                A.clasificacion,
                '2', 
                A.idarticulo
        FROM 	tmp_articulo2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
                
       SELECT 	A.indice,
				A.cantidad,
				A.preciounitario,
				B.articulo,
                A.clasificacion,
                A.valortotal
        FROM 	tmp_articulo2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
        
    END IF;
    
    
     
    IF xOpcion = 3 THEN	 -- CLASIFICACION POR UTILIZACION Y VALOR
    
		DROP TEMPORARY TABLE IF EXISTS tmp_articulo;
        CREATE TEMPORARY TABLE tmp_articulo(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            valortotal DECIMAL(12,2) default 0,
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo (idarticulo, cantidad, preciounitario, valortotal)
       SELECT 	idarticulo,SUM(cantidad),AVG(preciodeventa),SUM(cantidad)*AVG(preciodeventa)
		FROM 	articuloxdocumentoventa
		WHERE 	CONCAT(YEAR(fechareg),IF(MONTH(fechareg)<10,'0',''),MONTH(fechareg)) BETWEEN xPeriodoInicio AND xPeriodoFin
		GROUP BY
			idarticulo;
        
        
        DROP TEMPORARY TABLE IF EXISTS tmp_articulo2;
        CREATE TEMPORARY TABLE tmp_articulo2(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            valortotal DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo2(idarticulo, cantidad, preciounitario, valortotal)
        SELECT idarticulo, cantidad, preciounitario, valortotal
        FROM  	tmp_articulo
        ORDER BY valortotal DESC;
        
        SELECT COUNT(*) INTO xTotal FROM tmp_articulo;
        
        SET xClasA = xTotal * xValor01;
        SET xClasB = xTotal * xValor02;
		SET xClasA = IF(xClasA = 0, 1, xClasA);
        SET xClasB = IF(xClasB = 0, 1, xClasB);
        
        UPDATE tmp_articulo2
        SET 	clasificacion = 'A'
        WHERE 	indice <= xClasA;
        
        UPDATE tmp_articulo2
        SET 	clasificacion = 'B'
        WHERE 	indice > xClasA AND indice <= (xClasB + xClasA);
        
         UPDATE tmp_articulo2
          SET 	clasificacion = 'C'
        WHERE 	indice > (xClasB + xClasA);
        
        
        DELETE FROM reporte_clasificacion WHERE tipo = '3';
        INSERT INTO reporte_clasificacion(cantidad, preciounitario, valortotal, nombrearticulo, 
        clasificacion, tipo, idarticulo)
        SELECT 	A.cantidad,
				A.preciounitario,
                A.valortotal,
				B.articulo,
                A.clasificacion,
                '3', 
                A.idarticulo
        FROM 	tmp_articulo2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
                
        
       SELECT 	A.indice,
				A.cantidad,
				A.preciounitario,
				B.articulo,
                A.clasificacion,
                A.valortotal
        FROM 	tmp_articulo2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
        
    END IF;
    
    
    IF xOpcion = 4 THEN
    
        
        DROP TEMPORARY TABLE IF EXISTS tmp_articulo2_1;
        CREATE TEMPORARY TABLE tmp_articulo2_1(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo2_1(idarticulo, cantidad, preciounitario, clasificacion)
        SELECT idarticulo, cantidad, preciounitario, clasificacion
        FROM  	reporte_clasificacion
        WHERE 	tipo = '1'
        ORDER BY preciounitario DESC;
        
        /* fin 1*/
        
        
        
        
        DROP TEMPORARY TABLE IF EXISTS tmp_articulo2_2;
        CREATE TEMPORARY TABLE tmp_articulo2_2(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            valortotal DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo2_2(idarticulo, cantidad, preciounitario, valortotal,clasificacion)
        SELECT idarticulo, cantidad, preciounitario, valortotal, clasificacion
        FROM  	reporte_clasificacion
        WHERE 	tipo = '2'
        ORDER BY valortotal DESC;
        
    
      /* fin 2 */
    
		
        
        
        DROP TEMPORARY TABLE IF EXISTS tmp_articulo2_3;
        CREATE TEMPORARY TABLE tmp_articulo2_3(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT,
            preciounitario DECIMAL(12,2),
            valortotal DECIMAL(12,2),
            clasificacion CHAR(1)
        );
        
        INSERT INTO tmp_articulo2_3(idarticulo, cantidad, preciounitario, valortotal, clasificacion)
        SELECT idarticulo, cantidad, preciounitario, valortotal, clasificacion
        FROM  	reporte_clasificacion
        WHERE 	tipo = '3'
        ORDER BY valortotal DESC;
        
        
        /* fin opcion 3 */
        
        
       DROP TEMPORARY TABLE IF EXISTS promedio;
        CREATE TEMPORARY TABLE promedio(
            idarticulo INT PRIMARY KEY ,
            clasificacion1 CHAR(1) DEFAULT '', 
            clasificacion2 CHAR(1) DEFAULT '',
            clasificacion3 CHAR(1) DEFAULT '',
            promedio CHAR(1) DEFAULT '',
            numpromedio INT DEFAULT 0
        );
        
        INSERT INTO promedio(idarticulo,clasificacion1)
        SELECT idarticulo, clasificacion FROM tmp_articulo2_1;
        
        UPDATE 	promedio AS A 
				inner join tmp_articulo2_2 AS B ON A.idarticulo = B.idarticulo
        SET 	A.clasificacion2 = B.clasificacion;
                
        INSERT IGNORE promedio(idarticulo,clasificacion2)
        SELECT idarticulo, clasificacion FROM tmp_articulo2_2;
        
		UPDATE 	promedio AS A 
				inner join tmp_articulo2_3 AS B ON A.idarticulo = B.idarticulo
        SET 	A.clasificacion3 = B.clasificacion;
                
                
        INSERT IGNORE promedio(idarticulo,clasificacion3)
        SELECT idarticulo, clasificacion FROM tmp_articulo2_3;
        
        UPDATE promedio
        SET 	numpromedio = getValor(clasificacion1) + getValor(clasificacion2) + getValor(clasificacion3);
        
        
        
        
          DROP TEMPORARY TABLE IF EXISTS promedio2;
        CREATE TEMPORARY TABLE promedio2(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT ,
            clasificacion1 CHAR(1) DEFAULT '', 
            clasificacion2 CHAR(1) DEFAULT '',
            clasificacion3 CHAR(1) DEFAULT '',
            promedio CHAR(1) DEFAULT '',
            numpromedio INT DEFAULT 0
        );
        
        INSERT INTO promedio2(idarticulo, clasificacion1,clasificacion2,clasificacion3, promedio,numpromedio)
        SELECT idarticulo, clasificacion1,clasificacion2,clasificacion3, promedio,numpromedio
        FROM  	promedio
        ORDER BY numpromedio DESC;
        
        SELECT COUNT(*) INTO xTotal FROM promedio2;
        
        SET xClasA = xTotal * 0.15;
        SET xClasB = xTotal * 0.2;
        SET xClasA = IF(xClasA = 0, 1, xClasA);
        SET xClasB = IF(xClasB = 0, 1, xClasB);
        
        UPDATE promedio2
        SET 	promedio = 'A'
        WHERE 	indice <= xClasA;
        
        UPDATE promedio2
        SET 	promedio = 'B'
        WHERE 	indice > xClasA AND indice <= (xClasB + xClasA);
        
         UPDATE promedio2
          SET 	promedio = 'C'
        WHERE 	indice > (xClasB + xClasA);
        
         SELECT 	A.*,B.articulo
        FROM 	promedio2 A
				INNER JOIN articulo B ON A.idarticulo = B.idarticulo;
        
    
    END IF;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consultarVenta` (`opcion` INT, `xIdventa` INT)  BEGIN
	IF opcion = 1 THEN
		SELECT A.*,IF(B.tipodocumento IS NULL,A.tipocomprobante,B.tipodocumento) as tipodcumento,
				IF(B.serie IS NULL,'0001',B.serie) As serie,
                if(B.numero IS NULL,A.idventa,B.numero) AS numero 
		FROM venta A
				LEFT JOIN confcomprobantes B ON A.tipocomprobante = B.tipodocumento AND B.estado = 1
		WHERE idventa = xIdventa;
	ELSEIF opcion = 2 THEN
		SELECT * FROM articuloxdocumentoventa WHERE idventa = xIdventa and estado = 1;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_mantendedorPedido` (`xOpcion` INT, `xIdpedido` INT)  BEGIN
	DECLARE xIni INT DEFAULT 1;
    DECLARE xTotal INT DEFAULT 0;
    DECLARE xIdArticuloAux INT DEFAULT 0;
    DECLARE xCantidadAux INT DEFAULT 0;
    DECLARE xContador INT DEFAULT 0;
    DECLARE xCorrecto BOOL DEFAULT TRUE;
    
	IF xOpcion = 1 THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_errores;
        CREATE TEMPORARY TABLE tmp_errores(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            nombre VARCHAR(250),
            msj VARCHAR(250),
            stockenalmacen  INT,
            cantidadsolicitada INT
        );
        
		DROP TEMPORARY TABLE IF EXISTS tmp_articulo;
        CREATE TEMPORARY TABLE tmp_articulo(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT
        );
        
        
        
        INSERT INTO tmp_articulo(idarticulo,cantidad)
        SELECT 	idarticulo,
				cantidad
        FROM 	articuloxdocumentopedido
        WHERE 	idpedido = xIdpedido;
        
        SELECT COUNT(*) INTO xTotal FROM tmp_articulo;
        
        WHILE xIni <= xTotal DO
			SELECT 	idarticulo,cantidad
					INTO xIdArticuloAux,xCantidadAux
            FROM 	tmp_articulo
            WHERE 	indice = xIni;
            
            IF (SELECT stock FROM articulo WHERE idarticulo = xIdArticuloAux) < xCantidadAux then
            
				SET xCorrecto = FALSE;
				INSERT INTO tmp_errores(idarticulo,nombre,msj,stockenalmacen,cantidadsolicitada)
                VALUES(
					xIdArticuloAux
                    ,(SELECT articulo FROM articulo WHERE idarticulo = xIdArticuloAux)
                    ,CONCAT('EL ARTICULO ',
						(SELECT articulo FROM articulo WHERE idarticulo = xIdArticuloAux),
                        ' TIENE STOCK INSUFICIENTE'),
                        (SELECT stock FROM articulo WHERE idarticulo = xIdArticuloAux),
                        xCantidadAux
				);
            END IF;
            
            SET xIni = xIni + 1;
        END WHILE;
        
        IF xCorrecto = TRUE THEN
			UPDATE 	articulo A
					INNER JOIN articuloxdocumentopedido B ON A.idarticulo = B.idarticulo
                    INNER JOIN pedido P ON B.idpedido = P.idpedido
			SET 	A.stock = A.stock - B.cantidad,
					P.estadodepedido = 'Atendido'
			WHERE 	B.idpedido = xIdpedido;
				
        END IF;
        
        SELECT * FROM tmp_errores;
        
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_mantendedorVenta` (`xOpcion` INT, `xIdventa` INT)  BEGIN
	DECLARE xIni INT DEFAULT 1;
    DECLARE xTotal INT DEFAULT 0;
    DECLARE xIdArticuloAux INT DEFAULT 0;
    DECLARE xCantidadAux INT DEFAULT 0;
    DECLARE xContador INT DEFAULT 0;
    DECLARE xCorrecto BOOL DEFAULT TRUE;
    
	IF xOpcion = 1 THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_errores;
        CREATE TEMPORARY TABLE tmp_errores(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            nombre VARCHAR(250),
            msj VARCHAR(250),
            stockenalmacen  INT,
            cantidadsolicitada INT
        );
        
		DROP TEMPORARY TABLE IF EXISTS tmp_articulo;
        CREATE TEMPORARY TABLE tmp_articulo(
			indice INT PRIMARY KEY AUTO_INCREMENT,
            idarticulo INT,
            cantidad INT
        );
        
        
        
        INSERT INTO tmp_articulo(idarticulo,cantidad)
        SELECT 	idarticulo,
				cantidad
        FROM 	articuloxdocumentoventa
        WHERE 	idventa = xIdventa;
        
        SELECT COUNT(*) INTO xTotal FROM tmp_articulo;
        
        WHILE xIni <= xTotal DO
			SELECT 	idarticulo,cantidad
					INTO xIdArticuloAux,xCantidadAux
            FROM 	tmp_articulo
            WHERE 	indice = xIni;
            
            IF (SELECT stock FROM articulo WHERE idarticulo = xIdArticuloAux) < xCantidadAux then
            
				SET xCorrecto = FALSE;
				INSERT INTO tmp_errores(idarticulo,nombre,msj,stockenalmacen,cantidadsolicitada)
                VALUES(
					xIdArticuloAux
                    ,(SELECT articulo FROM articulo WHERE idarticulo = xIdArticuloAux)
                    ,CONCAT('EL ARTICULO ',
						(SELECT articulo FROM articulo WHERE idarticulo = xIdArticuloAux),
                        ' TIENE STOCK INSUFICIENTE'),
                        (SELECT stock FROM articulo WHERE idarticulo = xIdArticuloAux),
                        xCantidadAux
				);
            END IF;
            
            SET xIni = xIni + 1;
        END WHILE;
        
        IF xCorrecto = TRUE THEN
			UPDATE 	articulo A
					INNER JOIN articuloxdocumentoventa B ON A.idarticulo = B.idarticulo
                    INNER JOIN venta V ON B.idventa = V.idventa
			SET 	A.stock = A.stock - B.cantidad,
					V.estadodeventa = 'Confirmado'
			WHERE 	B.idventa = xIdventa;
			
            UPDATE 	confcomprobantes AS A 
				inner join venta AS B ON A.tipodocumento = B.tipocomprobante
			SET 	A.numero = A.numero + 1
            WHERE A.estado = 1;
        END IF;
        
        SELECT * FROM tmp_errores;
        
    END IF;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getValor` (`categoria` CHAR(1)) RETURNS INT(11) BEGIN
IF categoria = 'A' THEN
	RETURN 3;
ELSEIF categoria = 'B' THEN
	RETURN 2;
ELSEIF categoria = 'C' THEN
	RETURN 1;
ELSE
	RETURN 0;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulo`
--

CREATE TABLE `articulo` (
  `idarticulo` int(20) NOT NULL,
  `idcategoria` int(11) DEFAULT NULL,
  `idsubcategoria` int(11) DEFAULT NULL,
  `categoria` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `subcategoria` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `articulo` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL,
  `marca` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `descripcion` varchar(500) COLLATE utf8_spanish_ci DEFAULT NULL,
  `unidaddemedida` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL,
  `stock` varchar(100) COLLATE utf8_spanish_ci DEFAULT '0',
  `imagen` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `articulo`
--

INSERT INTO `articulo` (`idarticulo`, `idcategoria`, `idsubcategoria`, `categoria`, `subcategoria`, `articulo`, `marca`, `descripcion`, `unidaddemedida`, `stock`, `imagen`, `estado`) VALUES
(1, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Plancha de Tecnoblock 1.20 x 2.40 m x 2\"', 'Tecnoblock', 'Panel con dos caras de viruta de madera aglomerada con cemento prensado con un núcleo de poliestireno de 2\"', 'plancha', '100', 'public/articulos/1.jpg', 1),
(2, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo Raso (Pack X10) 2X4X14mm', 'Tecnoblock', '10 unidades - Espesor 14 mm.', 'pack', '100', 'public/articulos/2.jpg', 1),
(3, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Lana De Vidrio Aislanglass 50', 'Aislanglass', 'Aislante térmico y acústico para tabiquería. 1.2 x 12 m', 'paquete', '100', 'public/articulos/3.jpg', 1),
(4, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Lana Poliest Ecoterm 300GR/MT2', 'Ecoterm', 'Aislante térmico y acústico para tabiquería.  300 gr/m2 x 1.20m', 'rollo', '100', 'public/articulos/4.jpg', 1),
(5, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Plancha de tecnopor', 'Indupol', 'Ideal para aislantes térmicos y juntas de dilatación. 1.20 x 2.40 m , 1”', 'plancha', '100', 'public/articulos/5.jpg', 1),
(6, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Poliestireno Exp 2x1.2mx2.4m', 'Poliestireno', '2\"x1.2m x 2.4m', 'plancha', '100', 'public/articulos/6.jpg', 1),
(7, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Plancha tecnomix 2.40 x 1.20 x 2\"', 'Tecnomix', '2.40 x 1.20 x 2\"', 'plancha', '100', 'public/articulos/7.jpg', 1),
(8, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo Raso Serene 1.2X0.6X12P8', 'Serene', 'Doméstico e industrial 8 und 1.2X0.6X12P8', 'pack', '100', 'public/articulos/8.jpg', 1),
(9, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo raso baldosa radar', 'Radar', 'Espeso 15 mm.  8 unds.  Medida 0.60 m x 1.20 m.', 'pack', '100', 'public/articulos/9.jpg', 1),
(10, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo Raso Glass 1.20 x 0.60 m', 'Volcan', 'PVC Texturado 16 unid. Por caja Medidas 1.20 x 0.60 m', 'caja', '100', 'public/articulos/10.jpg', 1),
(11, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Puas Andn R200m', 'Andn', 'Alambre galvanizado 200m', 'rollo', '100', 'public/articulos/11.jpg', 1),
(12, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre galvn 16 1kg', 'Galvn', 'Alambre galvn 16 1kg', 'rollo', '100', 'public/articulos/12.jpg', 1),
(13, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Recocido Nº 8 100 Kg', 'Prodac', 'Acero de bajo carbono Diámetro 4.20 mm Peso 100 kg', 'rollo', '100', 'public/articulos/13.jpg', 1),
(14, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Galvn #8 50kg', 'Prodac', 'Alambre Galvn #8 50kg', 'rollo', '100', 'public/articulos/14.jpg', 1),
(15, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre galvanizado nº 14 1 kg', 'Prodac', 'Alambre de acero, de bajo contenido de carbono, galvanizado, posee una gran uniformidad en el diámetro y en el recubrimiento de Zinc  Peso 1 kg', 'rollo', '100', 'public/articulos/15.jpg', 1),
(16, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Puas Sinch R200m', 'Sinchi', 'Alambre galvanizado 200m', 'rollo', '100', 'public/articulos/16.jpg', 1),
(17, 1, 2, 'Techos y Tabiques', 'Alambre', 'Grapa malla 3/4 pulgadas x 14 pulgadas', 'Prodac', 'Fabricadas con alambre galvanizado de gran resistencia, con un diseño curvo, puntas invertidas y de cuerpo liso', 'kilogramo', '100', 'public/articulos/17.jpg', 1),
(18, 1, 2, 'Techos y Tabiques', 'Alambre', 'Grapas 1\" pack x 9 prodac', 'Prodac', '9 unid 1\" Grapas', 'pack', '100', 'public/articulos/18.jpg', 1),
(19, 1, 2, 'Techos y Tabiques', 'Alambre', 'Concertina galvanizada 45 cm', 'Prodac', 'Complementos de cerco y elemento disuasivo de acceso.', 'unidad', '100', 'public/articulos/19.jpg', 1),
(20, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre galvanizado 24\" - 100kg', 'Prodac', '24\" - 100 kg', 'kilogramo', '100', 'public/articulos/20.jpg', 1),
(21, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', 'kilogramo', '100', 'public/articulos/21.jpg', 1),
(22, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Puas Motto R200m', 'Motto', 'Alambre galvanizado 200m', 'rollo', '100', 'public/articulos/22.jpg', 1),
(23, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Recocido 8\"-10kg', 'Prodac', 'Se usa en la industria de la construcción para amarres de fierro corrugado en todo tipo de estructuras. Asimismo, en la preparación de fardos y embalajes en general', 'kilogramo', '100', 'public/articulos/23.jpg', 1),
(24, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre recocido n° 16 10 kg', 'Prodac', 'Es un alambre de acero de bajo carbono, obtenido por trefilación y con posterior tratamiento térmico de recocido, que le otorga excelente ductilidad y maleabilidad', 'kilogramo', '100', 'public/articulos/24.jpg', 1),
(25, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre recocido n° 16 1 kg', 'Prodac', 'Por su bajo contenido de carbono y su recocido a altas temperaturas, tiene gran trabajabilidad y ductilidad', 'kilogramo', '100', 'public/articulos/25.jpg', 1),
(26, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre galvanizado n° 16 - 1 kg prodac', 'Prodac', 'Cielos lisos y electrificados.', 'kilogramo', '100', 'public/articulos/26.jpg', 1),
(27, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera Tijera De Aluminio 7 Pasos', 'Redline', 'Ligera y robusta. Plegable, de gran resistencia y fácil de transportar, Aluminio, Alto 2.39 m, Ancho 0.64 m', 'unidad', '100', 'public/articulos/27.jpg', 1),
(28, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera Tijera De Aluminio 9 Pasos', 'Max', 'Ligera y robusta. Plegable, de gran resistencia y fácil de transportar, Aluminio, Alto 2.91 m, Ancho 0.70 m', 'unidad', '100', 'public/articulos/28.jpg', 1),
(29, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera De Metal 6 Pasos', 'Max', '6 pasos Metal', 'unidad', '100', 'public/articulos/29.jpg', 1),
(30, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera tijera de madera 6 pasos', 'Max', 'Escalera tijera de madera 6 pasos', 'unidad', '100', 'public/articulos/30.jpg', 1),
(31, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera de arrimo 10 pasos madera', 'Max', 'Escalera de arrimo 10 pasos madera', 'unidad', '100', 'public/articulos/31.jpg', 1),
(32, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera doméstica 2 pasos', 'Elements', 'El producto elegido puede llegar en color morado, verde, azul o anaranjado', 'unidad', '100', 'public/articulos/32.jpg', 1),
(33, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera telescópica aluminio 16 pasos', 'Redline', 'Escalera telescópica aluminio 16 pasos', 'unidad', '100', 'public/articulos/33.jpg', 1),
(34, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera tijera madera 8 pasos', 'Redline', 'Escalera tijera madera 8 pasos', 'unidad', '100', 'public/articulos/34.jpg', 1),
(35, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera adaptable fibra-vidrio 12 pasos', 'Redline', 'Escalera adaptable fibra-vidrio 12 pasos', 'unidad', '100', 'public/articulos/35.jpg', 1),
(36, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera Tijera De Aluminio 3 Pasos', 'Redline', 'Ligera y robusta. Plegable, de gran resistencia y fácil de transportar', 'unidad', '100', 'public/articulos/36.jpg', 1),
(37, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera Tijera De Aluminio 5 Pasos', 'Redline', 'Ligera y robusta. Plegable, de gran resistencia y fácil de transportar', 'unidad', '100', 'public/articulos/37.jpg', 1),
(38, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera tijera de madera 12 pasos', 'Max', 'Escalera tijera de madera 12 pasos', 'unidad', '100', 'public/articulos/38.jpg', 1),
(39, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera Tijera De Aluminio 3 Pasos', 'Redline', 'Escalera Tijera De Aluminio 3 Pasos', 'unidad', '100', 'public/articulos/39.jpg', 1),
(40, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera fibra de vidrio 6 pasos', 'Redline', 'Escalera fibra de vidrio 6 pasos', 'unidad', '100', 'public/articulos/40.jpg', 1),
(41, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera Multi Posición Aluminio 12 Pasos Aluminio', 'Redline', 'Escalera profesional ligera, resistente y plegable. 8 posiciones. Estructura formada a partir de perfiles de aluminio. Peldaños con superficie antideslizante', 'unidad', '100', 'public/articulos/41.jpg', 1),
(42, 1, 3, 'Techos y Tabiques', 'Escaleras', 'Escalera tijera madera 10 pasos', 'Max', 'Escalera tijera madera 10 pasos', 'unidad', '100', 'public/articulos/42.jpg', 1),
(43, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Mosquitero Metálica x Metro Lineal', 'Hyde tools', 'Diseñada para tener un desempeño de alto rendimiento en aplicaciones donde cualquier otra malla mosquitera se deterioraría rápidamente, gracias al galvanizado, al diámetro y a la calidad del acero de sus alambres.', 'metro', '100', 'public/articulos/43.jpg', 1),
(44, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Alambre Galvanizado Cuadrado 1/2\"', 'Hyde tools', 'Diseñadas especialmente para la construcción de jaulas de animales pequeños. La malla cuadrada es fabricada con alambre galvanizado, electrosoldado en los puntos de cruce.', 'metro', '100', 'public/articulos/44.jpg', 1),
(45, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'O-Malla Mosqui Plast Vde Ml', 'Hyde tools', 'O-Malla Mosqui Plast Vde Ml', 'metro', '100', 'public/articulos/45.jpg', 1),
(46, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Mosqu Plast Az 0.9Mx30M', 'Hyde tools', 'Malla Mosqu Plast Az 0.9Mx30M', 'metro', '100', 'public/articulos/46.jpg', 1),
(47, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Membrana asfáltica gravillada negro chema', 'Hyde tools', 'Techos de madera, fibro cemento, drywall, metal, aglomerado y otros.', 'metro', '100', 'public/articulos/47.jpg', 1),
(48, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Cuadrada 3/4pxmetro.', 'Hyde tools', 'Malla Cuadrada 3/4pxmetro.', 'metro', '100', 'public/articulos/48.jpg', 1),
(49, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'O-malla Tejida Negra/gris X Ml', 'Hyde tools', 'O-malla Tejida Negra/gris X Ml', 'metro', '100', 'public/articulos/49.jpg', 1),
(50, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Hexagonal 3/4-0.90 Ml.', 'Hyde tools', 'Malla Hexagonal 3/4-0.90 Ml.', 'metro', '100', 'public/articulos/50.jpg', 1),
(51, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla mosquitera mesh verde rollo x 30m', 'Hyde tools', 'Malla mosquitera mesh verde rollo x 30m', 'metro', '100', 'public/articulos/51.jpg', 1),
(52, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla mosquitera mesh aluminio rollo x 30m', 'Hyde tools', 'Malla mosquitera mesh aluminio rollo x 30m', 'metro', '100', 'public/articulos/52.jpg', 1),
(53, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla rashell azul rollo x 100m', 'Hyde tools', 'Malla rashell azul rollo x 100m', 'metro', '100', 'public/articulos/53.jpg', 1),
(54, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla rashell rollo x 100m gris', 'Hyde tools', 'Malla rashell rollo x 100m gris', 'metro', '100', 'public/articulos/54.jpg', 1),
(55, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla rashell rollo x 100m negro', 'Hyde tools', 'Malla rashell rollo x 100m negro', 'metro', '100', 'public/articulos/55.jpg', 1),
(56, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla rashell rollo x 100m verde', 'Hyde tools', 'Malla rashell rollo x 100m verde', 'metro', '100', 'public/articulos/56.jpg', 1),
(57, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Broche pack x 25 bisagra', 'Hyde tools', 'Broche pack x 25 bisagra', 'pack', '100', 'public/articulos/57.jpg', 1),
(58, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Mosquitero 0.90 m Negro', 'Topex', 'Resistente a la degradación ante los rayos solares. Permiten una buena ventilación. De alta calidad y gran durabilidad.', 'metro', '100', 'public/articulos/58.jpg', 1),
(59, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Mosqu Plast Vde 0.9mx30m', 'Topex', 'Malla Mosqu Plast Vde 0.9mx30m', 'metro', '100', 'public/articulos/59.jpg', 1),
(60, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla alambre galvanizado cuadrado 3/4\"\"', 'Alte', 'Diseñadas especialmente para la construcción de jaulas de animales pequeños. La malla cuadrada es fabricada con alambre galvanizado, electrosoldado en los puntos de cruce.', 'metro', '100', 'public/articulos/60.jpg', 1),
(61, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla alambre galvanizado cuadrado 1\" x mt\"', 'Alte', 'Malla alambre galvanizado cuadrado 1\" x mt\"', 'metro', '100', 'public/articulos/61.jpg', 1),
(62, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Mangas plásticas azul 1.5m x 8 mm', 'Hyde tools', 'Mangas plásticas azul 1.5m x 8 mm', 'metro', '100', 'public/articulos/62.jpg', 1),
(63, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Mangas plásticas gris 1.5m x 8 mm', 'Hyde tools', 'Mangas plásticas gris 1.5m x 8 mm', 'metro', '100', 'public/articulos/63.jpg', 1),
(64, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Mangas plásticas negro 1.5m x 8 mm', 'Hyde tools', 'Mangas plásticas negro 1.5m x 8 mm', 'metro', '100', 'public/articulos/64.jpg', 1),
(65, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Manga plast 1.5mx2mm az r10m', 'Hyde tools', 'Manga plast 1.5mx2mm az r10m', 'unidad', '100', 'public/articulos/65.jpg', 1),
(66, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla cuadrada galvanizada rollo x 30m 1\" - 0.9m', 'Hyde tools', 'Malla cuadrada galvanizada rollo x 30m 1\" - 0.9m', 'metro', '100', 'public/articulos/66.jpg', 1),
(67, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla tejida 2\" galvanizada 14 rollo x 10m', 'Hyde tools', 'Malla tejida 2\" galvanizada 14 rollo x 10m', 'metro', '100', 'public/articulos/67.jpg', 1),
(68, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla tejida 2\" galvanizada pvc 14 rollo x 10m', 'Hyde tools', 'Malla tejida 2\" galvanizada pvc 14 rollo x 10m', 'rollo', '100', 'public/articulos/68.jpg', 1),
(69, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Malla Cuadrados 0.90 m x 1\" Gris', 'Alte', 'Malla Cuadrados 0.90 m x 1\" Gris', 'rollo', '100', 'public/articulos/69.jpg', 1),
(70, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Manga plast 1.5mx2.8mm az r5m', 'Hyde tools', 'Manga plast 1.5mx2.8mm az r5m', 'unidad', '100', 'public/articulos/70.jpg', 1),
(71, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Manga Plast 1.5mx2.8mm Neg R5m', 'Hyde tools', 'Manga Plast 1.5mx2.8mm Neg R5m', 'unidad', '100', 'public/articulos/71.jpg', 1),
(72, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Manga plast 1.5mx2.8mm neg r10m', 'Hyde tools', 'Manga plast 1.5mx2.8mm neg r10m', 'unidad', '100', 'public/articulos/72.jpg', 1),
(73, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Manga plast 60\" crstl r10m', 'Hyde tools', 'Manga plast 60\" crstl r10m', 'unidad', '100', 'public/articulos/73.jpg', 1),
(74, 1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 'Manga plast 60\" crstl r5m', 'Hyde tools', 'Manga plast 60\" crstl r5m', 'unidad', '100', 'public/articulos/74.jpg', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articuloinventario`
--

CREATE TABLE `articuloinventario` (
  `idarticuloinventario` int(11) NOT NULL,
  `idarticulo` int(11) DEFAULT NULL,
  `periodo` varchar(6) COLLATE utf8_bin DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `preciounitario` decimal(12,2) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articuloxdocumento`
--

CREATE TABLE `articuloxdocumento` (
  `idartxdoc` int(11) NOT NULL,
  `idingresoalma` int(11) NOT NULL,
  `idarticulo` int(11) NOT NULL,
  `articulo` varchar(40) COLLATE utf8_spanish_ci DEFAULT NULL,
  `marca` varchar(40) COLLATE utf8_spanish_ci DEFAULT NULL,
  `descripcion` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `stockingreso` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `preciocompraunitario` decimal(25,2) DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `fechareg` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `articuloxdocumento`
--

INSERT INTO `articuloxdocumento` (`idartxdoc`, `idingresoalma`, `idarticulo`, `articulo`, `marca`, `descripcion`, `stockingreso`, `preciocompraunitario`, `estado`, `fechareg`) VALUES
(1, 2, 20, 'Alambre galvanizado 24\" - 100kg', 'Prodac', '24\" - 100 kg', '600', '12.00', 1, '2018-07-11 19:16:51'),
(2, 3, 21, 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', '455', '12.00', 1, '2018-07-11 19:53:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articuloxdocumentopedido`
--

CREATE TABLE `articuloxdocumentopedido` (
  `idartxdocped` int(11) NOT NULL,
  `articulo` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `marca` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `descripcion` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `cantidad` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `preciodeventa` decimal(25,2) DEFAULT NULL,
  `idpedido` int(11) NOT NULL,
  `idarticulo` int(11) NOT NULL,
  `estado` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articuloxdocumentoventa`
--

CREATE TABLE `articuloxdocumentoventa` (
  `idartxdocven` int(11) NOT NULL,
  `articulo` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `marca` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `descripcion` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `cantidad` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `preciodeventa` decimal(25,2) DEFAULT NULL,
  `idventa` int(11) DEFAULT NULL,
  `idarticulo` int(11) DEFAULT NULL,
  `estado` int(2) NOT NULL DEFAULT '1',
  `fechareg` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `articuloxdocumentoventa`
--

INSERT INTO `articuloxdocumentoventa` (`idartxdocven`, `articulo`, `marca`, `descripcion`, `cantidad`, `preciodeventa`, `idventa`, `idarticulo`, `estado`, `fechareg`) VALUES
(1, 'Alambre galvanizado 24\" - 100kg', 'Prodac', '24\" - 100 kg', '12', '12.00', 1, 20, 1, '2018-07-11 18:14:55'),
(2, 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', '2', '2.00', 2, 21, 1, '2018-07-11 19:52:54'),
(3, 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', '12', '10.00', 3, 21, 1, '2018-07-13 12:24:40'),
(4, 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', '8', '8.00', 3, 21, 1, '2018-07-13 12:24:47'),
(5, 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', '5', '7.00', 3, 21, 1, '2018-07-13 12:24:53'),
(6, 'Alam Negro Recocido 8x25kg', 'Prodac', 'Alam Negro Recocido 8x25kg', '80', '2.00', 3, 21, 1, '2018-07-13 12:25:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `idcategoria` int(10) NOT NULL,
  `nombre` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`idcategoria`, `nombre`, `estado`) VALUES
(1, 'Techos y Tabiques', 1),
(2, 'Puertas y Ventanas', 1),
(3, 'Pisos', 1),
(4, 'Piscinas', 1),
(5, 'Pinturas y Accesorios', 1),
(6, 'Organización', 1),
(7, 'Obra Gruesa', 1),
(8, 'Muebles', 1),
(9, 'Maderas Y Tableros', 1),
(10, 'Línea Blanca y Climatización', 1),
(11, 'Limpieza', 1),
(12, 'Jardín', 1),
(13, 'Iluminación', 1),
(14, 'Herramientas y Maquinarias', 1),
(15, 'Gasfitería', 1),
(16, 'Fierro y Hierro', 1),
(17, 'Ferretería', 1),
(18, 'Electricidad', 1),
(19, 'Comunicación y Electrónica', 1),
(20, 'Baños y Cocinas', 1),
(21, 'Auto', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL,
  `nombre` varchar(80) COLLATE utf8_spanish_ci DEFAULT NULL,
  `cliente` varchar(80) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipodocumento` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `documento` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(80) COLLATE utf8_spanish_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `departamento` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `provincia` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `distrito` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `calle` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `direccion` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` varchar(2) COLLATE utf8_spanish_ci DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idcliente`, `nombre`, `cliente`, `tipodocumento`, `documento`, `email`, `telefono`, `departamento`, `provincia`, `distrito`, `calle`, `direccion`, `estado`) VALUES
(1, 'HUERTO BOZA PAOLA VANNESA', 'HUERTO BOZA PAOLA VANNESA', 'RUC', '10443302404', 'hboza@gmail.com', '631-0300', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO NRO. 926 INT. 321', 'LIMA - LIMA - LIMA - JR. PARURO NRO. 926 INT. 321', '1'),
(2, 'INVERSIONES BLUER SAC', 'INVERSIONES BLUER SAC', 'RUC', '20550555132', 'INVERSIONESBLUERSAC@gmail.com', '4785695', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO NRO. 924 INT. 1058 URB. BARRI', 'LIMA - LIMA - LIMA - JR. PARURO NRO. 924 INT. 1058 URB. BARRI', '1'),
(3, 'BOTICA FARMALATINA', 'BOTICA FARMALATINA', 'RUC', '10423407307', 'BOTICAFARMALATINA@gmail.com', '99915482', 'LIMA', 'LIMA', 'SANTA ANITA', 'AV. LOS EUCALIPTOS NRO. 431 COO. LA UNIV', 'LIMA - LIMA - SANTA ANITA - AV. LOS EUCALIPTOS NRO. 431 COO. LA UNIV', '1'),
(4, 'BOTICA MAS SALUD', 'BOTICA MAS SALUD', 'RUC', '10453473983', 'BOTICAMASSALUD@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. ARRIBA PERU MZA. I LOTE. 13 SEC. 2 G', 'LIMA - LIMA - LIMA - AV. ARRIBA PERU MZA. I LOTE. 13 SEC. 2 G', '1'),
(5, 'BOTICA DARSHEL', 'BOTICA DARSHEL', 'RUC', '20600206177', 'BOTICADARSHEL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. CANGALLO 109 B', 'LIMA - LIMA - LA VICTORIA - JR. CANGALLO 109 B', '1'),
(6, 'MENDOZA HORNA ELSA', 'MENDOZA HORNA ELSA', 'RUC', '10062664318', 'MENDOZAHORNAELSA@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'AV. TERPSICORE MZA. J LOTE. 19', 'LIMA - LIMA - ATE - AV. TERPSICORE MZA. J LOTE. 19', '1'),
(7, 'VALUFARMA', 'VALUFARMA', 'RUC', '10418216579', 'VALUFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'INDEPENDENCIA', 'AV. CORICANCHA NRO. 542B SEC. TAHUANTINS', 'LIMA - LIMA - INDEPENDENCIA - AV. CORICANCHA NRO. 542B SEC. TAHUANTINS', '1'),
(8, 'BOTICA ABLPHARMAX', 'BOTICA ABLPHARMAX', 'RUC', '10415793630', 'BOTICAABLPHARMAX@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MARTIN DE PORRES', 'AV. SOL DE NARANJAL MZA. D LOTE. 03 INT.', 'LIMA - LIMA - SAN MARTIN DE PORRES - AV. SOL DE NARANJAL MZA. D LOTE. 03 INT.', '1'),
(9, 'PAÑALANDIA E.I.R.L.', 'PAÑALANDIA E.I.R.L.', 'RUC', '20602725121', 'PAÑALANDIAEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'AV. VICTORIA A. BELAUNDE OESTE NRO. 374', 'LIMA - LIMA - COMAS - AV. VICTORIA A. BELAUNDE OESTE NRO. 374', '1'),
(10, 'LA CASA DEL PAÑAL JUANITA', 'LA CASA DEL PAÑAL JUANITA', 'RUC', '20602740804', 'LACASADELPAÑALJUANITA@gmail.com', '99915482', 'LIMA', 'LIMA', 'MAGDALENA DEL MAR', 'JR. VALENCIA 590', 'LIMA - LIMA - MAGDALENA DEL MAR - JR. VALENCIA 590', '1'),
(11, 'BOTICA DEL BOULEVARD', 'BOTICA DEL BOULEVARD', 'RUC', '10085363285', 'BOTICADELBOULEVARD@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MIGUEL', 'AV. LOS PRECURSORES NRO. 795 URB. MARANG', 'LIMA - LIMA - SAN MIGUEL - AV. LOS PRECURSORES NRO. 795 URB. MARANG', '1'),
(12, 'MEDIK & FARMACEUTICA AZUL S.A.C.', 'MEDIK & FARMACEUTICA AZUL S.A.C.', 'RUC', '20601476747', 'MEDIK&FARMACEUTICAAZULSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'AV. TUPAC AMARU 7947-7949', 'LIMA - LIMA - COMAS - AV. TUPAC AMARU 7947-7949', '1'),
(13, 'BOTICA ALIFARMA', 'BOTICA ALIFARMA', 'RUC', '10082779171', 'BOTICAALIFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'AV. GRAN CHIMU NRO. 1022 URB. ZARATE', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - AV. GRAN CHIMU NRO. 1022 URB. ZARATE', '1'),
(14, 'TICLA SALSAVILCA JULIO ANDRE', 'TICLA SALSAVILCA JULIO ANDRE', 'RUC', '10444381782', 'TICLASALSAVILCAJULIOANDRE@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'MZA. O7 LOTE. 04', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - MZA. O7 LOTE. 04', '1'),
(15, 'GRUPO JOSMIL S.A.C.', 'GRUPO JOSMIL S.A.C.', 'RUC', '20600426185', 'GRUPOJOSMILSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LOS OLIVOS', 'CALLE   MZA. L LOT. 17 1', 'LIMA - LIMA - LOS OLIVOS - CALLE   MZA. L LOT. 17 1', '1'),
(16, 'JHOLE PHARMA S.A.C.', 'JHOLE PHARMA S.A.C.', 'RUC', '20601946191', 'JHOLEPHARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'PUENTE PIEDRA', 'AV. LAS PALMERAS MZA. K LOTE. 21 DPTO. B', 'LIMA - LIMA - PUENTE PIEDRA - AV. LAS PALMERAS MZA. K LOTE. 21 DPTO. B', '1'),
(17, 'CDAFARMA S.A.C.', 'CDAFARMA S.A.C.', 'RUC', '20601383633', 'CDAFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LUR', 'AV. GRAN CHIMU   MZ I-5 LT. 12 1001 1001', 'LIMA - LIMA - SAN JUAN DE LUR - AV. GRAN CHIMU   MZ I-5 LT. 12 1001 1001', '1'),
(18, 'HUAYNATE GONZALES JEENNY GLORIA', 'HUAYNATE GONZALES JEENNY GLORIA', 'RUC', '10209062564', 'HUAYNATEGONZALESJEENNYGLORIA@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVAD', 'SEC. 07 GRUPO 01 MZA. ZC  TDA.15', 'LIMA - LIMA - VILLA EL SALVAD - SEC. 07 GRUPO 01 MZA. ZC  TDA.15', '1'),
(19, 'OFERTOFARMA S.A.C.', 'OFERTOFARMA S.A.C.', 'RUC', '20601673763', 'OFERTOFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. MANCO CAPAC 700', 'LIMA - LIMA - LA VICTORIA - AV. MANCO CAPAC 700', '1'),
(20, 'PERCHASA E.I.R.L.', 'PERCHASA E.I.R.L.', 'RUC', '20601697972', 'PERCHASAEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PEREZ DE TUDELA 1981', 'LIMA - LIMA - LIMA - JR. PEREZ DE TUDELA 1981', '1'),
(21, 'SOTO MORENO ROSA VICTORIA', 'SOTO MORENO ROSA VICTORIA', 'RUC', '10090254761', 'SOTOMORENOROSAVICTORIA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR AYACUCHO 724', 'LIMA - LIMA - LIMA - JR AYACUCHO 724', '1'),
(22, 'SMART PHARMA S.A.C.', 'SMART PHARMA S.A.C.', 'RUC', '20492653102', 'SMARTPHARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'MAGDALENA DEL MAR             ', 'AV.JAVIER PRADO OESTEN°757', 'LIMA - LIMA - MAGDALENA DEL MAR              - AV.JAVIER PRADO OESTEN°757', '1'),
(23, 'CORPORACION DE NEGOCIOS F&P SAC', 'CORPORACION DE NEGOCIOS F&P SAC', 'RUC', '20506251177', 'CORPORACIONDENEGOCIOSF&PSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JIRON CUZCO 590 107', 'LIMA - LIMA - LIMA - JIRON CUZCO 590 107', '1'),
(24, 'D´NALO S.A.C.', 'D´NALO S.A.C.', 'RUC', '20602151795', 'D´NALOSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'PUENTE PIEDRA', 'CAL.LOS CLAVELES MZA. C LOTE. 3 URB. LA', 'LIMA - LIMA - PUENTE PIEDRA - CAL.LOS CLAVELES MZA. C LOTE. 3 URB. LA', '1'),
(25, 'NEGOCIACIONES E INVERSIONES EDU S.R.L', 'NEGOCIACIONES E INVERSIONES EDU S.R.L', 'RUC', '20553647968', 'NEGOCIACIONESEINVERSIONESEDUSRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. INAMBARI 719 208', 'LIMA - LIMA - LIMA - JR. INAMBARI 719 208', '1'),
(26, 'INVERSIONES MD & R S.A.C.', 'INVERSIONES MD & R S.A.C.', 'RUC', '20518145844', 'INVERSIONESMD&RSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. APURIMAC 471 M', 'LIMA - LIMA - LIMA - JR. APURIMAC 471 M', '1'),
(27, 'MULTINEGOCIOS DON ALEJO E.I.R.L.', 'MULTINEGOCIOS DON ALEJO E.I.R.L.', 'RUC', '20601892589', 'MULTINEGOCIOSDONALEJOEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. CANGALLO NRO. 475 INT. 206 URB. BARR', 'LIMA - LIMA - LIMA - JR. CANGALLO NRO. 475 INT. 206 URB. BARR', '1'),
(28, 'FARMANDINA PERU', 'FARMANDINA PERU', 'RUC', '10409677512', 'FARMANDINAPERU@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'AV. EL SOL NRO. 423 INT. 326 OTR. PARC.', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - AV. EL SOL NRO. 423 INT. 326 OTR. PARC.', '1'),
(29, 'INVERSIONES LUIMEY E.I.R.L.', 'INVERSIONES LUIMEY E.I.R.L.', 'RUC', '20602755135', 'INVERSIONESLUIMEYEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO NRO. 926 INT. 3051 GALERIA CA', 'LIMA - LIMA - LIMA - JR. PARURO NRO. 926 INT. 3051 GALERIA CA', '1'),
(30, 'CADENA PERUANA DE BOTICA`S SUIZA SAC', 'CADENA PERUANA DE BOTICA`S SUIZA SAC', 'RUC', '20536296876', 'CADENAPERUANADEBOTICA`SSUIZASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'AV. UNIVERSITARIA NORTE 6058', 'LIMA - LIMA - COMAS - AV. UNIVERSITARIA NORTE 6058', '1'),
(31, 'PRIMAVERA PHARMA S.A.C.', 'PRIMAVERA PHARMA S.A.C.', 'RUC', '20602786588', 'PRIMAVERAPHARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'CAL.5 MZA. H LOTE. 17 ASC. LA FLORIDA DE', 'LIMA - LIMA - ATE - CAL.5 MZA. H LOTE. 17 ASC. LA FLORIDA DE', '1'),
(32, 'A & S PHARMACEUTICAL S.A.C.', 'A & S PHARMACEUTICAL S.A.C.', 'RUC', '20562739727', 'A&SPHARMACEUTICALSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'AV. LA MAR NRO. 556 U.IND VULCANO 2DA ET', 'LIMA - LIMA - ATE - AV. LA MAR NRO. 556 U.IND VULCANO 2DA ET', '1'),
(33, 'BOTICAS LA GENERICA', 'BOTICAS LA GENERICA', 'RUC', '20600652444', 'BOTICASLAGENERICA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. RUFINO TORRICO NRO. 370 (JR- RUFINO', 'LIMA - LIMA - LIMA - JR. RUFINO TORRICO NRO. 370 (JR- RUFINO', '1'),
(34, 'BOTICAS NUEVO MUNDO', 'BOTICAS NUEVO MUNDO', 'RUC', '10467186341', 'BOTICASNUEVOMUNDO@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'AV. GRAN CHIMU N 647 MZA. F-2 LOTE. 37 U', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - AV. GRAN CHIMU N 647 MZA. F-2 LOTE. 37 U', '1'),
(35, 'SERVA ORIHUELA PASCUAL BAILON', 'SERVA ORIHUELA PASCUAL BAILON', 'RUC', '10199877238', 'SERVAORIHUELAPASCUALBAILON@gmail.com', '99915482', 'LIMA', 'LIMA', 'SURQUILLO', 'JR. DOMINGO MARTINEZ LUJAN 646', 'LIMA - LIMA - SURQUILLO - JR. DOMINGO MARTINEZ LUJAN 646', '1'),
(36, 'JHIMFARMA E.I.R.L.', 'JHIMFARMA E.I.R.L.', 'RUC', '20519359775', 'JHIMFARMAEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. CUSCO NRO. 783 INT. 2064 GAL. CAPON', 'LIMA - LIMA - LIMA - JR. CUSCO NRO. 783 INT. 2064 GAL. CAPON', '1'),
(37, 'ALL PHARM', 'ALL PHARM', 'RUC', '20514377481', 'ALLPHARM@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. EMANCIPACION NRO. 184 DPTO. 305', 'LIMA - LIMA - LIMA - AV. EMANCIPACION NRO. 184 DPTO. 305', '1'),
(38, 'DAVILA NONALAYA OFELIA AMANDA', 'DAVILA NONALAYA OFELIA AMANDA', 'RUC', '10207029217', 'DAVILANONALAYAOFELIAAMANDA@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'AV. LAS GAVIOTAS 349', 'LIMA - LIMA - ATE - AV. LAS GAVIOTAS 349', '1'),
(39, 'BOTICAS SERFARMA', 'BOTICAS SERFARMA', 'RUC', '20553872490', 'BOTICASSERFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'AV. GRAN CHIMU NRO. 590 URB. ZARATE (AV', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - AV. GRAN CHIMU NRO. 590 URB. ZARATE (AV', '1'),
(40, 'SORFARMA S.A.C', 'SORFARMA S.A.C', 'RUC', '20537990784', 'SORFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. UCAYALI NRO. 724 INT. 303 URB. BARRI', 'LIMA - LIMA - LIMA - JR. UCAYALI NRO. 724 INT. 303 URB. BARRI', '1'),
(41, 'CHAMORRO RODRIGUEZ CARMEN LUZ', 'CHAMORRO RODRIGUEZ CARMEN LUZ', 'RUC', '10212894422', 'CHAMORRORODRIGUEZCARMENLUZ@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'AV. GERARDO UNGER 6512', 'LIMA - LIMA - COMAS - AV. GERARDO UNGER 6512', '1'),
(42, 'GARATE ARCE ABRAHAM LUIS', 'GARATE ARCE ABRAHAM LUIS', 'RUC', '10085363285', 'GARATEARCEABRAHAMLUIS@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MIGUEL', 'AV. LOS PRECURSORES 795', 'LIMA - LIMA - SAN MIGUEL - AV. LOS PRECURSORES 795', '1'),
(43, 'GLOBAL SUAREZ S.A.C.', 'GLOBAL SUAREZ S.A.C.', 'RUC', '20601840538', 'GLOBALSUAREZSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'PUENTE PIEDRA', 'MZA. J LOTE. 7', 'LIMA - LIMA - PUENTE PIEDRA - MZA. J LOTE. 7', '1'),
(44, 'D´NALO S.A.C.', 'D´NALO S.A.C.', 'RUC', '20602151795', 'D´NALOSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'PUENTE PIEDRA', 'CAL.LOS CLAVELES MZA. C LOT. 3', 'LIMA - LIMA - PUENTE PIEDRA - CAL.LOS CLAVELES MZA. C LOT. 3', '1'),
(45, 'DISTRIBUCIONES IVETTE J & M E.I.R.L.', 'DISTRIBUCIONES IVETTE J & M E.I.R.L.', 'RUC', '20600921089', 'DISTRIBUCIONESIVETTEJ&MEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO 926 185M', 'LIMA - LIMA - LIMA - JR. PARURO 926 185M', '1'),
(46, 'PRIMAVERA PHARMA S.A.C.', 'PRIMAVERA PHARMA S.A.C.', 'RUC', '20602786588', 'PRIMAVERAPHARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'CAL.5 MZA. H LOTE. 17 ASC.', 'LIMA - LIMA - ATE - CAL.5 MZA. H LOTE. 17 ASC.', '1'),
(47, 'PRIMAVERA PHARMA S.A.C.', 'PRIMAVERA PHARMA S.A.C.', 'RUC', '20602786588', 'PRIMAVERAPHARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'CAL.5 MZA. H LOTE. 17 ASC.', 'LIMA - LIMA - ATE - CAL.5 MZA. H LOTE. 17 ASC.', '1'),
(48, 'DISTRIBUCIONES SELMAC S.A.C.', 'DISTRIBUCIONES SELMAC S.A.C.', 'RUC', '20602772935', 'DISTRIBUCIONESSELMACSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO NRO. 926 INT. 212 URB. BARRIO', 'LIMA - LIMA - LIMA - JR. PARURO NRO. 926 INT. 212 URB. BARRIO', '1'),
(49, 'VITTA PHARMA', 'VITTA PHARMA', 'RUC', '10097426355', 'VITTAPHARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'JR. CHICLAYO NRO. 192A URB. SAN FELIPE (', 'LIMA - LIMA - COMAS - JR. CHICLAYO NRO. 192A URB. SAN FELIPE (', '1'),
(50, 'EQUIPOS MEDICOS DEL PERU S.A.C.', 'EQUIPOS MEDICOS DEL PERU S.A.C.', 'RUC', '20544867408', 'EQUIPOSMEDICOSDELPERUSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS                    ', 'AV. DEFENSORES DEL MORRO NRO. 524A', 'LIMA - LIMA - CHORRILLOS                     - AV. DEFENSORES DEL MORRO NRO. 524A', '1'),
(51, 'FARMACIAS', 'FARMACIAS', 'RUC', '20600856295', 'FARMACIAS@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'AV. EL PORVENIR LOS MOLLES MZA. D LOTE.', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - AV. EL PORVENIR LOS MOLLES MZA. D LOTE.', '1'),
(52, 'PEREZ GARCIA ENRIQUE MANUEL', 'PEREZ GARCIA ENRIQUE MANUEL', 'RUC', '10094132687', 'PEREZGARCIAENRIQUEMANUEL@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE MIR', 'EDIF A-15 S/N 301', 'LIMA - LIMA - SAN JUAN DE MIR - EDIF A-15 S/N 301', '1'),
(53, 'BOTICA AHORRO & SALUD', 'BOTICA AHORRO & SALUD', 'RUC', '10472763453', 'BOTICAAHORRO&SALUD@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MARTIN DE PORRES', 'CAL.JUSTO PASTOR BRAVO MZA. 3PB LOTE. 75', 'LIMA - LIMA - SAN MARTIN DE PORRES - CAL.JUSTO PASTOR BRAVO MZA. 3PB LOTE. 75', '1'),
(54, 'BOTICA INGA FARMA', 'BOTICA INGA FARMA', 'RUC', '10336522167', 'BOTICAINGAFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'SANTA ANITA', 'AV. LA CULTURA MZA. G LOTE. 3 COO. VIÑA', 'LIMA - LIMA - SANTA ANITA - AV. LA CULTURA MZA. G LOTE. 3 COO. VIÑA', '1'),
(55, 'NEGOCIACIONES MACHUCA E.I.R.L.', 'NEGOCIACIONES MACHUCA E.I.R.L.', 'RUC', '20600952561', 'NEGOCIACIONESMACHUCAEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LOS OLIVOS', 'AV. RIO MARAÑON MZA. 12 LOT. 34  1', 'LIMA - LIMA - LOS OLIVOS - AV. RIO MARAÑON MZA. 12 LOT. 34  1', '1'),
(56, 'PEREZ ROJAS DANIEL', 'PEREZ ROJAS DANIEL', 'RUC', '10070391894', 'PEREZROJASDANIEL@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'AV. SAN MARTIN 750 INT.B51', 'LIMA - LIMA - CHORRILLOS - AV. SAN MARTIN 750 INT.B51', '1'),
(57, 'ANBECORP E.I.R.L.', 'ANBECORP E.I.R.L.', 'RUC', '20602644279', 'ANBECORPEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN BORJA', 'AV. SAN LUIS 1990 INT. A', 'LIMA - LIMA - SAN BORJA - AV. SAN LUIS 1990 INT. A', '1'),
(58, 'ZEVALLOS VILLENA ANGEL VICTOR', 'ZEVALLOS VILLENA ANGEL VICTOR', 'RUC', '10404556351', 'ZEVALLOSVILLENAANGELVICTOR@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'SECTOR A MZA. 37 LOT. 13', 'LIMA - LIMA - LIMA - SECTOR A MZA. 37 LOT. 13', '1'),
(59, 'BOTICA ANDRU', 'BOTICA ANDRU', 'RUC', '10435574381', 'BOTICAANDRU@gmail.com', '99915482', 'LIMA', 'LIMA', 'EL AGUSTINO', 'JR. LOS LIRIOS NRO. 282 URB. LA PRIMAVER', 'LIMA - LIMA - EL AGUSTINO - JR. LOS LIRIOS NRO. 282 URB. LA PRIMAVER', '1'),
(60, 'BOTICA MELCHORITA', 'BOTICA MELCHORITA', 'RUC', '10425275807', 'BOTICAMELCHORITA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. CARLOS A. SACO NRO. 307 INT. A LIMA', 'LIMA - LIMA - LA VICTORIA - JR. CARLOS A. SACO NRO. 307 INT. A LIMA', '1'),
(61, 'BOTICA ALCAFARMA', 'BOTICA ALCAFARMA', 'RUC', '10412227773', 'BOTICAALCAFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'ANCON', 'CAL.GUAQUI S/N MZA. C LOTE. 28 INT. I UR', 'LIMA - LIMA - ANCON - CAL.GUAQUI S/N MZA. C LOTE. 28 INT. I UR', '1'),
(62, 'BOTICAS MÁS VIDA', 'BOTICAS MÁS VIDA', 'RUC', '20602605958', 'BOTICASMÁSVIDA@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'MZA. F4 LOTE. 4 INT. 1 A.H. TUPAC AMARU', 'LIMA - LIMA - CHORRILLOS - MZA. F4 LOTE. 4 INT. 1 A.H. TUPAC AMARU', '1'),
(63, 'BAZAN MAYTA CARLA YRENE', 'BAZAN MAYTA CARLA YRENE', 'RUC', '10100471995', 'BAZANMAYTACARLAYRENE@gmail.com', '99915482', 'LIMA', 'LIMA', 'SANTA ANITA', 'AVENIDA TUPAC AMARU 514', 'LIMA - LIMA - SANTA ANITA - AVENIDA TUPAC AMARU 514', '1'),
(64, 'ESPINOZA ALVARADO DIANA LIZBETH', 'ESPINOZA ALVARADO DIANA LIZBETH', 'RUC', '10475075515', 'ESPINOZAALVARADODIANALIZBETH@gmail.com', '99915482', 'LIMA', 'LIMA', 'LOS OLIVOS', 'AV. ROMULO BETANCURT', 'LIMA - LIMA - LOS OLIVOS - AV. ROMULO BETANCURT', '1'),
(65, 'MEDIFARMA SA', 'MEDIFARMA SA', 'RUC', '20100018625', 'MEDIFARMASA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR ECUADOR NRO 787   -   LIMA', 'LIMA - LIMA - LIMA - JR ECUADOR NRO 787   -   LIMA', '1'),
(66, 'BOTICA FAMILIAR', 'BOTICA FAMILIAR', 'RUC', '10326567961', 'BOTICAFAMILIAR@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'AV. PASEO DE LA REPUBLICA NRO. 836 URB.', 'LIMA - LIMA - CHORRILLOS - AV. PASEO DE LA REPUBLICA NRO. 836 URB.', '1'),
(67, 'AILU INVERSIONES E.I.R.L.', 'AILU INVERSIONES E.I.R.L.', 'RUC', '20601526795', 'AILUINVERSIONESEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO 926 3074', 'LIMA - LIMA - LIMA - JR. PARURO 926 3074', '1'),
(68, 'BOTICA LAS ALCAPARRAS', 'BOTICA LAS ALCAPARRAS', 'RUC', '20602244149', 'BOTICALASALCAPARRAS@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'CAL.LAS ALCAPARRAS NRO. 536A COO. LAS FL', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - CAL.LAS ALCAPARRAS NRO. 536A COO. LAS FL', '1'),
(69, 'BOTICA SOLIDARIA', 'BOTICA SOLIDARIA', 'RUC', '20600985591', 'BOTICASOLIDARIA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LOS OLIVOS', 'AV. ANGELICA GAMARRA DE LEON VELARDE NRO', 'LIMA - LIMA - LOS OLIVOS - AV. ANGELICA GAMARRA DE LEON VELARDE NRO', '1'),
(70, 'LA REPOSTRERIE S.A.C.', 'LA REPOSTRERIE S.A.C.', 'RUC', '20601946981', 'LAREPOSTRERIESAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'CAL.MARIANO CARRANZA NRO. 226 DPTO. 608', 'LIMA - LIMA - LIMA - CAL.MARIANO CARRANZA NRO. 226 DPTO. 608', '1'),
(71, 'BOTICA JERUSALEN', 'BOTICA JERUSALEN', 'RUC', '20535740764', 'BOTICAJERUSALEN@gmail.com', '99915482', 'LIMA', 'LIMA', 'BREÑA', 'AV. JUAN PABLO FERNANDINI NRO. 877', 'LIMA - LIMA - BREÑA - AV. JUAN PABLO FERNANDINI NRO. 877', '1'),
(72, 'BOTICA ROSSY FARMA', 'BOTICA ROSSY FARMA', 'RUC', '10474781467', 'BOTICAROSSYFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LURIGANCHO', 'AV. HEROES DE CENEPA MZA. QI LOTE. 16 SA', 'LIMA - LIMA - SAN JUAN DE LURIGANCHO - AV. HEROES DE CENEPA MZA. QI LOTE. 16 SA', '1'),
(73, 'D`VERAMENDI FARMA S.A.C.', 'D`VERAMENDI FARMA S.A.C.', 'RUC', '20602425283', 'D`VERAMENDIFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'CAL.8 MZ. A-01 LOT. 06  INT. A', 'LIMA - LIMA - CHORRILLOS - CAL.8 MZ. A-01 LOT. 06  INT. A', '1'),
(74, 'CORPORACION DIALEX S.A.C.', 'CORPORACION DIALEX S.A.C.', 'RUC', '20548624585', 'CORPORACIONDIALEXSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. SANTO TOMAS DE AQUINO - 3ER- PISO MZ', 'LIMA - LIMA - LIMA - JR. SANTO TOMAS DE AQUINO - 3ER- PISO MZ', '1'),
(75, 'GP PHARM S.A.', 'GP PHARM S.A.', 'RUC', '20347605515', 'GPPHARMSA@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS                    ', 'CLLE UNIVERSO 367 URB LA CAMPIÑA', 'LIMA - LIMA - CHORRILLOS                     - CLLE UNIVERSO 367 URB LA CAMPIÑA', '1'),
(76, 'DISTRIBUIDORA M Y D MEDIC E.I.R.L.', 'DISTRIBUIDORA M Y D MEDIC E.I.R.L.', 'RUC', '20601464641', 'DISTRIBUIDORAMYDMEDICEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO NRO. 926 INT. 2005 URB. BARRI', 'LIMA - LIMA - LIMA - JR. PARURO NRO. 926 INT. 2005 URB. BARRI', '1'),
(77, 'COMERCIAL & DISTRIBUIDORA QUALITY E.I.R.', 'COMERCIAL & DISTRIBUIDORA QUALITY E.I.R.', 'RUC', '20602915795', 'COMERCIAL&DISTRIBUIDORAQUALITYEIR@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. CUSCO NRO. 783 (STAND 1052-M)', 'LIMA - LIMA - LIMA - JR. CUSCO NRO. 783 (STAND 1052-M)', '1'),
(78, 'CORPORACION P.C E.I.R.L', 'CORPORACION P.C E.I.R.L', 'RUC', '20478155256', 'CORPORACIONPCEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. CUZCO 572 141', 'LIMA - LIMA - LIMA - JR. CUZCO 572 141', '1'),
(79, 'CUADROS ARANDA JUSTA', 'CUADROS ARANDA JUSTA', 'RUC', '10093681369', 'CUADROSARANDAJUSTA@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVAD', 'AV. 1 DE MAYO MZA. F LOTE. 22', 'LIMA - LIMA - VILLA EL SALVAD - AV. 1 DE MAYO MZA. F LOTE. 22', '1'),
(80, 'FARMACIA DE CLINICA MUNICIPAL', 'FARMACIA DE CLINICA MUNICIPAL', 'RUC', '20601544254', 'FARMACIADECLINICAMUNICIPAL@gmail.com', '99915482', 'LIMA', 'LIMA', 'SANTA ANITA', 'CAL.ZARZAMORAS MZA. Q LOTE. 2 INT. 101 U', 'LIMA - LIMA - SANTA ANITA - CAL.ZARZAMORAS MZA. Q LOTE. 2 INT. 101 U', '1'),
(81, 'INVERSIONES & NEGOCIACIONES', 'INVERSIONES & NEGOCIACIONES', 'RUC', '20601845530', 'INVERSIONES&NEGOCIACIONES@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. INAMBARI 731 DPTO. 1', 'LIMA - LIMA - LIMA - JR. INAMBARI 731 DPTO. 1', '1'),
(82, 'BOTICA ALEFARMA', 'BOTICA ALEFARMA', 'RUC', '10420603491', 'BOTICAALEFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'CAL.JUAN CRESPO Y CASTILLO NRO. 2884 P.J', 'LIMA - LIMA - LIMA - CAL.JUAN CRESPO Y CASTILLO NRO. 2884 P.J', '1'),
(83, 'BOTICA DENTAL MILACAR  EIRL', 'BOTICA DENTAL MILACAR  EIRL', 'RUC', '20566134552', 'BOTICADENTALMILACAREIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. EMANCIPACION 319-325-331 NRO. 319 IN', 'LIMA - LIMA - LIMA - AV. EMANCIPACION 319-325-331 NRO. 319 IN', '1'),
(84, 'BOTICA FARMACENTRAL', 'BOTICA FARMACENTRAL', 'RUC', '10096359522', 'BOTICAFARMACENTRAL@gmail.com', '99915482', 'LIMA', 'LIMA', 'ATE', 'AV. VICTOR RAUL HAYA DE LA TORRE NRO. 10', 'LIMA - LIMA - ATE - AV. VICTOR RAUL HAYA DE LA TORRE NRO. 10', '1'),
(85, 'BOTICA DEL PUEBLO I', 'BOTICA DEL PUEBLO I', 'RUC', '20546031935', 'BOTICADELPUEBLOI@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PUNO NRO. 1565', 'LIMA - LIMA - LIMA - JR. PUNO NRO. 1565', '1'),
(86, 'NEGOCIACIONES SAN AGUSTIN S.R.L.', 'NEGOCIACIONES SAN AGUSTIN S.R.L.', 'RUC', '20543323439', 'NEGOCIACIONESSANAGUSTINSRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. CUZCO 783 2045', 'LIMA - LIMA - LIMA - JR. CUZCO 783 2045', '1'),
(87, 'FARMACHIF S.R.L.', 'FARMACHIF S.R.L.', 'RUC', '20504007864', 'FARMACHIFSRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'MIRAFLORES', 'AV. MARISCAL LA MAR NRO. 318 (OF. ADM. PISO 2)', 'LIMA - LIMA - MIRAFLORES - AV. MARISCAL LA MAR NRO. 318 (OF. ADM. PISO 2)', '1'),
(88, 'FARMACHIF S.R.L.', 'FARMACHIF S.R.L.', 'RUC', '20504007864', 'FARMACHIFSRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'MIRAFLORES', 'AV. MARISCAL LA MAR NRO. 318 (OF. ADM. PISO 2)', 'LIMA - LIMA - MIRAFLORES - AV. MARISCAL LA MAR NRO. 318 (OF. ADM. PISO 2)', '1'),
(89, 'BOTICAS NEWFARMA PERU E.I.R.L.', 'BOTICAS NEWFARMA PERU E.I.R.L.', 'RUC', '20601044961', 'BOTICASNEWFARMAPERUEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'SANTA ANITA', 'MZA. A-29 LOTE. 24 URB. CULTURA PERUANA MODERNA (E', 'LIMA - LIMA - SANTA ANITA - MZA. A-29 LOTE. 24 URB. CULTURA PERUANA MODERNA (ESPALDA DE TECSUP) LIMA', '1'),
(90, 'DROGUERIA DISTRIBUIDORA SANTO', 'DROGUERIA DISTRIBUIDORA SANTO', 'RUC', '20535540757', 'DROGUERIADISTRIBUIDORASANTO@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. ANTONIO MIROQUESADA 806 203', 'LIMA - LIMA - LIMA - JR. ANTONIO MIROQUESADA 806 203', '1'),
(91, 'VIDFAR S.A.C.', 'VIDFAR S.A.C.', 'RUC', '20601373514', 'VIDFARSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVAD', 'AV. MICAELA BASTIDAS MZ. J LOTE 14  A-1', 'LIMA - LIMA - VILLA EL SALVAD - AV. MICAELA BASTIDAS MZ. J LOTE 14  A-1', '1'),
(92, 'TAMBOFARMA S.A.C.', 'TAMBOFARMA S.A.C.', 'RUC', '20602561977', 'TAMBOFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'PUENTE PIEDRA', 'MZA. A LOTE. 01 INT. E', 'LIMA - LIMA - PUENTE PIEDRA - MZA. A LOTE. 01 INT. E', '1'),
(93, 'CENTRO MEDICO MI DOCTORCITO', 'CENTRO MEDICO MI DOCTORCITO', 'RUC', '20600342194', 'CENTROMEDICOMIDOCTORCITO@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MARTIN DE PORRES', 'AV. HONORIO DELGADO NRO. 357 URB. INGENIERIA', 'LIMA - LIMA - SAN MARTIN DE PORRES - AV. HONORIO DELGADO NRO. 357 URB. INGENIERIA', '1'),
(94, 'BOTICA SELFARMA', 'BOTICA SELFARMA', 'RUC', '10429788388', 'BOTICASELFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. NICOLAS DE PIEROLA NRO. 415', 'LIMA - LIMA - LIMA - AV. NICOLAS DE PIEROLA NRO. 415', '1'),
(95, 'VERGARAY JAQUE MACARIO', 'VERGARAY JAQUE MACARIO', 'RUC', '10068407384', 'VERGARAYJAQUEMACARIO@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'AV. SINCHI ROCA MZA. Z LT.11', 'LIMA - LIMA - COMAS - AV. SINCHI ROCA MZA. Z LT.11', '1'),
(96, 'FARMACHIF S.R.L.', 'FARMACHIF S.R.L.', 'RUC', '20504007864', 'FARMACHIFSRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'MIRAFLORES', 'AV. MARISCAL LA MAR NRO. 318 (OF. ADM. PISO 2)', 'LIMA - LIMA - MIRAFLORES - AV. MARISCAL LA MAR NRO. 318 (OF. ADM. PISO 2)', '1'),
(97, 'FEDERACION PERUANA DE RUGBY', 'FEDERACION PERUANA DE RUGBY', 'RUC', '20514312193', 'FEDERACIONPERUANADERUGBY@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN BORJA                     ', 'AV. LUIS ALDANA NRO. 155 DPTO. 502', 'LIMA - LIMA - SAN BORJA                      - AV. LUIS ALDANA NRO. 155 DPTO. 502', '1'),
(98, 'ARCANGEL MIGUEL', 'ARCANGEL MIGUEL', 'RUC', '20602679404', 'ARCANGELMIGUEL@gmail.com', '99915482', 'LIMA', 'LIMA', 'INDEPENDENCIA', 'AV. LOS PINOS NRO. 342 URB. EL ERMITAÑO', 'LIMA - LIMA - INDEPENDENCIA - AV. LOS PINOS NRO. 342 URB. EL ERMITAÑO', '1'),
(99, 'COBEFAR S.A.C.', 'COBEFAR S.A.C.', 'RUC', '20600546041', 'COBEFARSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. ANTONIO MIROQUEZADA NRO. 806 INT. 205 LIMA - L', 'LIMA - LIMA - LIMA - JR. ANTONIO MIROQUEZADA NRO. 806 INT. 205 LIMA - LIMA - LIMA', '1'),
(100, 'OROSCO CHAVEZ FRANCISCA SUJEI', 'OROSCO CHAVEZ FRANCISCA SUJEI', 'RUC', '10400352998', 'OROSCOCHAVEZFRANCISCASUJEI@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'MZA. F1 LOT. 14A', 'LIMA - LIMA - CHORRILLOS - MZA. F1 LOT. 14A', '1'),
(101, 'PHAR+SALUD', 'PHAR+SALUD', 'RUC', '20601172284', 'PHAR+SALUD@gmail.com', '99915482', 'LIMA', 'LIMA', 'SANTIAGO DE SURCO', 'CAL.PUERTA DEL SOL NRO. 125 URB. LA CASTELLANA LIM', 'LIMA - LIMA - SANTIAGO DE SURCO - CAL.PUERTA DEL SOL NRO. 125 URB. LA CASTELLANA LIMA - LIMA - SANTI', '1'),
(102, 'BOTICAÂ´S LR VIDA PHARMA', 'BOTICAÂ´S LR VIDA PHARMA', 'RUC', '20565479831', 'BOTICAÂ´SLRVIDAPHARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'CARABAYLLO', 'MZA. A LOTE. 2 A.H. EL DORADO', 'LIMA - LIMA - CARABAYLLO - MZA. A LOTE. 2 A.H. EL DORADO', '1'),
(103, 'BOTICA VALERFARMA', 'BOTICA VALERFARMA', 'RUC', '10450603274', 'BOTICAVALERFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV.MATERIALES #2018', 'LIMA - LIMA - LIMA - AV.MATERIALES #2018', '1'),
(104, 'MULTIFARMA ARROYO S.A.C.', 'MULTIFARMA ARROYO S.A.C.', 'RUC', '20602579647', 'MULTIFARMAARROYOSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'EL AGUSTINO', 'PJ. SAN PEDRO MZA. E1 LOT. 13', 'LIMA - LIMA - EL AGUSTINO - PJ. SAN PEDRO MZA. E1 LOT. 13', '1'),
(105, 'COBEFAR SAC', 'COBEFAR SAC', 'RUC', '20600546041', 'COBEFARSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR.A.MIROQUESADA #806 INT.205', 'LIMA - LIMA - LIMA - JR.A.MIROQUESADA #806 INT.205', '1'),
(106, 'COBEFAR S.A.C.', 'COBEFAR S.A.C.', 'RUC', '20600546041', 'COBEFARSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. ANTONIO MIROQUEZADA 806 INT. 205', 'LIMA - LIMA - LIMA - JR. ANTONIO MIROQUEZADA 806 INT. 205', '1'),
(107, 'GUTIERREZ PALOMINO CLAYDEX', 'GUTIERREZ PALOMINO CLAYDEX', 'RUC', '10478323102', 'GUTIERREZPALOMINOCLAYDEX@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'AV. SAN MARTIN 750 INT. 855', 'LIMA - LIMA - CHORRILLOS - AV. SAN MARTIN 750 INT. 855', '1'),
(108, 'COBEFAR S.A.C.', 'COBEFAR S.A.C.', 'RUC', '20600546041', 'COBEFARSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. ANTONIO MIROQUEZADA NRO. 806 INT. 20', 'LIMA - LIMA - LIMA - JR. ANTONIO MIROQUEZADA NRO. 806 INT. 20', '1'),
(109, 'NEGOCIACIONES SAN AGUSTIN S.R.L', 'NEGOCIACIONES SAN AGUSTIN S.R.L', 'RUC', '20543323439', 'NEGOCIACIONESSANAGUSTINSRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'Jr cuzco 783- interior 238', 'LIMA - LIMA - LIMA - Jr cuzco 783- interior 238', '1'),
(110, 'CORPORACION FARMACEUTICA ED S.A.C.', 'CORPORACION FARMACEUTICA ED S.A.C.', 'RUC', '20601999464', 'CORPORACIONFARMACEUTICAEDSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LUR', 'AV. CANTO GRANDE MZA. H LOTE. 26', 'LIMA - LIMA - SAN JUAN DE LUR - AV. CANTO GRANDE MZA. H LOTE. 26', '1'),
(111, 'GUTIERREZ NARVAEZ YSABEL ROXANA', 'GUTIERREZ NARVAEZ YSABEL ROXANA', 'RUC', '10107787017', 'GUTIERREZNARVAEZYSABELROXANA@gmail.com', '99915482', 'LIMA', 'LIMA', 'INDEPENDENCIA', 'JR. CAJABAMBA NRO. 281 URB. TUPAC AMARU (ALT PARAD', 'LIMA - LIMA - INDEPENDENCIA - JR. CAJABAMBA NRO. 281 URB. TUPAC AMARU (ALT PARADERO LA POSTA EN PAYE', '1'),
(112, 'NORDIC PHARMACEUTICAL COMPANY S.A.C', 'NORDIC PHARMACEUTICAL COMPANY S.A.C', 'RUC', '20503794692', 'NORDICPHARMACEUTICALCOMPANYSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. PATRICIO IRIARTE NRO. 279', 'LIMA - LIMA - LA VICTORIA - JR. PATRICIO IRIARTE NRO. 279', '1'),
(113, 'CLINICA JESUS DEL NORTE S.A.C.', 'CLINICA JESUS DEL NORTE S.A.C.', 'RUC', '20517738701', 'CLINICAJESUSDELNORTESAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'INDEPENDENCIA                 ', 'AV. CARLOS IZAGUIRRE NRO. 153 Z.I. NORTE', 'LIMA - LIMA - INDEPENDENCIA                  - AV. CARLOS IZAGUIRRE NRO. 153 Z.I. NORTE', '1'),
(114, 'CLINICA SANTA MARIA DEL SUR S.A.C.', 'CLINICA SANTA MARIA DEL SUR S.A.C.', 'RUC', '20517737560', 'CLINICASANTAMARIADELSURSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE MIRAFLORES        ', 'AV. BELISARIO SUAREZ NRO. 998', 'LIMA - LIMA - SAN JUAN DE MIRAFLORES         - AV. BELISARIO SUAREZ NRO. 998', '1'),
(115, 'INVERSIONES OD2 E.I.R.L.', 'INVERSIONES OD2 E.I.R.L.', 'RUC', '20546402186', 'INVERSIONESOD2EIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. EMANCIPACION 343 136 -137', 'LIMA - LIMA - LIMA - AV. EMANCIPACION 343 136 -137', '1'),
(116, 'HERNANDEZ GONZALES SONIA ROSELEY', 'HERNANDEZ GONZALES SONIA ROSELEY', 'RUC', '10730233324', 'HERNANDEZGONZALESSONIAROSELEY@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. ROBERTO THORNDIKE GALLUP 1412 5-8', 'LIMA - LIMA - LIMA - AV. ROBERTO THORNDIKE GALLUP 1412 5-8', '1'),
(117, 'COMERCIAL DON RAMIRO S.A.C', 'COMERCIAL DON RAMIRO S.A.C', 'RUC', '20602750281', 'COMERCIALDONRAMIROSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LUR', 'JR. COLLASUYO 238 INT. A', 'LIMA - LIMA - SAN JUAN DE LUR - JR. COLLASUYO 238 INT. A', '1'),
(118, 'MISTER BODEGA S.A.C.', 'MISTER BODEGA S.A.C.', 'RUC', '20601272289', 'MISTERBODEGASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'CAL.M MZA. B2 LOT. 22B', 'LIMA - LIMA - CHORRILLOS - CAL.M MZA. B2 LOT. 22B', '1'),
(119, 'CORPORACION GEMINIS PERU E.I.R.L.', 'CORPORACION GEMINIS PERU E.I.R.L.', 'RUC', '20552904312', 'CORPORACIONGEMINISPERUEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. ANDAHUAYLAS 991 A', 'LIMA - LIMA - LIMA - JR. ANDAHUAYLAS 991 A', '1'),
(120, 'BOTICA BIENESTAR', 'BOTICA BIENESTAR', 'RUC', '20451656806', 'BOTICABIENESTAR@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. MIGUEL BAQUERO NRO. 328', 'LIMA - LIMA - LIMA - JR. MIGUEL BAQUERO NRO. 328', '1'),
(121, 'DISTRIBUIDORA JENNLY S.A.C.', 'DISTRIBUIDORA JENNLY S.A.C.', 'RUC', '20563733064', 'DISTRIBUIDORAJENNLYSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. HUANCAYO NRO. 452 A.H. URB. PERU - Z', 'LIMA - LIMA - LIMA - JR. HUANCAYO NRO. 452 A.H. URB. PERU - Z', '1'),
(122, 'HERENCIA ALCARRAZ MARIELA JOVANA', 'HERENCIA ALCARRAZ MARIELA JOVANA', 'RUC', '10221033413', 'HERENCIAALCARRAZMARIELAJOVANA@gmail.com', '99915482', 'LIMA', 'LIMA', 'CHORRILLOS', 'AV. EL SOL MZ. Q LT. 1F', 'LIMA - LIMA - CHORRILLOS - AV. EL SOL MZ. Q LT. 1F', '1'),
(123, 'EURO COSMETICS E.I.R.L.', 'EURO COSMETICS E.I.R.L.', 'RUC', '20388798476', 'EUROCOSMETICSEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LINCE', 'AV PETIT THOUARS 2250', 'LIMA - LIMA - LINCE - AV PETIT THOUARS 2250', '1'),
(124, 'REPRESENTACIONES LITO E.I.R.L.', 'REPRESENTACIONES LITO E.I.R.L.', 'RUC', '20508931469', 'REPRESENTACIONESLITOEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE LUR', 'AV. CANTO GRANDE 2720', 'LIMA - LIMA - SAN JUAN DE LUR - AV. CANTO GRANDE 2720', '1'),
(125, 'GR FARMANOVA S.A.C.', 'GR FARMANOVA S.A.C.', 'RUC', '20601428238', 'GRFARMANOVASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVAD', 'MZA. F LOTE 16', 'LIMA - LIMA - VILLA EL SALVAD - MZA. F LOTE 16', '1'),
(126, 'DXL APPAREL GROUP SAC', 'DXL APPAREL GROUP SAC', 'RUC', '20505239262', 'DXLAPPARELGROUPSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'MIRAFLORES                    ', 'PARQUE FEDERICO BLUME 142', 'LIMA - LIMA - MIRAFLORES                     - PARQUE FEDERICO BLUME 142', '1'),
(127, 'DISTRIBUCIONES SELMAC S.A.C.', 'DISTRIBUCIONES SELMAC S.A.C.', 'RUC', '20602772935', 'DISTRIBUCIONESSELMACSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR. PARURO 926 INT. 212', 'LIMA - LIMA - LIMA - JR. PARURO 926 INT. 212', '1'),
(128, 'BOTICA MIAFARMA', 'BOTICA MIAFARMA', 'RUC', '10424125445', 'BOTICAMIAFARMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV. ARENALES # 901 (A MEDIA CDRA. DE REP', 'LIMA - LIMA - LIMA - AV. ARENALES # 901 (A MEDIA CDRA. DE REP', '1'),
(129, 'SLIM NEGOCIOS PERUANOS S.A.C.', 'SLIM NEGOCIOS PERUANOS S.A.C.', 'RUC', '20555611332', 'SLIMNEGOCIOSPERUANOSSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'INAMBARI NRO. 711', 'LIMA - LIMA - LIMA - INAMBARI NRO. 711', '1'),
(130, 'INVERSIONES MAX', 'INVERSIONES MAX', 'RUC', '10062236308', 'INVERSIONESMAX@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR.PARURO #926 INT.1056-M', 'LIMA - LIMA - LIMA - JR.PARURO #926 INT.1056-M', '1'),
(131, 'YANAC CACERES DIANA SILVIA', 'YANAC CACERES DIANA SILVIA', 'RUC', '10763213213', 'YANACCACERESDIANASILVIA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LOS OLIVOS', 'CALLE 1 SANTA TERESITA, MZ.J, LT 24', 'LIMA - LIMA - LOS OLIVOS - CALLE 1 SANTA TERESITA, MZ.J, LT 24', '1'),
(132, 'GOMEZ ALBORNOZ  MILKER', 'GOMEZ ALBORNOZ  MILKER', 'RUC', '10067897418', 'GOMEZALBORNOZMILKER@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVAD', 'BARRIO 2 SECTOR 2 MZA. A LOT. 01', 'LIMA - LIMA - VILLA EL SALVAD - BARRIO 2 SECTOR 2 MZA. A LOT. 01', '1'),
(133, 'UNIVERSO COMERCIAL DEL PERU S.A.C.', 'UNIVERSO COMERCIAL DEL PERU S.A.C.', 'RUC', '20544142772', 'UNIVERSOCOMERCIALDELPERUSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SURQUILLO', 'CAL.VICTOR ALZAMORA 210', 'LIMA - LIMA - SURQUILLO - CAL.VICTOR ALZAMORA 210', '1'),
(134, 'IVAL FARMA S.A.C.', 'IVAL FARMA S.A.C.', 'RUC', '20601554799', 'IVALFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'R. LUCANAS NRO. 148 INT. 2DO P.J. VILLA', 'LIMA - LIMA - LIMA - R. LUCANAS NRO. 148 INT. 2DO P.J. VILLA', '1'),
(135, 'VDC REPRESENTANCIONES EIRL', 'VDC REPRESENTANCIONES EIRL', 'RUC', '20485088041', 'VDCREPRESENTANCIONESEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'CALLE ALEMANIA 2455', 'LIMA - LIMA - LIMA - CALLE ALEMANIA 2455', '1'),
(136, 'POMA HUAROC MIRIAM JANET SARITA', 'POMA HUAROC MIRIAM JANET SARITA', 'RUC', '10453722673', 'POMAHUAROCMIRIAMJANETSARITA@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVAD', 'MZA. G LOT. 16', 'LIMA - LIMA - VILLA EL SALVAD - MZA. G LOT. 16', '1'),
(137, 'OMNIA MEDICA SAC', 'OMNIA MEDICA SAC', 'RUC', '20100349061', 'OMNIAMEDICASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'MAGDALENA DEL MAR', 'JR. MARISCAL LA MAR NRO. 991 (EX. UGARTE Y MOSCOSO', 'LIMA - LIMA - MAGDALENA DEL MAR - JR. MARISCAL LA MAR NRO. 991 (EX. UGARTE Y MOSCOSO - PISO 3)', '1'),
(138, 'PHARMA GREEN COMPANY SAC', 'PHARMA GREEN COMPANY SAC', 'RUC', '20602801358', 'PHARMAGREENCOMPANYSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MIGUEL                    ', 'CALLE NAYLAMP 190 URB MARANGA', 'LIMA - LIMA - SAN MIGUEL                     - CALLE NAYLAMP 190 URB MARANGA', '1'),
(139, 'ASOCIACION DE VOLUNTARIAS POR LOS NIÑOS', 'ASOCIACION DE VOLUNTARIAS POR LOS NIÑOS', 'RUC', '20538358640', 'ASOCIACIONDEVOLUNTARIASPORLOSNIÑOS@gmail.com', '99915482', 'LIMA', 'LIMA', 'SURQUILLO           ', 'JR. SAN AGUSTIN NRO. 634 URB. SAN JORGE', 'LIMA - LIMA - SURQUILLO            - JR. SAN AGUSTIN NRO. 634 URB. SAN JORGE', '1'),
(140, 'BOTICA QUIMFARMA SAC', 'BOTICA QUIMFARMA SAC', 'RUC', '20602438741', 'BOTICAQUIMFARMASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'AV.REYNALDO SAAVEDRA P. #2637', 'LIMA - LIMA - LIMA - AV.REYNALDO SAAVEDRA P. #2637', '1'),
(141, 'VITALIS PERU SAC', 'VITALIS PERU SAC', 'RUC', '20503300525', 'VITALISPERUSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'MIRAFLORES                    ', 'CLL ENRIQUE PALACIOS 423 OF302', 'LIMA - LIMA - MIRAFLORES                     - CLL ENRIQUE PALACIOS 423 OF302', '1'),
(142, 'BOTICA VIDA & SALUD', 'BOTICA VIDA & SALUD', 'RUC', '20602357962', 'BOTICAVIDA&SALUD@gmail.com', '99915482', 'LIMA', 'LIMA', 'LIMA', 'JR.RAMON CARCAMO #791 DPTO.601', 'LIMA - LIMA - LIMA - JR.RAMON CARCAMO #791 DPTO.601', '1'),
(143, 'INVERSIONES MARY E.I.R.L.', 'INVERSIONES MARY E.I.R.L.', 'RUC', '20551241671', 'INVERSIONESMARYEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'PJ. G2 NRO. SN INT. 760 (MERCADO MINORISTAS)', 'LIMA - LIMA - LA VICTORIA - PJ. G2 NRO. SN INT. 760 (MERCADO MINORISTAS)', '1'),
(144, 'DAFYE S.A.C.', 'DAFYE S.A.C.', 'RUC', '20563259567', 'DAFYESAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. PISAGUA NRO. 900 URB. SAN PABLO', 'LIMA - LIMA - LA VICTORIA - JR. PISAGUA NRO. 900 URB. SAN PABLO', '1'),
(145, 'IRIS VANESA DAVILA MASHAPANA', 'IRIS VANESA DAVILA MASHAPANA', 'RUC', '77327811000', 'IRISVANESADAVILAMASHAPANA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. PISAGUA 900', 'LIMA - LIMA - LA VICTORIA - JR. PISAGUA 900', '1'),
(146, 'COMERCIAL JAVIER', 'COMERCIAL JAVIER', 'RUC', '10424298340', 'COMERCIALJAVIER@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. ISABEL LA CATOLICA 1724', 'LIMA - LIMA - LA VICTORIA - AV. ISABEL LA CATOLICA 1724', '1'),
(147, 'E.R.M. INVERSIONES EIRL', 'E.R.M. INVERSIONES EIRL', 'RUC', '20514563609', 'ERMINVERSIONESEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. AVIACION NRO. 677 (ALT CDRA 6 DE AV AVIACION)', 'LIMA - LIMA - LA VICTORIA - AV. AVIACION NRO. 677 (ALT CDRA 6 DE AV AVIACION)', '1'),
(148, 'INVERSIONES NAYELYS & HUGOS E.I.R.L.', 'INVERSIONES NAYELYS & HUGOS E.I.R.L.', 'RUC', '20600704126', 'INVERSIONESNAYELYS&HUGOSEIRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. ISABEL LA CATOLICA NRO. 1724 URB. SAN PABLO', 'LIMA - LIMA - LA VICTORIA - AV. ISABEL LA CATOLICA NRO. 1724 URB. SAN PABLO', '1'),
(149, 'MEDINA YATACO JAVIER ENRIQUE', 'MEDINA YATACO JAVIER ENRIQUE', 'RUC', '10075280489', 'MEDINAYATACOJAVIERENRIQUE@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. PISAGUA 998', 'LIMA - LIMA - LA VICTORIA - JR. PISAGUA 998', '1'),
(150, 'VILLAFUERTE MIRANDA YESENIA AMPARO', 'VILLAFUERTE MIRANDA YESENIA AMPARO', 'RUC', '10096389774', 'VILLAFUERTEMIRANDAYESENIAAMPARO@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. ISABEL LA CATOLICA 1824', 'LIMA - LIMA - LA VICTORIA - AV. ISABEL LA CATOLICA 1824', '1'),
(151, 'JERSHON SANDOVAL', 'JERSHON SANDOVAL', 'RUC', '76058102000', 'JERSHONSANDOVAL@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'HIPOLITO UNANUE CDRA. 3 MERCADO LA PARADA MINORIST', 'LIMA - LIMA - LA VICTORIA - HIPOLITO UNANUE CDRA. 3 MERCADO LA PARADA MINORISTA (PSJE ADMINISTRATIVO', '1'),
(152, 'DHL GLOBAL FORWARDING PERU S.A.', 'DHL GLOBAL FORWARDING PERU S.A.', 'RUC', '20307328471', 'DHLGLOBALFORWARDINGPERUSA@gmail.com', '99915482', 'LIMA', 'LIMA', 'MAGDALENA DEL MAR             ', 'AV. PERSHING NRO. 465 INT. 1001', 'LIMA - LIMA - MAGDALENA DEL MAR              - AV. PERSHING NRO. 465 INT. 1001', '1'),
(153, 'COMERC. MAXIMILIANO Y LEONARDO', 'COMERC. MAXIMILIANO Y LEONARDO', 'RUC', '10433900940', 'COMERCMAXIMILIANOYLEONARDO@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. HIPOLITO UNANUE 18007 (Mdo. Minorista psje Adm', 'LIMA - LIMA - LA VICTORIA - JR. HIPOLITO UNANUE 18007 (Mdo. Minorista psje Administracion pto. 185)', '1'),
(154, 'NINAMASS', 'NINAMASS', 'RUC', '20547169159', 'NINAMASS@gmail.com', '99915482', 'LIMA', 'LIMA', 'COMAS', 'AV. ALFREDO MENDIOLA NRO. 7810 INT. 59 URB. PRO IN', 'LIMA - LIMA - COMAS - AV. ALFREDO MENDIOLA NRO. 7810 INT. 59 URB. PRO INDUSTRIAL (KM 22 PANM.NORTE F', '1'),
(155, 'SEGURA CARITA THEACHER', 'SEGURA CARITA THEACHER', 'RUC', '10403815603', 'SEGURACARITATHEACHER@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA MARIA DEL TRIUNFO', 'AV.  PRIMERO DE MAYO MZA. E LOTE. 3 INT. 259 (MERC', 'LIMA - LIMA - VILLA MARIA DEL TRIUNFO - AV.  PRIMERO DE MAYO MZA. E LOTE. 3 INT. 259 (MERCADO UNICAC', '1'),
(156, 'CUSI UMERES MARIA PILAR', 'CUSI UMERES MARIA PILAR', 'RUC', '10097838769', 'CUSIUMERESMARIAPILAR@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. HIPOLITO UNANUE CDRA. 3 MERCADO JORGE CHAVEZ', 'LIMA - LIMA - LA VICTORIA - AV. HIPOLITO UNANUE CDRA. 3 MERCADO JORGE CHAVEZ', '1'),
(157, 'CEFERINA PAULINA HUILLCA MERMA', 'CEFERINA PAULINA HUILLCA MERMA', 'RUC', '09233424000', 'CEFERINAPAULINAHUILLCAMERMA@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'HIPOLITO UNANUE CDRA. 3 MERCADO LA PARADA MINORIST', 'LIMA - LIMA - LA VICTORIA - HIPOLITO UNANUE CDRA. 3 MERCADO LA PARADA MINORISTA (PSJE K  PTO. 230)', '1'),
(158, 'CORPORACION JULEYRO S.A.C.', 'CORPORACION JULEYRO S.A.C.', 'RUC', '20603230907', 'CORPORACIONJULEYROSAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA MARIA DEL TRIUNFO', 'CAL.JHON F. KENNEDY MZA. W.2 LOTE. 14 P.J. H.POLIC', 'LIMA - LIMA - VILLA MARIA DEL TRIUNFO - CAL.JHON F. KENNEDY MZA. W.2 LOTE. 14 P.J. H.POLICIAL (ALTUR', '1'),
(159, 'COMERCIAL DEISY', 'COMERCIAL DEISY', 'RUC', '10409357143', 'COMERCIALDEISY@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'JR. PISAGUA 490', 'LIMA - LIMA - LA VICTORIA - JR. PISAGUA 490', '1'),
(160, 'PERCY BARBARAN SOTELO', 'PERCY BARBARAN SOTELO', 'RUC', '48644073000', 'PERCYBARBARANSOTELO@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVADOR', 'AV. 1 DE MAYO MZA. E PUESTO 304 (MERCADO UNICACHI)', 'LIMA - LIMA - VILLA EL SALVADOR - AV. 1 DE MAYO MZA. E PUESTO 304 (MERCADO UNICACHI)', '1'),
(161, 'MARCO ANTONY CABRERA MAMANI', 'MARCO ANTONY CABRERA MAMANI', 'RUC', '72079307000', 'MARCOANTONYCABRERAMAMANI@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVADOR', 'AV. 1RO DE MAYO - MERCADO UNICACHI INTERIOR PUESTO', 'LIMA - LIMA - VILLA EL SALVADOR - AV. 1RO DE MAYO - MERCADO UNICACHI INTERIOR PUESTO 306', '1'),
(162, 'SANDRA YAPUCHURA UCHARICO', 'SANDRA YAPUCHURA UCHARICO', 'RUC', '43416460000', 'SANDRAYAPUCHURAUCHARICO@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA EL SALVADOR', 'AV. 1RO DE MAYO MERCADO UNICACHI INTERIOR PUESTO 2', 'LIMA - LIMA - VILLA EL SALVADOR - AV. 1RO DE MAYO MERCADO UNICACHI INTERIOR PUESTO 230', '1'),
(163, 'VILLAFUERTE MIRANDA YESENIA AMPARO', 'VILLAFUERTE MIRANDA YESENIA AMPARO', 'RUC', '09638977000', 'VILLAFUERTEMIRANDAYESENIAAMPARO@gmail.com', '99915482', 'LIMA', 'LIMA', 'LA VICTORIA', 'AV. ISABEL LA CATOLICA 1824', 'LIMA - LIMA - LA VICTORIA - AV. ISABEL LA CATOLICA 1824', '1'),
(164, 'ALYJOV FARMA SRL', 'ALYJOV FARMA SRL', 'RUC', '20516746778', 'ALYJOVFARMASRL@gmail.com', '99915482', 'LIMA', 'LIMA', 'VILLA MARIA DEL TRIUNFO', 'AV. SAN MARTIN NRO. 1855 P.J. SAN GABRIE', 'LIMA - LIMA - VILLA MARIA DEL TRIUNFO - AV. SAN MARTIN NRO. 1855 P.J. SAN GABRIE', '1'),
(165, 'BOTICA NUEVA SALUD', 'BOTICA NUEVA SALUD', 'RUC', '20600159322', 'BOTICANUEVASALUD@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN MARTIN DE PORRES', 'AV. TANTAMAYO MZA. A LOTE. 5 RES. LOS ALAMOS (A DO', 'LIMA - LIMA - SAN MARTIN DE PORRES - AV. TANTAMAYO MZA. A LOTE. 5 RES. LOS ALAMOS (A DOS CUADRAS DE ', '1'),
(166, 'DEINER RUIZ MORAN', 'DEINER RUIZ MORAN', 'RUC', '46542059000', 'DEINERRUIZMORAN@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN JUAN DE MIRAFLORES', 'AV. LOS HEROES 515 INTERIOR PUESTO 77 MDO. CIUDAD ', 'LIMA - LIMA - SAN JUAN DE MIRAFLORES - AV. LOS HEROES 515 INTERIOR PUESTO 77 MDO. CIUDAD DE DIOS', '1'),
(167, 'ENERQUIMICA S.A.C.', 'ENERQUIMICA S.A.C.', 'RUC', '20208473523', 'ENERQUIMICASAC@gmail.com', '99915482', 'LIMA', 'LIMA', 'SAN LUIS                      ', 'CAL. CARLOS PEDEMONTE NRO. 142', 'LIMA - LIMA - SAN LUIS                       - CAL. CARLOS PEDEMONTE NRO. 142', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `confcomprobantes`
--

CREATE TABLE `confcomprobantes` (
  `idconfcomprobante` int(20) NOT NULL,
  `tipodocumento` varchar(40) COLLATE utf8_spanish_ci DEFAULT NULL,
  `serie` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL,
  `numero` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `confcomprobantes`
--

INSERT INTO `confcomprobantes` (`idconfcomprobante`, `tipodocumento`, `serie`, `numero`, `estado`) VALUES
(1, 'Boleta', 'F001', '16', 0),
(2, 'Boleta', 'B01', '10', 1),
(3, 'Factura', 'F01', '16', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `general`
--

CREATE TABLE `general` (
  `idgeneral` int(11) NOT NULL,
  `empresa` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipoimpuesto` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `impuesto` decimal(25,2) NOT NULL,
  `moneda` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(40) COLLATE utf8_spanish_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `direccion` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `logo` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `general`
--

INSERT INTO `general` (`idgeneral`, `empresa`, `tipoimpuesto`, `impuesto`, `moneda`, `email`, `telefono`, `direccion`, `logo`) VALUES
(1, 'Inversiones Ferreteras Ebenezer', 'IGV', '0.18', 'S/.', 'ifebenezer@gmail.com', '3877046', 'Lima - Lima - S.J.L', 'public/fotos/logo_ebe.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingresoalmacen`
--

CREATE TABLE `ingresoalmacen` (
  `idingresoalma` int(20) NOT NULL,
  `proveedor` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipocomprobante` varchar(40) COLLATE utf8_spanish_ci DEFAULT NULL,
  `impuesto` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `igv` decimal(25,2) DEFAULT NULL,
  `subtotal` decimal(25,2) DEFAULT NULL,
  `total` decimal(25,2) DEFAULT NULL,
  `serie` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `numero` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fechaderegistro` date NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `ingresoalmacen`
--

INSERT INTO `ingresoalmacen` (`idingresoalma`, `proveedor`, `tipocomprobante`, `impuesto`, `igv`, `subtotal`, `total`, `serie`, `numero`, `fechaderegistro`, `estado`) VALUES
(1, 'Mestro', 'Factura', '0.18', '0.00', '0.00', '0.00', '001', '2000041', '2018-07-08', 1),
(2, 'Mestro', 'Boleta', '0.18', '1296.00', '5904.00', '7200.00', 'F001', '2222', '2018-07-12', 1),
(3, 'Mestro', 'Boleta', '0.18', '982.80', '4477.20', '5460.00', 'F001', '2222', '2018-07-12', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `idpedido` int(11) NOT NULL,
  `idcliente` int(11) DEFAULT NULL,
  `cliente` varchar(80) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipocomprobante` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipopedido` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `impuesto` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `igv` decimal(25,2) DEFAULT NULL,
  `subtotal` decimal(25,2) DEFAULT NULL,
  `total` decimal(25,2) DEFAULT NULL,
  `fechaderegistro` date DEFAULT NULL,
  `fechadeentrega` date DEFAULT NULL,
  `estadodepedido` varchar(15) COLLATE utf8_spanish_ci NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `idpermiso` int(20) NOT NULL,
  `sucursal` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usuario` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipousuario` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `accesomm` int(1) DEFAULT NULL,
  `accesoma` int(1) DEFAULT NULL,
  `accesomc` int(1) DEFAULT NULL,
  `accesomv` int(1) DEFAULT NULL,
  `accesomcc` int(1) DEFAULT NULL,
  `accesomcv` int(1) DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `idproveedor` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `ruc` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `direccion` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`idproveedor`, `nombre`, `ruc`, `email`, `telefono`, `direccion`, `estado`) VALUES
(1, 'Mestro', '20112273922', 'http://www.maestro.com.pe', '631-0300', 'Panamericana Norte con Tómas Valle. Independencia', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reporte_clasificacion`
--

CREATE TABLE `reporte_clasificacion` (
  `indice` int(11) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `preciounitario` decimal(12,2) DEFAULT NULL,
  `valortotal` decimal(12,2) DEFAULT NULL,
  `nombrearticulo` varchar(150) COLLATE utf8mb4_bin DEFAULT NULL,
  `clasificacion` char(1) COLLATE utf8mb4_bin DEFAULT NULL,
  `tipo` char(1) COLLATE utf8mb4_bin DEFAULT NULL,
  `usuarioconsulta` int(11) DEFAULT '0',
  `idarticulo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Volcado de datos para la tabla `reporte_clasificacion`
--

INSERT INTO `reporte_clasificacion` (`indice`, `cantidad`, `preciounitario`, `valortotal`, `nombrearticulo`, `clasificacion`, `tipo`, `usuarioconsulta`, `idarticulo`) VALUES
(509, 100, '12.00', '1200.00', 'Alambre galvanizado 24\" - 100kg', 'A', '2', 0, 20),
(510, 100, '12.00', '1200.00', 'Alam Negro Recocido 8x25kg', 'B', '2', 0, 21),
(511, 100, '0.00', '0.00', 'Malla rashell rollo x 100m negro', 'C', '2', 0, 55),
(512, 100, '0.00', '0.00', 'Malla rashell rollo x 100m gris', 'C', '2', 0, 54),
(513, 100, '0.00', '0.00', 'Malla rashell azul rollo x 100m', 'C', '2', 0, 53),
(514, 100, '0.00', '0.00', 'Malla mosquitera mesh aluminio rollo x 30m', 'C', '2', 0, 52),
(515, 100, '0.00', '0.00', 'Malla mosquitera mesh verde rollo x 30m', 'C', '2', 0, 51),
(516, 100, '0.00', '0.00', 'Malla Hexagonal 3/4-0.90 Ml.', 'C', '2', 0, 50),
(517, 100, '0.00', '0.00', 'O-malla Tejida Negra/gris X Ml', 'C', '2', 0, 49),
(518, 100, '0.00', '0.00', 'Malla Cuadrada 3/4pxmetro.', 'C', '2', 0, 48),
(519, 100, '0.00', '0.00', 'Membrana asfáltica gravillada negro chema', 'C', '2', 0, 47),
(520, 100, '0.00', '0.00', 'Malla Mosqu Plast Az 0.9Mx30M', 'C', '2', 0, 46),
(521, 100, '0.00', '0.00', 'O-Malla Mosqui Plast Vde Ml', 'C', '2', 0, 45),
(522, 100, '0.00', '0.00', 'Malla Alambre Galvanizado Cuadrado 1/2\"', 'C', '2', 0, 44),
(523, 100, '0.00', '0.00', 'Malla Mosquitero Metálica x Metro Lineal', 'C', '2', 0, 43),
(524, 100, '0.00', '0.00', 'Escalera tijera madera 10 pasos', 'C', '2', 0, 42),
(525, 100, '0.00', '0.00', 'Escalera Multi Posición Aluminio 12 Pasos Aluminio', 'C', '2', 0, 41),
(526, 100, '0.00', '0.00', 'Escalera fibra de vidrio 6 pasos', 'C', '2', 0, 40),
(527, 100, '0.00', '0.00', 'Manga plast 60\" crstl r5m', 'C', '2', 0, 74),
(528, 100, '0.00', '0.00', 'Malla rashell rollo x 100m verde', 'C', '2', 0, 56),
(529, 100, '0.00', '0.00', 'Manga plast 60\" crstl r10m', 'C', '2', 0, 73),
(530, 100, '0.00', '0.00', 'Manga plast 1.5mx2.8mm neg r10m', 'C', '2', 0, 72),
(531, 100, '0.00', '0.00', 'Manga Plast 1.5mx2.8mm Neg R5m', 'C', '2', 0, 71),
(532, 100, '0.00', '0.00', 'Manga plast 1.5mx2.8mm az r5m', 'C', '2', 0, 70),
(533, 100, '0.00', '0.00', 'Malla Cuadrados 0.90 m x 1\" Gris', 'C', '2', 0, 69),
(534, 100, '0.00', '0.00', 'Malla tejida 2\" galvanizada pvc 14 rollo x 10m', 'C', '2', 0, 68),
(535, 100, '0.00', '0.00', 'Malla tejida 2\" galvanizada 14 rollo x 10m', 'C', '2', 0, 67),
(536, 100, '0.00', '0.00', 'Malla cuadrada galvanizada rollo x 30m 1\" - 0.9m', 'C', '2', 0, 66),
(537, 100, '0.00', '0.00', 'Manga plast 1.5mx2mm az r10m', 'C', '2', 0, 65),
(538, 100, '0.00', '0.00', 'Mangas plásticas negro 1.5m x 8 mm', 'C', '2', 0, 64),
(539, 100, '0.00', '0.00', 'Mangas plásticas gris 1.5m x 8 mm', 'C', '2', 0, 63),
(540, 100, '0.00', '0.00', 'Mangas plásticas azul 1.5m x 8 mm', 'C', '2', 0, 62),
(541, 100, '0.00', '0.00', 'Malla alambre galvanizado cuadrado 1\" x mt\"', 'C', '2', 0, 61),
(542, 100, '0.00', '0.00', 'Malla alambre galvanizado cuadrado 3/4\"\"', 'C', '2', 0, 60),
(543, 100, '0.00', '0.00', 'Malla Mosqu Plast Vde 0.9mx30m', 'C', '2', 0, 59),
(544, 100, '0.00', '0.00', 'Malla Mosquitero 0.90 m Negro', 'C', '2', 0, 58),
(545, 100, '0.00', '0.00', 'Broche pack x 25 bisagra', 'C', '2', 0, 57),
(546, 100, '0.00', '0.00', 'Escalera Tijera De Aluminio 3 Pasos', 'C', '2', 0, 39),
(547, 100, '0.00', '0.00', 'Escalera tijera de madera 12 pasos', 'C', '2', 0, 38),
(548, 100, '0.00', '0.00', 'Grapa malla 3/4 pulgadas x 14 pulgadas', 'C', '2', 0, 17),
(549, 100, '0.00', '0.00', 'Alambre Puas Sinch R200m', 'C', '2', 0, 16),
(550, 100, '0.00', '0.00', 'Alambre galvanizado nº 14 1 kg', 'C', '2', 0, 15),
(551, 100, '0.00', '0.00', 'Alambre Galvn #8 50kg', 'C', '2', 0, 14),
(552, 100, '0.00', '0.00', 'Alambre Recocido Nº 8 100 Kg', 'C', '2', 0, 13),
(553, 100, '0.00', '0.00', 'Alambre galvn 16 1kg', 'C', '2', 0, 12),
(554, 100, '0.00', '0.00', 'Alambre Puas Andn R200m', 'C', '2', 0, 11),
(555, 100, '0.00', '0.00', 'Cielo Raso Glass 1.20 x 0.60 m', 'C', '2', 0, 10),
(556, 100, '0.00', '0.00', 'Cielo raso baldosa radar', 'C', '2', 0, 9),
(557, 100, '0.00', '0.00', 'Cielo Raso Serene 1.2X0.6X12P8', 'C', '2', 0, 8),
(558, 100, '0.00', '0.00', 'Plancha tecnomix 2.40 x 1.20 x 2\"', 'C', '2', 0, 7),
(559, 100, '0.00', '0.00', 'Poliestireno Exp 2x1.2mx2.4m', 'C', '2', 0, 6),
(560, 100, '0.00', '0.00', 'Plancha de tecnopor', 'C', '2', 0, 5),
(561, 100, '0.00', '0.00', 'Lana Poliest Ecoterm 300GR/MT2', 'C', '2', 0, 4),
(562, 100, '0.00', '0.00', 'Lana De Vidrio Aislanglass 50', 'C', '2', 0, 3),
(563, 100, '0.00', '0.00', 'Cielo Raso (Pack X10) 2X4X14mm', 'C', '2', 0, 2),
(564, 100, '0.00', '0.00', 'Grapas 1\" pack x 9 prodac', 'C', '2', 0, 18),
(565, 100, '0.00', '0.00', 'Concertina galvanizada 45 cm', 'C', '2', 0, 19),
(566, 100, '0.00', '0.00', 'Escalera Tijera De Aluminio 5 Pasos', 'C', '2', 0, 37),
(567, 100, '0.00', '0.00', 'Escalera Tijera De Aluminio 3 Pasos', 'C', '2', 0, 36),
(568, 100, '0.00', '0.00', 'Escalera adaptable fibra-vidrio 12 pasos', 'C', '2', 0, 35),
(569, 100, '0.00', '0.00', 'Escalera tijera madera 8 pasos', 'C', '2', 0, 34),
(570, 100, '0.00', '0.00', 'Escalera telescópica aluminio 16 pasos', 'C', '2', 0, 33),
(571, 100, '0.00', '0.00', 'Escalera doméstica 2 pasos', 'C', '2', 0, 32),
(572, 100, '0.00', '0.00', 'Escalera de arrimo 10 pasos madera', 'C', '2', 0, 31),
(573, 100, '0.00', '0.00', 'Escalera tijera de madera 6 pasos', 'C', '2', 0, 30),
(574, 100, '0.00', '0.00', 'Escalera De Metal 6 Pasos', 'C', '2', 0, 29),
(575, 100, '0.00', '0.00', 'Escalera Tijera De Aluminio 9 Pasos', 'C', '2', 0, 28),
(576, 100, '0.00', '0.00', 'Escalera Tijera De Aluminio 7 Pasos', 'C', '2', 0, 27),
(577, 100, '0.00', '0.00', 'Alambre galvanizado n° 16 - 1 kg prodac', 'C', '2', 0, 26),
(578, 100, '0.00', '0.00', 'Alambre recocido n° 16 1 kg', 'C', '2', 0, 25),
(579, 100, '0.00', '0.00', 'Alambre recocido n° 16 10 kg', 'C', '2', 0, 24),
(580, 100, '0.00', '0.00', 'Alambre Recocido 8\"-10kg', 'C', '2', 0, 23),
(581, 100, '0.00', '0.00', 'Alambre Puas Motto R200m', 'C', '2', 0, 22),
(582, 100, '0.00', '0.00', 'Plancha de Tecnoblock 1.20 x 2.40 m x 2\"', 'C', '2', 0, 1),
(2308, 0, '12.00', '0.00', 'Alambre galvanizado 24\" - 100kg', 'A', '1', 0, 20),
(2309, 0, '12.00', '0.00', 'Alam Negro Recocido 8x25kg', 'A', '1', 0, 21),
(2310, 0, '0.00', '0.00', 'Malla rashell rollo x 100m negro', 'A', '1', 0, 55),
(2311, 0, '0.00', '0.00', 'Malla rashell rollo x 100m gris', 'A', '1', 0, 54),
(2312, 0, '0.00', '0.00', 'Malla rashell azul rollo x 100m', 'A', '1', 0, 53),
(2313, 0, '0.00', '0.00', 'Malla mosquitera mesh aluminio rollo x 30m', 'A', '1', 0, 52),
(2314, 0, '0.00', '0.00', 'Malla mosquitera mesh verde rollo x 30m', 'A', '1', 0, 51),
(2315, 0, '0.00', '0.00', 'Malla Hexagonal 3/4-0.90 Ml.', 'A', '1', 0, 50),
(2316, 0, '0.00', '0.00', 'O-malla Tejida Negra/gris X Ml', 'A', '1', 0, 49),
(2317, 0, '0.00', '0.00', 'Malla Cuadrada 3/4pxmetro.', 'A', '1', 0, 48),
(2318, 0, '0.00', '0.00', 'Membrana asfáltica gravillada negro chema', 'A', '1', 0, 47),
(2319, 0, '0.00', '0.00', 'Malla Mosqu Plast Az 0.9Mx30M', 'B', '1', 0, 46),
(2320, 0, '0.00', '0.00', 'O-Malla Mosqui Plast Vde Ml', 'B', '1', 0, 45),
(2321, 0, '0.00', '0.00', 'Malla Alambre Galvanizado Cuadrado 1/2\"', 'B', '1', 0, 44),
(2322, 0, '0.00', '0.00', 'Malla Mosquitero Metálica x Metro Lineal', 'B', '1', 0, 43),
(2323, 0, '0.00', '0.00', 'Escalera tijera madera 10 pasos', 'B', '1', 0, 42),
(2324, 0, '0.00', '0.00', 'Escalera Multi Posición Aluminio 12 Pasos Aluminio', 'B', '1', 0, 41),
(2325, 0, '0.00', '0.00', 'Escalera fibra de vidrio 6 pasos', 'B', '1', 0, 40),
(2326, 0, '0.00', '0.00', 'Manga plast 60\" crstl r5m', 'B', '1', 0, 74),
(2327, 0, '0.00', '0.00', 'Malla rashell rollo x 100m verde', 'B', '1', 0, 56),
(2328, 0, '0.00', '0.00', 'Manga plast 60\" crstl r10m', 'B', '1', 0, 73),
(2329, 0, '0.00', '0.00', 'Manga plast 1.5mx2.8mm neg r10m', 'B', '1', 0, 72),
(2330, 0, '0.00', '0.00', 'Manga Plast 1.5mx2.8mm Neg R5m', 'B', '1', 0, 71),
(2331, 0, '0.00', '0.00', 'Manga plast 1.5mx2.8mm az r5m', 'B', '1', 0, 70),
(2332, 0, '0.00', '0.00', 'Malla Cuadrados 0.90 m x 1\" Gris', 'B', '1', 0, 69),
(2333, 0, '0.00', '0.00', 'Malla tejida 2\" galvanizada pvc 14 rollo x 10m', 'B', '1', 0, 68),
(2334, 0, '0.00', '0.00', 'Malla tejida 2\" galvanizada 14 rollo x 10m', 'C', '1', 0, 67),
(2335, 0, '0.00', '0.00', 'Malla cuadrada galvanizada rollo x 30m 1\" - 0.9m', 'C', '1', 0, 66),
(2336, 0, '0.00', '0.00', 'Manga plast 1.5mx2mm az r10m', 'C', '1', 0, 65),
(2337, 0, '0.00', '0.00', 'Mangas plásticas negro 1.5m x 8 mm', 'C', '1', 0, 64),
(2338, 0, '0.00', '0.00', 'Mangas plásticas gris 1.5m x 8 mm', 'C', '1', 0, 63),
(2339, 0, '0.00', '0.00', 'Mangas plásticas azul 1.5m x 8 mm', 'C', '1', 0, 62),
(2340, 0, '0.00', '0.00', 'Malla alambre galvanizado cuadrado 1\" x mt\"', 'C', '1', 0, 61),
(2341, 0, '0.00', '0.00', 'Malla alambre galvanizado cuadrado 3/4\"\"', 'C', '1', 0, 60),
(2342, 0, '0.00', '0.00', 'Malla Mosqu Plast Vde 0.9mx30m', 'C', '1', 0, 59),
(2343, 0, '0.00', '0.00', 'Malla Mosquitero 0.90 m Negro', 'C', '1', 0, 58),
(2344, 0, '0.00', '0.00', 'Broche pack x 25 bisagra', 'C', '1', 0, 57),
(2345, 0, '0.00', '0.00', 'Escalera Tijera De Aluminio 3 Pasos', 'C', '1', 0, 39),
(2346, 0, '0.00', '0.00', 'Escalera tijera de madera 12 pasos', 'C', '1', 0, 38),
(2347, 0, '0.00', '0.00', 'Grapa malla 3/4 pulgadas x 14 pulgadas', 'C', '1', 0, 17),
(2348, 0, '0.00', '0.00', 'Alambre Puas Sinch R200m', 'C', '1', 0, 16),
(2349, 0, '0.00', '0.00', 'Alambre galvanizado nº 14 1 kg', 'C', '1', 0, 15),
(2350, 0, '0.00', '0.00', 'Alambre Galvn #8 50kg', 'C', '1', 0, 14),
(2351, 0, '0.00', '0.00', 'Alambre Recocido Nº 8 100 Kg', 'C', '1', 0, 13),
(2352, 0, '0.00', '0.00', 'Alambre galvn 16 1kg', 'C', '1', 0, 12),
(2353, 0, '0.00', '0.00', 'Alambre Puas Andn R200m', 'C', '1', 0, 11),
(2354, 0, '0.00', '0.00', 'Cielo Raso Glass 1.20 x 0.60 m', 'C', '1', 0, 10),
(2355, 0, '0.00', '0.00', 'Cielo raso baldosa radar', 'C', '1', 0, 9),
(2356, 0, '0.00', '0.00', 'Cielo Raso Serene 1.2X0.6X12P8', 'C', '1', 0, 8),
(2357, 0, '0.00', '0.00', 'Plancha tecnomix 2.40 x 1.20 x 2\"', 'C', '1', 0, 7),
(2358, 0, '0.00', '0.00', 'Poliestireno Exp 2x1.2mx2.4m', 'C', '1', 0, 6),
(2359, 0, '0.00', '0.00', 'Plancha de tecnopor', 'C', '1', 0, 5),
(2360, 0, '0.00', '0.00', 'Lana Poliest Ecoterm 300GR/MT2', 'C', '1', 0, 4),
(2361, 0, '0.00', '0.00', 'Lana De Vidrio Aislanglass 50', 'C', '1', 0, 3),
(2362, 0, '0.00', '0.00', 'Cielo Raso (Pack X10) 2X4X14mm', 'C', '1', 0, 2),
(2363, 0, '0.00', '0.00', 'Grapas 1\" pack x 9 prodac', 'C', '1', 0, 18),
(2364, 0, '0.00', '0.00', 'Concertina galvanizada 45 cm', 'C', '1', 0, 19),
(2365, 0, '0.00', '0.00', 'Escalera Tijera De Aluminio 5 Pasos', 'C', '1', 0, 37),
(2366, 0, '0.00', '0.00', 'Escalera Tijera De Aluminio 3 Pasos', 'C', '1', 0, 36),
(2367, 0, '0.00', '0.00', 'Escalera adaptable fibra-vidrio 12 pasos', 'C', '1', 0, 35),
(2368, 0, '0.00', '0.00', 'Escalera tijera madera 8 pasos', 'C', '1', 0, 34),
(2369, 0, '0.00', '0.00', 'Escalera telescópica aluminio 16 pasos', 'C', '1', 0, 33),
(2370, 0, '0.00', '0.00', 'Escalera doméstica 2 pasos', 'C', '1', 0, 32),
(2371, 0, '0.00', '0.00', 'Escalera de arrimo 10 pasos madera', 'C', '1', 0, 31),
(2372, 0, '0.00', '0.00', 'Escalera tijera de madera 6 pasos', 'C', '1', 0, 30),
(2373, 0, '0.00', '0.00', 'Escalera De Metal 6 Pasos', 'C', '1', 0, 29),
(2374, 0, '0.00', '0.00', 'Escalera Tijera De Aluminio 9 Pasos', 'C', '1', 0, 28),
(2375, 0, '0.00', '0.00', 'Escalera Tijera De Aluminio 7 Pasos', 'C', '1', 0, 27),
(2376, 0, '0.00', '0.00', 'Alambre galvanizado n° 16 - 1 kg prodac', 'C', '1', 0, 26),
(2377, 0, '0.00', '0.00', 'Alambre recocido n° 16 1 kg', 'C', '1', 0, 25),
(2378, 0, '0.00', '0.00', 'Alambre recocido n° 16 10 kg', 'C', '1', 0, 24),
(2379, 0, '0.00', '0.00', 'Alambre Recocido 8\"-10kg', 'C', '1', 0, 23),
(2380, 0, '0.00', '0.00', 'Alambre Puas Motto R200m', 'C', '1', 0, 22),
(2381, 0, '0.00', '0.00', 'Plancha de Tecnoblock 1.20 x 2.40 m x 2\"', 'C', '1', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategoria`
--

CREATE TABLE `subcategoria` (
  `idcategoria` int(10) DEFAULT NULL,
  `idsubcategoria` int(10) NOT NULL,
  `categoria` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `subcategoria` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `subcategoria`
--

INSERT INTO `subcategoria` (`idcategoria`, `idsubcategoria`, `categoria`, `subcategoria`, `estado`) VALUES
(1, 1, 'Techos y Tabiques', 'Aislantes', 1),
(1, 2, 'Techos y Tabiques', 'Alambre', 1),
(1, 3, 'Techos y Tabiques', 'Escaleras', 1),
(1, 4, 'Techos y Tabiques', 'Mallas Y Telas', 1),
(1, 5, 'Techos y Tabiques', 'Tabiquería', 1),
(1, 6, 'Techos y Tabiques', 'Techos', 1),
(2, 7, 'Puertas y Ventanas', 'Puertas', 1),
(2, 8, 'Puertas y Ventanas', 'Molduras', 1),
(2, 9, 'Puertas y Ventanas', 'Blocks De Vidrio', 1),
(2, 10, 'Puertas y Ventanas', 'Ventanas', 1),
(2, 11, 'Puertas y Ventanas', 'Otras Puertas', 1),
(3, 12, 'Pisos', 'Adhesivos Y Fraguas', 1),
(3, 13, 'Pisos', 'Cerámicos', 1),
(3, 14, 'Pisos', 'Cubrejuntas', 1),
(3, 15, 'Pisos', 'Herramientas', 1),
(3, 16, 'Pisos', 'Limpiadores Y Selladores', 1),
(3, 17, 'Pisos', 'Listelos Y Decorados', 1),
(3, 18, 'Pisos', 'Madera Laminada', 1),
(3, 19, 'Pisos', 'Madera Natural', 1),
(3, 20, 'Pisos', 'Piedras', 1),
(3, 21, 'Pisos', 'Pisos Varios', 1),
(3, 22, 'Pisos', 'Porcelanato', 1),
(4, 23, 'Piscinas', 'Camping', 1),
(4, 24, 'Piscinas', 'Mantenimiento De Piscinas', 1),
(4, 25, 'Piscinas', 'Piscinas Y Accesorios', 1),
(5, 26, 'Pinturas y Accesorios', 'Pinturas', 1),
(5, 27, 'Pinturas y Accesorios', 'Accesorios', 1),
(5, 28, 'Pinturas y Accesorios', 'Adhesivos', 1),
(6, 29, 'Organización', 'Cajas Organizadoreas', 1),
(6, 30, 'Organización', 'Closets', 1),
(6, 31, 'Organización', 'Escuadras Y Repisas', 1),
(6, 32, 'Organización', 'Estantes Y Armarios', 1),
(6, 33, 'Organización', 'Oficina', 1),
(6, 34, 'Organización', 'Organizadores Para Baño', 1),
(6, 35, 'Organización', 'Perchas Y Ganchos', 1),
(6, 36, 'Organización', 'Seguridad Infantil', 1),
(7, 37, 'Obra Gruesa', 'Aridos Y Aglomerados', 1),
(7, 38, 'Obra Gruesa', 'Bloques', 1),
(7, 39, 'Obra Gruesa', 'Ladrillos', 1),
(7, 40, 'Obra Gruesa', 'Químicos De Construcción', 1),
(8, 41, 'Muebles', 'Dormitorio', 1),
(8, 42, 'Muebles', 'Estantes Y Libreros', 1),
(8, 43, 'Muebles', 'Muebles Para Oficina', 1),
(8, 44, 'Muebles', 'Sillas y centros de entretenimiento', 1),
(9, 45, 'Maderas Y Tableros', 'Laminados alta presion', 1),
(9, 46, 'Maderas Y Tableros', 'Madera Aserrada', 1),
(9, 47, 'Maderas Y Tableros', 'Tableros', 1),
(9, 48, 'Maderas Y Tableros', 'Tableros construccion', 1),
(10, 49, 'Línea Blanca y Climatización', 'Climatizacion', 1),
(10, 50, 'Línea Blanca y Climatización', 'Electrodomésticos', 1),
(10, 51, 'Línea Blanca y Climatización', 'Encimeras y hornos empotrables', 1),
(10, 52, 'Línea Blanca y Climatización', 'Línea blanca', 1),
(11, 53, 'Limpieza', 'Complementos Para Aseo', 1),
(11, 54, 'Limpieza', 'Contenedores Para Basura', 1),
(11, 55, 'Limpieza', 'Lavanderia', 1),
(11, 56, 'Limpieza', 'Quimicos', 1),
(12, 57, 'Jardín', 'Decoración', 1),
(12, 58, 'Jardín', 'Equipos', 1),
(12, 59, 'Jardín', 'Herramientas de jardín', 1),
(12, 60, 'Jardín', 'Herramientas Y Maquinarias', 1),
(12, 61, 'Jardín', 'Insumos', 1),
(12, 62, 'Jardín', 'Maceteros Y Accesorios', 1),
(12, 63, 'Jardín', 'Plantas', 1),
(12, 64, 'Jardín', 'Riego Manual', 1),
(13, 65, 'Iluminación', 'Focos', 1),
(13, 66, 'Iluminación', 'Lámparas De Exterior', 1),
(13, 67, 'Iluminación', 'Lámparas De Interior', 1),
(13, 68, 'Iluminación', 'Ventiladores De Techo', 1),
(14, 69, 'Herramientas y Maquinarias', 'Accesorios Herramientas Eléctricas', 1),
(14, 70, 'Herramientas y Maquinarias', 'Herramientas', 1),
(14, 71, 'Herramientas y Maquinarias', 'Herramientas De Banco', 1),
(14, 72, 'Herramientas y Maquinarias', 'Herramientas De Construccion', 1),
(14, 73, 'Herramientas y Maquinarias', 'Herramientas Inalámbricas', 1),
(14, 74, 'Herramientas y Maquinarias', 'Herramientas Manuales', 1),
(14, 75, 'Herramientas y Maquinarias', 'Maquinaria Especializada', 1),
(14, 76, 'Herramientas y Maquinarias', 'Organizadores De Herramientas', 1),
(15, 77, 'Gasfitería', 'Herramientas De Gasfiteria', 1),
(15, 78, 'Gasfitería', 'Tubos Y Fittings PVC', 1),
(15, 79, 'Gasfitería', 'Accesorios', 1),
(15, 80, 'Gasfitería', 'Bombas', 1),
(15, 81, 'Gasfitería', 'Llaves Y Valvulas', 1),
(15, 82, 'Gasfitería', 'Conexiones galvanizadas', 1),
(15, 83, 'Gasfitería', 'Tanques De Agua', 1),
(15, 84, 'Gasfitería', 'Reparaciones Wc Y Sifones', 1),
(15, 85, 'Gasfitería', 'Equipos Para Piscinas', 1),
(15, 86, 'Gasfitería', 'Tubos Y Fittings Cobre', 1),
(16, 87, 'Fierro y Hierro', 'Fierro Y Hierro', 1),
(16, 88, 'Fierro y Hierro', 'Perfiles De Hierro', 1),
(17, 89, 'Ferretería', 'Cadenas Y Cuerdas', 1),
(17, 90, 'Ferretería', 'Cerraduras', 1),
(17, 91, 'Ferretería', 'Empaques Y Embalajes', 1),
(17, 92, 'Ferretería', 'Fijaciones/tornilleria', 1),
(17, 93, 'Ferretería', 'Herrajeria/quincalleria construccion', 1),
(17, 94, 'Ferretería', 'Seguridad Industrial', 1),
(18, 95, 'Electricidad', 'Cables', 1),
(18, 96, 'Electricidad', 'Canaletas', 1),
(18, 97, 'Electricidad', 'Extensiones', 1),
(18, 98, 'Electricidad', 'Herramientas Para Electricistas', 1),
(18, 99, 'Electricidad', 'Iluminacion Industrial Y Comercial', 1),
(18, 100, 'Electricidad', 'Linternas', 1),
(18, 101, 'Electricidad', 'Tableros, Tacos Y Componentes', 1),
(18, 102, 'Electricidad', 'Tomas, Interruptores Y Placas', 1),
(18, 103, 'Electricidad', 'Transformadores Y Reguladores', 1),
(19, 104, 'Comunicación y Electrónica', 'Accesorios Electrónicos', 1),
(19, 105, 'Comunicación y Electrónica', 'Audio', 1),
(19, 106, 'Comunicación y Electrónica', 'Computacion', 1),
(19, 107, 'Comunicación y Electrónica', 'Linternas', 1),
(19, 108, 'Comunicación y Electrónica', 'Pilas', 1),
(19, 109, 'Comunicación y Electrónica', 'Porteros Eléctricos', 1),
(19, 110, 'Comunicación y Electrónica', 'Telefonia', 1),
(19, 111, 'Comunicación y Electrónica', 'Video', 1),
(20, 112, 'Baños y Cocinas', 'Sanitarios', 1),
(20, 113, 'Baños y Cocinas', 'Accesorios Baño Fijo', 1),
(20, 114, 'Baños y Cocinas', 'Cabinas De Ducha', 1),
(20, 115, 'Baños y Cocinas', 'Espejos Y Gabinetes', 1),
(20, 116, 'Baños y Cocinas', 'Extractores Aire', 1),
(20, 117, 'Baños y Cocinas', 'Griferia', 1),
(20, 118, 'Baños y Cocinas', 'Lavaderos, Lavarropa', 1),
(20, 119, 'Baños y Cocinas', 'Lavaplatos', 1),
(20, 120, 'Baños y Cocinas', 'Muebles Cocina', 1),
(20, 121, 'Baños y Cocinas', 'Muebles De Baño', 1),
(20, 122, 'Baños y Cocinas', 'Termas Y Duchas Eléctricas', 1),
(20, 123, 'Baños y Cocinas', 'Tinas', 1),
(21, 124, 'Auto', 'Accesorios Exterior', 1),
(21, 125, 'Auto', 'Accesorios Interior', 1),
(21, 126, 'Auto', 'Audio Autos', 1),
(21, 127, 'Auto', 'Baterias Y Accesorios', 1),
(21, 128, 'Auto', 'Limpieza', 1),
(21, 129, 'Auto', 'Neumáticos', 1),
(21, 130, 'Auto', 'Químicos Para El Auto', 1),
(21, 131, 'Auto', 'Seguridad', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursal`
--

CREATE TABLE `sucursal` (
  `idsucursal` int(20) NOT NULL,
  `razonsocial` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `documento` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `direccion` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `sucursal`
--

INSERT INTO `sucursal` (`idsucursal`, `razonsocial`, `documento`, `direccion`, `email`, `estado`) VALUES
(1, 'IFEbenezer', '44751527', 'Lima - Lima - Surco', 'ventas_ifebenezer@gmail.com', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodocumento`
--

CREATE TABLE `tipodocumento` (
  `idtipdoc` int(11) NOT NULL,
  `nombre` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `operacion` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tipodocumento`
--

INSERT INTO `tipodocumento` (`idtipdoc`, `nombre`, `operacion`, `estado`) VALUES
(1, 'DNI', 'Persona', 1),
(2, 'Quia de Remisión', 'Comprobante', 1),
(3, 'Cedula', 'Persona', 1),
(4, 'Boleta', 'Comprobante', 1),
(5, 'Factura', 'Comprobante', 1),
(6, 'NIC', 'Persona', 1),
(7, 'Ticket', 'Comprobante', 1),
(8, 'RUC', 'Persona', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidadmedida`
--

CREATE TABLE `unidadmedida` (
  `idunidadmedida` int(10) NOT NULL,
  `nombre` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL,
  `prefijo` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `unidadmedida`
--

INSERT INTO `unidadmedida` (`idunidadmedida`, `nombre`, `prefijo`, `estado`) VALUES
(1, 'metro', 'm', 1),
(2, 'unidad', 'u', 1),
(3, 'galon', 'gal', 1),
(4, 'libra', 'lb', 1),
(5, 'pliego', 'pli', 1),
(6, 'lamina', 'lam', 1),
(7, 'rollo', 'rol', 1),
(8, 'bulto', 'bul', 1),
(9, 'paquete', 'paq', 1),
(10, 'kilogramo', 'kg', 1),
(11, 'frasco', 'fra', 1),
(12, 'sobre', 'sob', 1),
(13, 'cono', 'con', 1),
(14, 'pote', 'pot', 1),
(15, 'botella', 'bot', 1),
(16, 'litro', 'l', 1),
(17, 'caja', 'caj', 1),
(18, 'resma', 'res', 1),
(19, 'pack', 'pk', 1),
(20, 'plancha', 'pla', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `idusuario` int(11) NOT NULL,
  `apellidos` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `nombres` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `documento` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `telefono` varchar(15) COLLATE utf8_spanish_ci DEFAULT NULL,
  `direccion` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecnac` date DEFAULT NULL,
  `imagen` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`idusuario`, `apellidos`, `nombres`, `documento`, `email`, `telefono`, `direccion`, `password`, `fecnac`, `imagen`, `estado`) VALUES
(24, 'Malpartida Calderón', 'José Manuel', '44751527', 'ing.jmalpartidac@gmail.com', '4785695', 'Lima', '$2y$10$iwu6qkgq8NEHoCtvzKzxD.P6oALNWYqRHXgKPU/hgE.VjIX1WEarm', '1987-12-31', 'public/fotos/jmalpartida.jpg', 1),
(27, 'Malpartida Calderón', 'Ingrid Patricia', '15874856', 'ingrid@gmail.com', '3874506', 'Lima', '$2y$10$UGmlq2pg3rCXufcN0uQCgOTh4ny7GZevhK2JHnZEJzayY5ERh4Gq6', '1995-01-07', 'public/fotos/ingrid.jpg', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `idventa` int(11) NOT NULL,
  `idcliente` int(11) DEFAULT NULL,
  `cliente` varchar(80) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipocomprobante` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `tipopedido` varchar(20) COLLATE utf8_spanish_ci DEFAULT 'Venta',
  `impuesto` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `igv` decimal(25,2) DEFAULT NULL,
  `subtotal` decimal(25,2) DEFAULT NULL,
  `total` decimal(25,2) DEFAULT NULL,
  `fechaderegistro` date DEFAULT NULL,
  `estadodeventa` varchar(15) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`idventa`, `idcliente`, `cliente`, `tipocomprobante`, `tipopedido`, `impuesto`, `igv`, `subtotal`, `total`, `fechaderegistro`, `estadodeventa`, `estado`) VALUES
(1, 32, 'A & S PHARMACEUTICAL S.A.C.', 'Boleta', 'Venta', '0.18', '25.92', '118.08', '144.00', '2018-07-11', 'Confirmado', 1),
(2, 32, 'A & S PHARMACEUTICAL S.A.C.', 'Boleta', 'Venta', '0.18', '0.72', '3.28', '4.00', '2018-07-12', 'Confirmado', 1),
(3, 132, 'GOMEZ ALBORNOZ  MILKER', 'Factura', 'Venta', '0.18', '68.22', '310.78', '379.00', '2018-07-13', 'Confirmado', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulo`
--
ALTER TABLE `articulo`
  ADD PRIMARY KEY (`idarticulo`);

--
-- Indices de la tabla `articuloinventario`
--
ALTER TABLE `articuloinventario`
  ADD PRIMARY KEY (`idarticuloinventario`);

--
-- Indices de la tabla `articuloxdocumento`
--
ALTER TABLE `articuloxdocumento`
  ADD PRIMARY KEY (`idartxdoc`);

--
-- Indices de la tabla `articuloxdocumentopedido`
--
ALTER TABLE `articuloxdocumentopedido`
  ADD PRIMARY KEY (`idartxdocped`);

--
-- Indices de la tabla `articuloxdocumentoventa`
--
ALTER TABLE `articuloxdocumentoventa`
  ADD PRIMARY KEY (`idartxdocven`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idcategoria`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idcliente`);

--
-- Indices de la tabla `confcomprobantes`
--
ALTER TABLE `confcomprobantes`
  ADD PRIMARY KEY (`idconfcomprobante`);

--
-- Indices de la tabla `general`
--
ALTER TABLE `general`
  ADD PRIMARY KEY (`idgeneral`);

--
-- Indices de la tabla `ingresoalmacen`
--
ALTER TABLE `ingresoalmacen`
  ADD PRIMARY KEY (`idingresoalma`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`idpedido`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`idpermiso`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`idproveedor`);

--
-- Indices de la tabla `reporte_clasificacion`
--
ALTER TABLE `reporte_clasificacion`
  ADD PRIMARY KEY (`indice`);

--
-- Indices de la tabla `subcategoria`
--
ALTER TABLE `subcategoria`
  ADD PRIMARY KEY (`idsubcategoria`);

--
-- Indices de la tabla `sucursal`
--
ALTER TABLE `sucursal`
  ADD PRIMARY KEY (`idsucursal`);

--
-- Indices de la tabla `tipodocumento`
--
ALTER TABLE `tipodocumento`
  ADD PRIMARY KEY (`idtipdoc`);

--
-- Indices de la tabla `unidadmedida`
--
ALTER TABLE `unidadmedida`
  ADD PRIMARY KEY (`idunidadmedida`);

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idusuario`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`idventa`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `articulo`
--
ALTER TABLE `articulo`
  MODIFY `idarticulo` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT de la tabla `articuloxdocumento`
--
ALTER TABLE `articuloxdocumento`
  MODIFY `idartxdoc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `articuloxdocumentopedido`
--
ALTER TABLE `articuloxdocumentopedido`
  MODIFY `idartxdocped` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `articuloxdocumentoventa`
--
ALTER TABLE `articuloxdocumentoventa`
  MODIFY `idartxdocven` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idcategoria` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

--
-- AUTO_INCREMENT de la tabla `confcomprobantes`
--
ALTER TABLE `confcomprobantes`
  MODIFY `idconfcomprobante` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `general`
--
ALTER TABLE `general`
  MODIFY `idgeneral` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ingresoalmacen`
--
ALTER TABLE `ingresoalmacen`
  MODIFY `idingresoalma` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `idpedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `idpermiso` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `idproveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `reporte_clasificacion`
--
ALTER TABLE `reporte_clasificacion`
  MODIFY `indice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2435;

--
-- AUTO_INCREMENT de la tabla `subcategoria`
--
ALTER TABLE `subcategoria`
  MODIFY `idsubcategoria` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT de la tabla `sucursal`
--
ALTER TABLE `sucursal`
  MODIFY `idsucursal` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipodocumento`
--
ALTER TABLE `tipodocumento`
  MODIFY `idtipdoc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `unidadmedida`
--
ALTER TABLE `unidadmedida`
  MODIFY `idunidadmedida` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `idventa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
