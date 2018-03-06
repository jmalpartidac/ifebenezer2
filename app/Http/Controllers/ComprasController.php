<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\compras\Proveedor;
use App\Models\compras\Ingresoalmacen;
use App\Models\mantenimiento\Tipodocumento;
use App\Models\mantenimiento\General;
use App\Models\compras\Articuloxdocumento;
use App\Models\almacen\Articulo;
Use Storage;
Use File;
use Auth;
use Illuminate\Support\Facades\Session;

class ComprasController extends Controller
{
    
    public function mostrarNuevoproveedor(){
        return view('compras.nuevoproveedor');
    }

     public function mostrarSeleccionararticulo($idingresoalma){

        $modeloarticulo = new Articulo;
        
        $datos = [
            ['idarticulo', '>', '0']
        ];

        $consulta = $modeloarticulo->consultar($datos);
        
        $data['articulos'] = $consulta;
        $data['idingresoalma'] = $idingresoalma;
        
        return view('compras.seleccionararticulo')->with($data);
    }

    public function mostrarNuevoingresoalmacen(){
        
        $modeloproveedor = new Proveedor;
        $modelotipodocumento = new Tipodocumento;
        $modeloarticuloxdocumento = new Articuloxdocumento;
        $modelogeneral = new General;

        $datos = [
            ['idproveedor', '>', '0']
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $datosA = [
            ['idartxdoc', '>', '0']
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $consulta = $modeloproveedor->consultar($datos);
        $consultaT = $modelotipodocumento->consultar($datosT);
        $consultaA = $modeloarticuloxdocumento->consultar($datosA);
        $consultaG = $modelogeneral->consultar($datosG);

        $data['proveedores'] = $consulta;
        $data['tipodocumento'] = $consultaT;
        $data['artxdoc'] = $consultaA;
        $data['general'] = $consultaG;

        return view('compras.nuevoingresoalmacen')->with($data);
    }

    //CONTROLADORES DEL MODULO UNIDAD DE MEDIDA

    public function addNuevoproveedor(Request $request){
        $modeloproveedor = new Proveedor;

        $idproveedor = $request->input('idproveedor');
        $datos['nombre']   = $request->input('nombre');
        $datos['direccion'] = $request->input('direccion');
        $datos['ruc'] = $request->input('ruc');
        $datos['email'] = $request->input('email');
        $datos['telefono'] = $request->input('telefono');
        $datosA['idproveedor'] = $idproveedor;

         if (empty($idproveedor)){
            
            $consulta = $modeloproveedor->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('proveedores');

        }else{
            $consulta = $modeloproveedor->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('proveedores');
        }

    }

    public function mostrarProveedor(){
        $modeloproveedor = new Proveedor;

        $datos = [
            ['idproveedor', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modeloproveedor->consultar($datos);

        $data['proveedores'] = $consulta;
        return view('compras.proveedores')->with($data);
    }

    public function editarProveedor($idproveedor){
        $modeloproveedor = new Proveedor;

        $datos = [
            ['idproveedor', '=', $idproveedor]
        ];

        $consulta = $modeloproveedor->consultar($datos);
        $data['proveedores'] = $consulta;
        return view('compras.nuevoproveedor')->with($data);
    }

    public function deleteProveedor($idproveedor){

        $modeloproveedor = new Proveedor;

        $datos = array(
            'idproveedor' => $idproveedor,
        );

        $datosA['estado'] = 0;

        $consulta = $modeloproveedor->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('proveedores');
        
    }

    //CONTROLADORES PARA INGRESO ALMACEN

    public function mostrarIngresoalmacen(){
        $modeloingresoalmacen = new Ingresoalmacen;

        $datos = [
            ['idingresoalma', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modeloingresoalmacen->consultar($datos);

        $data['ingresos'] = $consulta;
        return view('compras.ingresoalmacen')->with($data);
    }

    public function addNuevoingresoalmacen(Request $request){

        $modeloingresoalmacen = new Ingresoalmacen;
        $modeloarticuloxdocumento = new Articuloxdocumento;
        $modelogeneral = new General;

        $idingresoalma = $request->input('idingresoalma');

        $datosC = [
            ['idingresoalma', '=', $idingresoalma],
            ['estado', '=', '1']
        ];

        $datosArticulos = [
            ['idgeneral', '>', '0']
        ];

        $consultaC = $modeloarticuloxdocumento->consultar($datosC);
        $consultaI = $modelogeneral->consultar($datosArticulos);
        $preciocompratotal = 0;
        $precio = 0;
        $cantidad = 0;
        $impuestoIGV = $consultaI[0]->impuesto;

        foreach ($consultaC as $conC) {

            $cantidad = $conC->stockingreso;

            $precio = $conC->preciocompraunitario;
            $preciocompra = $cantidad * $precio;
            $preciocompratotal = $preciocompratotal + $preciocompra;
        }

        $impuestoTotal = $preciocompratotal * $impuestoIGV;
        $datos['subtotal'] = $preciocompratotal - $impuestoTotal;
        $datos['total'] = $preciocompratotal;

        $datosA['idingresoalma'] = $idingresoalma;
        $datos['igv'] = $impuestoTotal;

         if (empty($idingresoalma)){

            $datos['fechaderegistro'] = date('Y-m-d');
            $datos['proveedor']   = $request->input('proveedor');
            $datos['tipocomprobante'] = $request->input('tipocomprobante');
            $datos['impuesto'] = $impuestoIGV;
            $datos['serie'] = $request->input('serie');
            $datos['numero'] = $request->input('numero');
            
            $consulta = $modeloingresoalmacen->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('ingresoalma');

        }else{
            $consulta = $modeloingresoalmacen->actualizar($datos, $datosA);

            Session::put('flg_msj','Se registro el detalle del documento correctamente');
            Session::put('flg_tipo','1');
            return redirect('ingresoalma');
        }

    }

    public function editarIngresoalmacen($idingresoalma){

        $modeloingresoalmacen = new Ingresoalmacen;
        $modeloproveedor = new Proveedor;
        $modelotipodocumento = new Tipodocumento;
        $modeloarticuloxdocumento = new Articuloxdocumento;
        $modelogeneral = new General;

        $datos = [
            ['idingresoalma', '=', $idingresoalma]
        ];

        $datosP = [
            ['idproveedor', '>', '0']
        ];

        $datosT = [
            ['idtipdoc', '>', '0'],
            ['operacion', '=', 'Comprobante']
        ];

        $datosA = [
            ['idartxdoc', '>', '0'],
            ['idingresoalma', '=', $idingresoalma],
            ['estado', '=', '1']
        ];

        $datosG = [
            ['idgeneral', '>', '0']
        ];

        $consulta = $modeloingresoalmacen->consultar($datos);
        $consultaP = $modeloproveedor->consultar($datosP);
        $consultaT = $modelotipodocumento->consultar($datosT);
        $consultaA = $modeloarticuloxdocumento->consultar($datosA);
        $consultaG = $modelogeneral->consultar($datosG);

        $data['ingresos'] = $consulta;
        $data['proveedores'] = $consultaP;
        $data['tipodocumento'] = $consultaT;
        $data['articulos'] = $consultaA;
        $data['general'] = $consultaG;

        return view('compras.nuevoingresoalmacen')->with($data);
    }

    public function deleteIngresoalmacen($idingresoalma){

        $modeloingresoalmacen = new Ingresoalmacen;
        $modeloarticuloxdocumento = new Articuloxdocumento;

        $datos = array(
            'idingresoalma' => $idingresoalma,
        );

        $datosA['estado'] = 0;

        $datosArticulos = [
            ['idartxdoc', '>', '0'],
            ['estado', '=', '1']
        ];

        $consultaArticulos = $modeloarticuloxdocumento->consultar($datosArticulos);

        if (count($consultaArticulos) > 0){

            Session::put('flg_msj','Existen articulos asociados a este documento y no se puede realizar la eliminacion!');
            Session::put('flg_tipo','3');
            return redirect('ingresoalma');

        }else{

            $consulta = $modeloingresoalmacen->eliminar($datosA, $datos);
            //$consulta = $modeloarticuloxdocumento->eliminar($datosA, $datos);
            Session::put('flg_msj','Se elimino de manera correcta');
            Session::put('flg_tipo','2');
            return redirect('ingresoalma');
        }
        
    }

    //CONTROLADORES PARA SELECCIONAR ARTICULO
    
    public function addNuevaseleccionarticulo(Request $request){

        $modeloarticuloxdocumento = new Articuloxdocumento;
        $modeloarticulo = new Articulo;

        $idarticulo = $request->input('idarticulo');

        $datosArt = [
            ['idarticulo', '=', $idarticulo]
        ];

        $consultaArt = $modeloarticulo->consultar($datosArt);
        
        $idiartxdoc = $request->input('idiartxdoc');
        $idingresoalma = $request->input('idingresoalma');

        $datos['articulo'] = $consultaArt[0]->articulo;
        $datos['marca'] = $consultaArt[0]->marca;
        $datos['descripcion'] = $consultaArt[0]->descripcion;
        $datos['stockingreso'] = $request->input('stockingreso');
        $datos['preciocompraunitario'] = $request->input('preciocompraunitario');
        $datos['idingresoalma'] = $idingresoalma;
        $datos['idarticulo'] = $idarticulo;
        $datosA['idiartxdoc'] = $idiartxdoc;
        $datosArt['idarticulo'] = $idarticulo;

        $stockArticulo = $consultaArt[0]->stock;
        $stockingreso = $request->input('stockingreso');
        $datosArticulos['stock'] = $stockArticulo + $stockingreso;

         if (empty($idiartxdoc)){

            $consulta = $modeloarticuloxdocumento->insertar($datos);
            $consulta = $modeloarticulo->actualizar($datosArticulos, $datosArt);

            Session::put('flg_msj','Se registro de manera correcta y se actualizo el stock del articulo');
            Session::put('flg_tipo','1');
            return redirect('editaringresoalmacen/'.$idingresoalma);

        }else{
            $consulta = $modeloarticuloxdocumento->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('nuevoingresoalmacen');
        }
    }


    public function deleteArticuloseleccionado($idartxdoc, $idingresoalma, $idarticulo){

        $modeloarticuloxdocumento = new Articuloxdocumento;
        $modeloarticulo = new Articulo;

        $datos = array(
            'idartxdoc' => $idartxdoc,
        );

        $datosA['estado'] = 0;


        $datosArt = [
            ['idarticulo', '=', $idarticulo]
        ];

        $datosDelete = [
            ['idartxdoc', '=', $idartxdoc]
        ];

        $consultaArt = $modeloarticulo->consultar($datosArt);
        $consultaDelete = $modeloarticuloxdocumento->consultar($datosDelete);

        $stockArticulo = $consultaArt[0]->stock;
        $stockdelete = $consultaDelete[0]->stockingreso;

        $datosArticulosDelete['stock'] = $stockArticulo - $stockdelete;

        $idingresoalma =  $idingresoalma;
        $consulta = $modeloarticuloxdocumento->eliminar($datosA, $datos);
        $consulta = $modeloarticulo->actualizar($datosArticulosDelete, $datosArt);
        Session::put('flg_msj','Se elimino de manera correcta y se actualizo el stock del articulo');
        Session::put('flg_tipo','2');
        return redirect('editaringresoalmacen/'.$idingresoalma);
        
    }


    
}
