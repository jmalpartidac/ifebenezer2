-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-04-2018 a las 00:03:11
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
				
        END IF;
        
        SELECT * FROM tmp_errores;
        
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
  `stock` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `imagen` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `articulo`
--

INSERT INTO `articulo` (`idarticulo`, `idcategoria`, `idsubcategoria`, `categoria`, `subcategoria`, `articulo`, `marca`, `descripcion`, `unidaddemedida`, `stock`, `imagen`, `estado`) VALUES
(1, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Plancha de Tecnoblock 1.20 x 2.40 m x 2\"', 'Tecnoblock', 'Panel con dos caras de viruta de madera aglomerada con cemento prensado con un núcleo de poliestireno de 2\"', 'plancha', NULL, 'public/articulos/1.jpg', 1),
(2, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo Raso (Pack X10) 2X4X14mm', 'Tecnoblock', '10 unidades - Espesor 14 mm.', 'pack', NULL, 'public/articulos/2.jpg', 1),
(3, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Lana De Vidrio Aislanglass 50', 'Aislanglass', 'Aislante térmico y acústico para tabiquería. 1.2 x 12 m', 'paquete', NULL, 'public/articulos/3.jpg', 1),
(4, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Lana Poliest Ecoterm 300GR/MT2', 'Ecoterm', 'Aislante térmico y acústico para tabiquería.  300 gr/m2 x 1.20m', 'rollo', NULL, 'public/articulos/4.jpg', 1),
(5, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Plancha de tecnopor', 'Indupol', 'Ideal para aislantes térmicos y juntas de dilatación. 1.20 x 2.40 m , 1”', 'plancha', NULL, 'public/articulos/5.jpg', 1),
(6, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Poliestireno Exp 2x1.2mx2.4m', 'Poliestireno', '2\"x1.2m x 2.4m', 'plancha', NULL, 'public/articulos/6.jpg', 1),
(7, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Plancha tecnomix 2.40 x 1.20 x 2\"', 'Tecnomix', '2.40 x 1.20 x 2\"', 'plancha', NULL, 'public/articulos/7.jpg', 1),
(8, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo Raso Serene 1.2X0.6X12P8', 'Serene', 'Doméstico e industrial 8 und 1.2X0.6X12P8', 'pack', NULL, 'public/articulos/8.jpg', 1),
(9, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo raso baldosa radar', 'Radar', 'Espeso 15 mm.  8 unds.  Medida 0.60 m x 1.20 m.', 'pack', NULL, 'public/articulos/9.jpg', 1),
(10, 1, 1, 'Techos y Tabiques', 'Aislantes', 'Cielo Raso Glass 1.20 x 0.60 m', 'Volcan', 'PVC Texturado 16 unid. Por caja Medidas 1.20 x 0.60 m', 'caja', NULL, 'public/articulos/10.jpg', 1),
(11, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Puas Andn R200m', 'Andn', 'Alambre galvanizado 200m', 'rollo', NULL, 'public/articulos/11.jpg', 1),
(12, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre galvn 16 1kg', 'Galvn', 'Alambre galvn 16 1kg', 'rollo', NULL, 'public/articulos/12.jpg', 1),
(13, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Recocido Nº 8 100 Kg', 'Prodac', 'Acero de bajo carbono Diámetro 4.20 mm Peso 100 kg', 'rollo', NULL, 'public/articulos/13.jpg', 1),
(14, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Galvn #8 50kg', 'Prodac', 'Alambre Galvn #8 50kg', 'rollo', NULL, 'public/articulos/14.jpg', 1),
(15, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre galvanizado nº 14 1 kg', 'Prodac', 'Alambre de acero, de bajo contenido de carbono, galvanizado, posee una gran uniformidad en el diámetro y en el recubrimiento de Zinc  Peso 1 kg', 'rollo', NULL, 'public/articulos/15.jpg', 1),
(16, 1, 2, 'Techos y Tabiques', 'Alambre', 'Alambre Puas Sinch R200m', 'Sinchi', 'Alambre galvanizado 200m', 'rollo', NULL, 'public/articulos/16.jpg', 1),
(17, 1, 2, 'Techos y Tabiques', 'Alambre', 'Grapa malla 3/4 pulgadas x 14 pulgadas', 'Prodac', 'Fabricadas con alambre galvanizado de gran resistencia, con un diseño curvo, puntas invertidas y de cuerpo liso', 'kilogramo', NULL, 'public/articulos/17.jpg', 1),
(18, 1, 2, 'Techos y Tabiques', 'Alambre', 'Grapas 1\" pack x 9 prodac', 'Prodac', '9 unid 1\" Grapas', 'pack', NULL, 'public/articulos/18.jpg', 1);

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
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

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
  `estado` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

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
  `apellido` varchar(80) COLLATE utf8_spanish_ci DEFAULT NULL,
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
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulo`
--
ALTER TABLE `articulo`
  ADD PRIMARY KEY (`idarticulo`);

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
  MODIFY `idarticulo` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `articuloxdocumento`
--
ALTER TABLE `articuloxdocumento`
  MODIFY `idartxdoc` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `articuloxdocumentopedido`
--
ALTER TABLE `articuloxdocumentopedido`
  MODIFY `idartxdocped` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `articuloxdocumentoventa`
--
ALTER TABLE `articuloxdocumentoventa`
  MODIFY `idartxdocven` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idcategoria` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `confcomprobantes`
--
ALTER TABLE `confcomprobantes`
  MODIFY `idconfcomprobante` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `general`
--
ALTER TABLE `general`
  MODIFY `idgeneral` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ingresoalmacen`
--
ALTER TABLE `ingresoalmacen`
  MODIFY `idingresoalma` int(20) NOT NULL AUTO_INCREMENT;

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
  MODIFY `idventa` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
