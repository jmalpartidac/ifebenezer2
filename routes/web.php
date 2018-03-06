<?php
// RUTAS PARA INICIO DE SECION 
	Route::match(['get', 'post'],'login', "Auth\LoginController@mostrarLogin");
	Route::get('home', "HomeController@mostrarHome");
	Route::get('logout', "Auth\LoginController@logout");

	// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL TABLERO
	
		Route::get('tablero', "HomeController@mostrarTablero");

// RUTAS PARA EL MODULO MANTENIMIENTO 
 
	// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL GENERAL
	
		Route::get('general', "MantenimientoController@mostrarGeneral");

	// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO SUCURSAL
		Route::get('sucursal', "MantenimientoController@mostrarSucursal");

			//ESTA RUTA MUESTRA LA VISTA NUEVA SUCURSAL
			Route::get('nuevasucursal', "MantenimientoController@mostrarNuevasucursal");
			//ESTA RUTA INGRESA UNA SUCURSAL POR EL FORM A LA BASE
			Route::post('addnuevasucursal','MantenimientoController@addNuevasucursal');
			//ESTA RUTA PERMITE EDITAR UNA SUCURSAL
			Route::get('editarsucursal/{idsucursal}','MantenimientoController@editarSucursal');
			//ESTA RUTA PERMITE ELIMINAR UNA SUCURSAL
			Route::get('eliminarsucursal/{idsucursal}','MantenimientoController@deleteSucursal');

	// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO EMPLEADOS
		Route::get('empleados', "MantenimientoController@mostrarEmpleado");

			//ESTA RUTA MUESTRA LA VISTA NUEVO EMPLEADO
			Route::get('nuevoempleado', "MantenimientoController@mostrarNuevoempleado");
			//ESTA RUTA INGRESA EL NUEVO EMPLEADO POR EL FORM A LA BASE
			Route::post('addnuevoempleado','MantenimientoController@addNuevoempleado');
			//ESTA RUTA PERMITE EDITAR UN EMPLEADO
			Route::get('editarempleado/{idusuario}','MantenimientoController@editarEmpleado');
			//ESTA RUTA PERMITE ELIMINAR UN EMPLEADO
			Route::get('eliminarempleado/{idusuario}','MantenimientoController@deleteEmpleado');

	// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO PERMISOS
		Route::get('permisos', "MantenimientoController@mostrarPermisos");

			//ESTA RUTA MUESTRA LA VISTA NUEVO TIPO DE DOCUMENTO
			Route::get('nuevopermiso', "MantenimientoController@mostrarNuevopermiso");
			//ESTA RUTA INGRESA EL NUEVO TIPO DE DOCUMENTO POR EL FORM A LA BASE
			Route::post('addnuevopermiso','MantenimientoController@addNuevopermiso');
			//ESTA RUTA PERMITE EDITAR UN EMPLEADO
			Route::get('editarpermiso/{idpermiso}','MantenimientoController@editarPermiso');
			//ESTA RUTA PERMITE ELIMINAR UN TIPO DE DOCUMENTO
			Route::get('eliminarpermiso/{idpermiso}','MantenimientoController@deletePermiso');

	// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO TIPO DE DOCUMENTO
		Route::get('tipodocumento', "MantenimientoController@mostrarTipodocumento");

			//ESTA RUTA MUESTRA LA VISTA NUEVO TIPO DE DOCUMENTO
			Route::get('nuevotipodocumento', "MantenimientoController@mostrarNuevotipodocumento");
			//ESTA RUTA INGRESA EL NUEVO TIPO DE DOCUMENTO POR EL FORM A LA BASE
			Route::post('addnuevotipodocumento','MantenimientoController@addNuevotipodocumento');
			//ESTA RUTA PERMITE EDITAR UN EMPLEADO
			Route::get('editartipodocumento/{idtipdoc}','MantenimientoController@editarTipodocumento');
			//ESTA RUTA PERMITE ELIMINAR UN TIPO DE DOCUMENTO
			Route::get('eliminartipodocumento/{idtipdoc}','MantenimientoController@deleteTipodocumento');

// RUTAS PARA EL MODULO ALMACEN

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO ARTICULOS
		Route::get('articulos', "AlmacenController@mostrarArticulo");

			//ESTA RUTA MUESTRA LA VISTA NUEVA CATEGORIA
			Route::get('nuevoarticulo', "AlmacenController@mostrarNuevoarticulo");
			//ESTA RUTA INGRESA EL NUEVA CATEGORIA POR EL FORM A LA BASE
			Route::post('addnuevoarticulo','AlmacenController@addNuevoarticulo');
			//ESTA RUTA PERMITE EDITAR UNIDAD DE MEDIDA
			Route::get('editararticulo/{idarticulo}','AlmacenController@editarArticulo');
			//ESTA RUTA PERMITE ELIMINAR UNIDAD DE MEDIDA
			Route::get('eliminararticulo/{idarticulo}','AlmacenController@deleteArticulo');

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO CATEGORIAS
		Route::get('categorias', "AlmacenController@mostrarCategoria");

			//ESTA RUTA MUESTRA LA VISTA NUEVA CATEGORIA
			Route::get('nuevacategoria', "AlmacenController@mostrarNuevacategoria");
			//ESTA RUTA INGRESA EL NUEVA CATEGORIA POR EL FORM A LA BASE
			Route::post('addnuevacategoria','AlmacenController@addNuevacategoria');
			//ESTA RUTA PERMITE EDITAR CATEGORIA
			Route::get('editarcategoria/{idcategoria}','AlmacenController@editarCategoria');
			//ESTA RUTA PERMITE ELIMINAR CATEGORIA
			Route::get('eliminarcategoria/{idcategoria}','AlmacenController@deleteCategoria');
		
		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO SUB CATEGORIAS
		Route::get('subcategorias', "AlmacenController@mostrarSubcategoria");

			//ESTA RUTA PERMITE USAR LA FUNCION PARA CARGAR EL COMBO SUBCATEGORIA EN FUNCION DEL COMBO CATEGORIA
			Route::post('consultasubcategoria', "AlmacenController@mostrarcombosubcategoria");

			//ESTA RUTA MUESTRA LA VISTA NUEVA SUB CATEGORIA
			Route::get('nuevasubcategoria', "AlmacenController@mostrarNuevasubcategoria");
			//ESTA RUTA INGRESA EL NUEVA SUB CATEGORIA POR EL FORM A LA BASE
			Route::post('addnuevasubcategoria','AlmacenController@addNuevasubcategoria');
			//ESTA RUTA PERMITE EDITAR SUB CATEGORIA
			Route::get('editarsubcategoria/{idsubcategoria}','AlmacenController@editarSubcategoria');
			//ESTA RUTA PERMITE ELIMINAR CATEGORIA
			Route::get('eliminarsubcategoria/{idsubcategoria}','AlmacenController@deleteSubcategoria');

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO UNIDADES DE MEDIDA
		Route::get('unidadesdemedida', "AlmacenController@mostrarUnidaddemedida");

			//ESTA RUTA MUESTRA LA VISTA NUEVA UNIDAD DE MEDIDA
			Route::get('nuevaunidaddemedida', "AlmacenController@mostrarNuevaunidaddemedida");
			//ESTA RUTA INGRESA EL NUEVA UNIDAD DE MEDIDA POR EL FORM A LA BASE
			Route::post('addnuevaunidaddemedida','AlmacenController@addNuevaunidaddemedida');
			//ESTA RUTA PERMITE EDITAR UNIDAD DE MEDIDA
			Route::get('editarunidadmedida/{idunidadmedida}','AlmacenController@editarUnidaddemedida');
			//ESTA RUTA PERMITE ELIMINAR UNIDAD DE MEDIDA
			Route::get('eliminarunidadmedida/{idunidadmedida}','AlmacenController@deleteUnidaddemedida');

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO CLASIFICACION ABC
		Route::get('clasificacionabc', "AlmacenController@mostrarClasificacionabc");

// RUTAS PARA EL MODULO COMPRAS
		Route::get('ingresoalma', "ComprasController@mostrarIngresoalmacen");

			//ESTA RUTA MUESTRA LA VISTA NUEVA COMPRA
			Route::get('nuevoingresoalmacen', "ComprasController@mostrarNuevoingresoalmacen");
			//ESTA RUTA MUESTRA LA VISTA SELECCIONE ARTICULO
			Route::get('seleccionararticulo/{idingresoalma}', "ComprasController@mostrarSeleccionararticulo");
			//ESTA RUTA INGRESA EL NUEVA COMPRA POR EL FORM A LA BASE
			Route::post('addnuevoingresoalmacen','ComprasController@addNuevoingresoalmacen');
			//ESTA RUTA INGRESA EL NUEVA SELECCION ARTICULO POR EL FORM A LA BASE
			Route::post('addnuevaseleccionarticulo','ComprasController@addNuevaseleccionarticulo');
			//ESTA RUTA PERMITE EDITAR COMPRA
			Route::get('editaringresoalmacen/{idingresoalma}','ComprasController@editarIngresoalmacen');
			//ESTA RUTA PERMITE ELIMINAR COMPRA
			Route::get('eliminaringresoalmacen/{idingresoalma}','ComprasController@deleteIngresoalmacen');
			//ESTA RUTA PERMITE ELIMINAR SELECCION ARTICULO
			Route::get('eliminararticuloseleccionado/{idartxdoc}/{idingresoalma?}/{idarticulo?}','ComprasController@deleteArticuloseleccionado');

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO PROVEEDORES
		Route::get('proveedores', "ComprasController@mostrarProveedor");

			//ESTA RUTA MUESTRA LA VISTA NUEVO PROVEEDOR
			Route::get('nuevoproveedor', "ComprasController@mostrarNuevoproveedor");
			//ESTA RUTA INGRESA EL NUEVO PROVEEDOR POR EL FORM A LA BASE
			Route::post('addnuevoproveedor','ComprasController@addNuevoproveedor');
			//ESTA RUTA PERMITE EDITAR PROVEEDOR
			Route::get('editarproveedor/{idproveedor}','ComprasController@editarProveedor');
			//ESTA RUTA PERMITE ELIMINAR PROVEEDOR
			Route::get('eliminarproveedor/{idproveedor}','ComprasController@deleteProveedor');

// RUTAS PARA EL MODULO VENTAS

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO VENTAS
		Route::get('ventas', "VentasController@mostrarVenta");

			//ESTA RUTA MUESTRA LA VISTA NUEVA VENTA
			Route::get('nuevaventa', "VentasController@mostrarNuevaventa");
			//ESTA RUTA MUESTRA LA VISTA SELECCIONE ARTICULOS PARA EL DETALLE DE VENTA
			Route::get('seleccionararticulosventa/{idventa}', "VentasController@mostrarSeleccionararticuloventa");
			//ESTA RUTA INGRESA LA NUEVA VENTA POR EL FORM A LA BASE
			Route::post('addnuevaventa','VentasController@addNuevaventa');
			//ESTA RUTA INGRESA EL ARTICULO DE VENTA POR EL FORM A LA BASE
			Route::post('addnuevaseleccionarticuloventa','VentasController@addNuevaseleccionarticuloventa');
			//ESTA RUTA PERMITE EDITAR VENTA
			Route::get('editarventa/{idventa}','VentasController@editarVenta');
			//ESTA RUTA PERMITE ELIMINAR VENTA
			Route::get('eliminarventa/{idventa}','VentasController@deleteVenta');
			//ESTA RUTA PERMITE ELIMINAR SELECCION ARTICULO DE VENTA
			Route::get('eliminararticuloseleccionadoenventa/{idartxdocven}/{idventa?}','VentasController@deleteArticuloseleccionadoenventa');
			//ESTA RUTA PERMITE CONFIRMAR VENTA
			Route::get('confirmarventa/{idventa}','VentasController@confirmarVenta');

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DE PEDIDOS
		Route::get('pedidos', "VentasController@mostrarPedido");

			//ESTA RUTA MUESTRA LA VISTA NUEVO PEDIDO
			Route::get('nuevopedido', "VentasController@mostrarNuevopedido");
			//ESTA RUTA MUESTRA LA VISTA SELECCIONE ARTICULOS PARA EL DETALLE DE PEDIDO
			Route::get('seleccionararticulospedido/{idpedido}', "VentasController@mostrarSeleccionararticulopedido");
			//ESTA RUTA INGRESA EL NUEVO PEDIDO POR EL FORM A LA BASE
			Route::post('addnuevopedido','VentasController@addNuevopedido');
			//ESTA RUTA INGRESA EL ARTICULO DE PEDIDO POR EL FORM A LA BASE
			Route::post('addnuevaseleccionarticulopedido','VentasController@addNuevaseleccionarticulopedido');
			//ESTA RUTA PERMITE EDITAR PEDIDO
			Route::get('editarpedido/{idpedido}','VentasController@editarPedido');
			//ESTA RUTA PERMITE ELIMINAR PEDIDO
			Route::get('eliminarpedido/{idpedido}','VentasController@deletePedido');
			//ESTA RUTA PERMITE ELIMINAR SELECCION ARTICULO DE PEDIDO
			Route::get('eliminararticuloseleccionadoenpedido/{idartxdocped}/{idpedido?}','VentasController@deleteArticuloseleccionadoenpedido');
			//ESTA RUTA PERMITE CONFIRMAR PEDIDO
			Route::get('confirmarpedido/{idpedido}','VentasController@confirmarPedido');

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL CONFIGURACION DE COMPROBANTES
		Route::get('clientes', "VentasController@mostrarCliente");

			//ESTA RUTA MUESTRA LA VISTA NUEVO CLIENTE
			Route::get('nuevocliente', "VentasController@mostrarNuevocliente");
			//ESTA RUTA INGRESA LA NUEVO CLIENTE POR EL FORM A LA BASE
			Route::post('addnuevocliente','VentasController@addNuevocliente');
			//ESTA RUTA PERMITE EDITAR CLIENTE
			Route::get('editarcliente/{idcliente}','VentasController@editarCliente');
			//ESTA RUTA PERMITE ELIMINAR CLIENTE
			Route::get('eliminarcliente/{idcliente}','VentasController@deleteCliente');

		Route::get('creditos', "VentasController@mostrarCredito");

		Route::get('deudaspendientes', "VentasController@mostrarDeudapendiente");

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL CONFIGURACION DE COMPROBANTES
		Route::get('confcomprobantes', "VentasController@mostrarConfcomprobante");

			//ESTA RUTA MUESTRA LA VISTA NUEVA CONFIGURACION DE COMPROBANTE
			Route::get('nuevaconfcomprobante', "VentasController@mostrarNuevaconfcomprobante");
			//ESTA RUTA INGRESA LA NUEVA CONFIGURACION DE COMPROBANTE POR EL FORM A LA BASE
			Route::post('addnuevaconfcomprobante','VentasController@addNuevaconfcomprobante');
			//ESTA RUTA PERMITE EDITAR CONFIGURACION DE COMPROBANTE
			Route::get('editarconfcomprobante/{idconfcomprobante}','VentasController@editarConfcomprobante');
			//ESTA RUTA PERMITE ELIMINAR CONFIGURACION DE COMPROBANTE
			Route::get('eliminarconfcomprobante/{idconfcomprobante}','VentasController@deleteConfcomprobante');





// RUTAS PARA EL MODULO AYUDA

		// ESTA RUTA MUESTRA LA VENTANA PRINCIPAL DEL MONDULO CATALOGO
				Route::get('catalogo', "AyudaController@mostrarCatalogo");


