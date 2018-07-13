<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\almacen\Articulo;
use App\Models\ventas\Confcomprobante;
use App\Models\ventas\Cliente;
use App\Models\ventas\Pedido;
use App\Models\ventas\Venta;
use App\Models\ventas\Articuloxdocumentopedido;
use App\Models\ventas\Articuloxdocumentoventa;
use App\Models\mantenimiento\Tipodocumento;
use App\Models\mantenimiento\General;
Use Storage;
Use File;
use Auth;
use Illuminate\Support\Facades\Session;

class VentasController extends Controller{

    public function mostrarCredito(){
        $this->pedidosPendientes();
        return view('ventas.creditos');
    }

    public function mostrarDeudapendiente(){
        $this->pedidosPendientes();
        return view('ventas.deudaspendientes');
    }

    public function mostrarSeleccionararticuloventa($idventa){

        $modeloarticulo = new Articulo;
        $this->pedidosPendientes();
        $this->ventasPorConfirmar();
        
        $datos = [
            ['idarticulo', '>', '0']
        ];

        $consulta = $modeloarticulo->consultar($datos);
        
        $data['articulos'] = $consulta;
        $data['idventa'] = $idventa;
        
        return view('ventas.seleccionararticuloventa')->with($data);
    }

    public function mostrarSeleccionararticulopedido($idpedido){

        $modeloarticulo = new Articulo;
        $this->pedidosPendientes();
        $this->ventasPorConfirmar();
        
        $datos = [
            ['idarticulo', '>', '0']
        ];

        $consulta = $modeloarticulo->consultar($datos);
        
        $data['articulos'] = $consulta;
        $data['idpedido'] = $idpedido;
        
        return view('ventas.seleccionararticulopedido')->with($data);
    }

    public function mostrarNuevaventa(){

        $modelocliente = new Cliente;
        $modelogeneral = new General;
        $modelotipodocumento = new Tipodocumento;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datosC = [
            ['idcliente', '>', '0'],
            ['estado', '=', '1']
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $consultaC = $modelocliente->consultar($datosC);
        $consultaG = $modelogeneral->consultar($datosG);
        $consultaT = $modelotipodocumento->consultar($datosT);

        $data['clientes'] = $consultaC;
        $data['general'] = $consultaG;
        $data['tipocomprobante'] = $consultaT;

        return view('ventas.nuevaventa')->with($data);

    }

    public function mostrarNuevopedido(){

        $modelocliente = new Cliente;
        $modelogeneral = new General;
        $modelotipodocumento = new Tipodocumento;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();
        
        $datosC = [
            ['idcliente', '>', '0'],
            ['estado', '=', '1']
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $consultaC = $modelocliente->consultar($datosC);
        $consultaG = $modelogeneral->consultar($datosG);
        $consultaT = $modelotipodocumento->consultar($datosT);

        $data['clientes'] = $consultaC;
        $data['general'] = $consultaG;
        $data['tipocomprobante'] = $consultaT;

        return view('ventas.nuevopedido')->with($data);
    }

    public function mostrarNuevocliente(){

        $modelotipodocumento = new Tipodocumento;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Persona']
        ];

        $consultaT = $modelotipodocumento->consultar($datosT);

        $data['tipdoc'] = $consultaT;

        return view('ventas.nuevocliente')->with($data);
    }

    public function mostrarNuevaconfcomprobante(){

        $modelotipodocumento = new Tipodocumento;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $consultaT = $modelotipodocumento->consultar($datosT);

        $data['tipdoc'] = $consultaT;

        return view('ventas.nuevaconfcomprobante')->with($data);
    }

    //CONTROLADORES DEL MODULO CONFIGURACION DE COMPROBANTES

    public function addNuevaconfcomprobante(Request $request){
        $modeloconfcomprobante = new Confcomprobante;

        $idconfcomprobante = $request->input('idconfcomprobante');
        $datos['tipodocumento']   = $request->input('tipdoc');
        $datos['serie']   = $request->input('serie');
        $datos['numero']   = $request->input('numero');
        $datosA['idconfcomprobante'] = $idconfcomprobante;

         if (empty($idconfcomprobante)){
            
            $consulta = $modeloconfcomprobante->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('confcomprobantes');

        }else{
            $consulta = $modeloconfcomprobante->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('confcomprobantes');
        }

    }

    public function mostrarConfcomprobante(){
        $modeloconfcomprobante = new Confcomprobante;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datos = [
            ['idconfcomprobante', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modeloconfcomprobante->consultar($datos);

        $data['configuracion'] = $consulta;
        return view('ventas.confcomprobantes')->with($data);
    }

    public function editarConfcomprobante($idconfcomprobante){
        $modeloconfcomprobante = new Confcomprobante;
        $modelotipodocumento = new Tipodocumento;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datos = [
            ['idconfcomprobante', '=', $idconfcomprobante]
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $consulta = $modeloconfcomprobante->consultar($datos);
        $consultaT = $modelotipodocumento->consultar($datosT);

        $data['configuracion'] = $consulta;
        $data['tipdoc'] = $consultaT;

        return view('ventas.nuevaconfcomprobante')->with($data);
    }

    public function deleteConfcomprobante($idconfcomprobante){

        $modeloconfcomprobante = new Confcomprobante;

        $datos = array(
            'idconfcomprobante' => $idconfcomprobante,
        );

        $datosA['estado'] = 0;

        $consulta = $modeloconfcomprobante->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('confcomprobantes');
        
    }

    //CONTROLADORES DEL MODULO CONFIGURACION DE CLIENTES
    
    public function addNuevocliente(Request $request){

        $modelocliente = new Cliente;

        $idcliente = $request->input('idcliente');

        $nombre = $datos['nombre'] = $request->input('nombre');
        $datos['cliente'] = $nombre;
        $datos['tipodocumento'] = $request->input('tipdoc');
        $datos['documento'] = $request->input('documento');
        $datos['email'] = $request->input('email');
        $datos['telefono'] = $request->input('telefono');
        $departamento = $datos['departamento'] = $request->input('departamento');
        $provincia = $datos['provincia'] = $request->input('provincia');
        $distrito = $datos['distrito'] = $request->input('distrito');
        $calle = $datos['calle'] = $request->input('calle');
        $datos['direccion'] = $departamento ." - ". $provincia ." - ". $distrito ." - ". $calle;
        $datosA['idcliente'] = $idcliente;

        if (empty($idcliente)){
            
            $consulta = $modelocliente->insertar($datos);

            Session::put('flg_msj','Se registro el cliente de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('clientes');

        }else{
            $consulta = $modelocliente->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('clientes');
        }
    }

    public function mostrarCliente(){
        $modelocliente = new Cliente;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datos = [
            ['idcliente', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelocliente->consultar($datos);

        $data['clientes'] = $consulta;

        return view('ventas.clientes')->with($data);
    }

    public function editarCliente($idcliente){

        $modelotipodocumento = new Tipodocumento;
        $modelocliente = new Cliente;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Persona']
        ];

        $datos = [
            ['idcliente', '=', $idcliente]
        ];


        $consultaT = $modelotipodocumento->consultar($datosT);
        $consulta = $modelocliente->consultar($datos);

        $data['tipdoc'] = $consultaT;
        $data['clientesC'] = $consulta;

        return view('ventas.nuevocliente')->with($data);
    }

    public function deleteCliente($idcliente){

        $modelocliente = new Cliente;

        $datos = array(
            'idcliente' => $idcliente,
        );

        $datosA['estado'] = 0;

        $consulta = $modelocliente->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('clientes');
        
    }

     //CONTROLADORES DEL MODULO PEDIDOS

    public function addNuevopedido(Request $request){

        $modelopedido = new Pedido;
        $modelocliente = new Cliente;
        $modelogeneral = new General;
        $modeloarticuloxdocumentopedido = new Articuloxdocumentopedido;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $idcliente = $request->input('idcliente');
        $idpedido = $request->input('idpedido');

        $datosP = [
            ['idpedido', '=', $idpedido]
        ];

        $datosC = [
            ['idcliente', '=', $idcliente]
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $datosAxP = [
            ['idpedido', '=', $idpedido],
            ['estado', '=', '1']
        ];

        $consultaP = $modelopedido->consultar($datosP);
        $consultaC = $modelocliente->consultar($datosC);
        $consultaG = $modelogeneral->consultar($datosG);
        $consultaAxP = $modeloarticuloxdocumentopedido->consultar($datosAxP);

        $cantidad = 0;
        $preciodeventa = 0;
        $subtotal = 0;
        $precioventatotal = 0;

        $impuestoIGV = $consultaG[0]->impuesto;

        foreach ($consultaAxP as $conC) {

            $cantidad = $conC->cantidad;

            $precio = $conC->preciodeventa;
            $preciodeventa = $cantidad * $precio;
            $precioventatotal = $precioventatotal + $preciodeventa;
        }

        $IGV = $precioventatotal * $impuestoIGV;
        $datos['igv'] = $IGV;
        $datos['subtotal'] = $precioventatotal - $IGV;
        $datos['total'] = $precioventatotal;

        $datos['idcliente'] = $idcliente;
        $datos['cliente'] = $consultaC[0]->cliente;
        $datos['tipocomprobante'] = $request->input('tipocomprobante');
        $tipopedido = $datos['tipopedido'] = $request->input('tipopedido');
        $datos['fechadeentrega'] = $request->input('fechadeentrega');

        if ($tipopedido == "Pedido") {
            $datos['estadodepedido'] = "Pendiente";
        }elseif ($tipopedido == "Proforma") {
            $datos['estadodepedido'] = "Atendido";
        }

        $datosA['idpedido'] = $idpedido;

        if (empty($idpedido)){
            $datos['fechaderegistro'] = date('Y-m-d');
            $datos['impuesto'] = $consultaG[0]->impuesto;
            
            $consulta = $modelopedido->insertar($datos);

            Session::put('flg_msj','Se registro el pedido de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('pedidos');

        }else{
            $datos['fechaderegistro'] = $consultaP[0]->fechaderegistro;
            $datos['impuesto'] = $consultaP[0]->impuesto;
            
            $consulta = $modelopedido->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('pedidos');
        }
    }

    public function mostrarPedido(){

        $modelopedido = new Pedido;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datos = [
            ['idpedido', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelopedido->consultar($datos);

        $data['pedidos'] = $consulta;

        return view('ventas.pedidos')->with($data);
    }

    public function editarPedido($idpedido){

        $modelocliente = new Cliente;
        $modelogeneral = new General;
        $modelotipodocumento = new Tipodocumento;
        $modelopedido = new Pedido;
        $modeloarticuloxdocumentopedido = new Articuloxdocumentopedido;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datosC = [
            ['idcliente', '>', '0'],
            ['estado', '=', '1']
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $datosP = [
            ['idpedido', '=', $idpedido],
        ];

        $datosAxP = [
            ['idartxdocped', '>', '0'],
            ['idpedido', '=', $idpedido],
            ['estado', '=', '1']
        ];

        $consultaC = $modelocliente->consultar($datosC);
        $consultaG = $modelogeneral->consultar($datosG);
        $consultaT = $modelotipodocumento->consultar($datosT);
        $consultaP = $modelopedido->consultar($datosP);
        $consultaAxP = $modeloarticuloxdocumentopedido->consultar($datosAxP);

        $data['clientes'] = $consultaC;
        $data['general'] = $consultaG;
        $data['tipocomprobante'] = $consultaT;
        $data['pedidos'] = $consultaP;
        $data['articulospedidos'] = $consultaAxP;
 
        return view('ventas.nuevopedido')->with($data);
    }

    public function deletePedido($idpedido){

        $modelopedido = new Pedido;
        $modeloarticuloxdocumentopedido = new Articuloxdocumentopedido;

        $datos = array(
            'idpedido' => $idpedido,
        );

        $datosA['estado'] = 0;

        $datosArticulos = [
            ['idartxdocped', '>', '0'],
            ['estado', '=', '1'],
            ['idpedido', '=', $idpedido]
        ];

        $consultaArticulos = $modeloarticuloxdocumentopedido->consultar($datosArticulos);

        if (count($consultaArticulos) > 0){

            Session::put('flg_msj','Existen articulos asociados a este documento y no se puede realizar la eliminacion!');
            Session::put('flg_tipo','3');
            return redirect('pedidos');

        }else{

            $consulta = $modelopedido->eliminar($datosA, $datos);
            //$consulta = $modeloarticuloxdocumento->eliminar($datosA, $datos);
            Session::put('flg_msj','Se elimino de manera correcta');
            Session::put('flg_tipo','2');
            return redirect('pedidos');
        }
        
    }
     
    //CONTROLADORES DEL MODULO SELECCION DE ARTICULOS PARA PEDIDO

    public function addNuevaseleccionarticulopedido(Request $request){

        $modeloarticuloxdocumentopedido = new Articuloxdocumentopedido;

        $modeloarticulo = new Articulo;

        $idarticulo = $request->input('idarticulo');

        $datosArt = [
            ['idarticulo', '=', $idarticulo]
        ];

        $consultaArt = $modeloarticulo->consultar($datosArt);
        
        $idartxdocped = $request->input('idartxdocped');
        $idpedido = $request->input('idpedido');

        $datos['articulo'] = $consultaArt[0]->articulo;
        $datos['marca'] = $consultaArt[0]->marca;
        $datos['descripcion'] = $consultaArt[0]->descripcion;
        $datos['cantidad'] = $request->input('cantidad');
        $datos['preciodeventa'] = $request->input('preciodeventa');
        $datos['idpedido'] = $idpedido;
        $datos['idarticulo'] = $idarticulo;

        $datosA['idartxdocped'] = $idartxdocped;
        $datosArt['idarticulo'] = $idarticulo;

         if (empty($idartxdocped)){

            $consulta = $modeloarticuloxdocumentopedido->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta el articulo');
            Session::put('flg_tipo','1');
            return redirect('editarpedido/'.$idpedido);

        }else{
            $consulta = $modeloarticuloxdocumentopedido->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('nuevopedido');
        }
    }

    public function deleteArticuloseleccionadoenpedido($idartxdocped, $idpedido){

        $modeloarticuloxdocumentopedido = new Articuloxdocumentopedido;

        $datos = array(
            'idartxdocped' => $idartxdocped,
        );

        $datosA['estado'] = 0;

        $idpedido =  $idpedido;
        $consulta = $modeloarticuloxdocumentopedido->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('editarpedido/'.$idpedido);
        
    }

    //CONTROLADORES DEL MODULO VENTAS

    public function addNuevaventa(Request $request){

        $modeloventa = new Venta;
        $modelocliente = new Cliente;
        $modelogeneral = new General;
        $modeloarticuloxdocumentoventa = new Articuloxdocumentoventa;

        $idcliente = $request->input('idcliente');
        $idventa = $request->input('idventa');

        $datosV = [
            ['idventa', '=', $idventa]
        ];

        $datosC = [
            ['idcliente', '=', $idcliente]
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $datosAxV = [
            ['idventa', '=', $idventa],
            ['estado', '=', '1']
        ];

        $consultaV = $modeloventa->consultar($datosV);
        $consultaC = $modelocliente->consultar($datosC);
        $consultaG = $modelogeneral->consultar($datosG);
        $consultaAxV = $modeloarticuloxdocumentoventa->consultar($datosAxV);

        $cantidad = 0;
        $preciodeventa = 0;
        $subtotal = 0;
        $precioventatotal = 0;

        $impuestoIGV = $consultaG[0]->impuesto;

        foreach ($consultaAxV as $conC) {

            $cantidad = $conC->cantidad;

            $precio = $conC->preciodeventa;
            $preciodeventa = $cantidad * $precio;
            $precioventatotal = $precioventatotal + $preciodeventa;
        }

        $IGV = $precioventatotal * $impuestoIGV;
        $datos['igv'] = $IGV;
        $datos['subtotal'] = $precioventatotal - $IGV;
        $datos['total'] = $precioventatotal;

        $idventa = $request->input('idventa');
        $datos['idcliente']   = $request->input('idcliente');
        $datos['cliente'] = $consultaC[0]->cliente;
        $datos['tipocomprobante']   = $request->input('tipocomprobante');
        $datos['estadodeventa'] = "Por Confirmar";

        $datosA['idventa'] = $idventa;

        if (empty($idventa)){

            $datos['fechaderegistro'] = date('Y-m-d');
            $datos['impuesto'] = $consultaG[0]->impuesto;
            
            $consulta = $modeloventa->insertar($datos);
            Session::put('flg_msj','Se registro la venta de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('ventas');

        }else{
            
            $consulta = $modeloventa->actualizar($datos, $datosA);
            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('ventas');
        }
    }

    public function mostrarVenta(){

        $modeloventa = new Venta;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datos = [
            ['idventa', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modeloventa->consultar($datos);

        $data['ventas'] = $consulta;

        return view('ventas.ventas')->with($data);
    }

    public function editarVenta($idventa){

        $modelocliente = new Cliente;
        $modelogeneral = new General;
        $modelotipodocumento = new Tipodocumento;
        $modeloventa = new Venta;
        $modeloarticuloxdocumentoventa = new Articuloxdocumentoventa;

        $this->pedidosPendientes();
        $this->ventasPorConfirmar();

        $datosC = [
            ['idcliente', '=', 'idcliente'],
            ['estado', '=', '1']
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $datosV = [
            ['idventa', '=', $idventa],
        ];

        $datosAxV = [
            ['idartxdocven', '>', '0'],
            ['idventa', '=', $idventa],
            ['estado', '=', '1']
        ];

        $consultaC = $modelocliente->consultar($datosC);
        $consultaG = $modelogeneral->consultar($datosG);
        $consultaT = $modelotipodocumento->consultar($datosT);
        $consultaV = $modeloventa->consultar($datosV);
        $consultaAxV = $modeloarticuloxdocumentoventa->consultar($datosAxV);

        $data['clientes'] = $consultaC;
        $data['general'] = $consultaG;
        $data['tipocomprobante'] = $consultaT;
        $data['ventas'] = $consultaV;
        $data['articulosvendidos'] = $consultaAxV;
 
        return view('ventas.nuevaventa')->with($data);
    }

    public function deleteVenta($idventa){

        $modeloventa = new Venta;
        $modeloarticuloxdocumentoventa = new Articuloxdocumentoventa;

        $datos = array(
            'idventa' => $idventa,
        );

        $datosA['estado'] = 0;

        $datosArticulos = [
            ['idartxdocven', '>', '0'],
            ['estado', '=', '1'],
            ['idventa', '=', $idventa]
        ];

        $consultaArticulos = $modeloarticuloxdocumentoventa->consultar($datosArticulos);

        if (count($consultaArticulos) > 0){

            Session::put('flg_msj','Existen articulos asociados a este documento y no se puede realizar la eliminacion!');
            Session::put('flg_tipo','3');
            return redirect('ventas');

        }else{

            $consulta = $modeloventa->eliminar($datosA, $datos);
            Session::put('flg_msj','Se elimino de manera correcta');
            Session::put('flg_tipo','2');
            return redirect('ventas');
        }
        
    }

    //CONTROLADORES DEL MODULO SELECCION DE ARTICULOS PARA PEDIDO

    public function addNuevaseleccionarticuloventa(Request $request){

        $modeloarticuloxdocumentoventa = new Articuloxdocumentoventa;
        $modeloarticulo = new Articulo;

        $idarticulo = $request->input('idarticulo');

        $datosArt = [
            ['idarticulo', '=', $idarticulo]
        ];

        $consultaArt = $modeloarticulo->consultar($datosArt);
        
        $idartxdocven = $request->input('idartxdocven');
        $idventa = $request->input('idventa');

        $datos['articulo'] = $consultaArt[0]->articulo;
        $datos['marca'] = $consultaArt[0]->marca;
        $datos['descripcion'] = $consultaArt[0]->descripcion;
        $datos['cantidad'] = $request->input('cantidad');
        $datos['preciodeventa'] = $request->input('preciodeventa');
        $datos['idventa'] = $idventa;
        $datos['idarticulo'] = $idarticulo;

        $datosA['idartxdocven'] = $idartxdocven;
        $datosArt['idarticulo'] = $idarticulo;

         if (empty($idartxdocven)){

            $consulta = $modeloarticuloxdocumentoventa->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta el articulo');
            Session::put('flg_tipo','1');
            return redirect('editarventa/'.$idventa);

        }else{
            $consulta = $modeloarticuloxdocumentoventa->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('nuevaventa');
        }
    }

    public function deleteArticuloseleccionadoenventa($idartxdocven, $idventa){

        $modeloarticuloxdocumentoventa = new Articuloxdocumentoventa;

        $datos = array(
            'idartxdocven' => $idartxdocven,
        );

        $datosA['estado'] = 0;

        $idventa =  $idventa;

        $consulta = $modeloarticuloxdocumentoventa->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('editarventa/'.$idventa);
        
    }

    public function confirmarVenta($idventa){

        $modeloventa = new Venta;
        $consulta = $modeloventa->mantenedorVenta($idventa);
        $contador = count($consulta);

        if ($contador == 0){
            Session::put('flg_msj','Se realizo la Venta con Exito');
            Session::put('flg_tipo','1');
            Session::put('flg_imprimirboleta','1');
            Session::put('flg_imprimirboleta_id',$idventa);
            return redirect('ventas');
        }else{

            $data['stockinsuficiente'] =  $consulta;
            return view('ventas.stockinsuficiente')->with($data);
        }  
    }

    public function imprimirboleta($idventa){
        $modeloventa = new Venta;
        $venta = $modeloventa->consultarVenta(1,$idventa);
        $productos = $modeloventa->consultarVenta(2,$idventa);

        $data['venta'] =  $venta;
        $data['lista'] =  $productos;
       // dd($data);exit;
        return view('ventas.formatoboleta')->with($data);

    }

    public function confirmarPedido($idpedido){

        $modelopedido = new Pedido;
        $consulta = $modelopedido->mantenedorPedido($idpedido);
        $contador = count($consulta);

        if ($contador == 0){
            Session::put('flg_msj','Se realizo la Venta con Exito');
            Session::put('flg_tipo','1');
            return redirect('pedidos');
        }else{

            $data['stockinsuficiente'] =  $consulta;
            return view('ventas.stockinsuficientepedido')->with($data);
        }  
    }


}
