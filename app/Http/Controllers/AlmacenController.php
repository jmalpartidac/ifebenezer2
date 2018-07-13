<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\almacen\Unidadmedida;
use App\Models\almacen\Categoria;
use App\Models\almacen\Subcategoria;
use App\Models\almacen\Articulo;
use Storage;
use File;
use Auth;
use Illuminate\Support\Facades\Session;

class AlmacenController extends Controller
{
    public function mostrarNuevaunidaddemedida(){
        return view('almacen.nuevaunidaddemedida');
    }

    public function mostrarNuevacategoria(){
        return view('almacen.nuevacategoria');
    }

    public function ClasificarForma1(Request $request){

        $modeloarticulo = new Articulo;

        $opcion = 1;
        $fechainicio = $request->input('fechaini');
        $fechafin = $request->input('fechafin');

        if ($fechainicio == "" || $fechafin == ""){
            $consulta = array();
        }else{
            $datos['valor01'] = $opcion;
            $datos['valor02'] = $fechainicio;
            $datos['valor03'] = $fechafin;
            $datos['valor04'] = 0;
            $datos['valor05'] = 0;

            $consulta = $modeloarticulo->consultarData($datos);
        }
        $data['clasificacion'] = $consulta;

        return view('clasificacion.forma1')->with($data);

    }

    public function ClasificarForma2(Request $request){

        $modeloarticulo = new Articulo;

        $opcion = 2;
        $fechainicio = $request->input('fechaini');
        $fechafin = $request->input('fechafin');
        $pclaseA = $request->input('pora');
        $pclaseB = $request->input('porb');

        if ($fechainicio == "" || $fechafin == ""){
            $consulta = array();
        }else{

            $datos['valor01'] = $opcion;
            $datos['valor02'] = $fechainicio;
            $datos['valor03'] = $fechafin;

            if ($pclaseA == '') {
                $datos['valor04'] = 0;
            }else {
                $datos['valor04'] = $pclaseA / 100;
            }

            if ($pclaseB == '') {
                $datos['valor05'] = 0;
            }else {
                $datos['valor05'] = $pclaseB / 100;
            }

            $consulta = $modeloarticulo->consultarData($datos);
        }
        $data['clasificacion'] = $consulta;

        return view('clasificacion.forma2')->with($data);

    }

    public function ClasificarForma3(Request $request){

        $modeloarticulo = new Articulo;

        $opcion = 3;
        $fechainicio = $request->input('fechaini');
        $fechafin = $request->input('fechafin');
        $pclaseA = 0;
        $pclaseB = 0;

        $datos['valor01'] = $opcion;
        $datos['valor02'] = $fechainicio;
        $datos['valor03'] = $fechafin;
        
        if ($pclaseA == '') {
            $datos['valor04'] = 0;
        }else {
            $datos['valor04'] = $pclaseA / 100;
        }

        if ($pclaseB == '') {
            $datos['valor05'] = 0;
        }else {
            $datos['valor05'] = $pclaseB / 100;
        }

        $consulta = $modeloarticulo->consultarData($datos);
        $data['clasificacion'] = $consulta;

        return view('clasificacion.forma3')->with($data);

    }

    public function Promedio(Request $request){

        $modeloarticulo = new Articulo;

        $opcion = 4;

        $datos['valor01'] = $opcion;
        $datos['valor02'] = 0;
        $datos['valor03'] = 0;
        $datos['valor04'] = 0;
        $datos['valor05'] = 0;

        $consulta = $modeloarticulo->consultarData($datos);
        $data['clasificacion'] = $consulta;

        return view('clasificacion.promedio')->with($data);

    }

    public function mostrarNuevasubcategoria(){

        $modelocategoria = new Categoria;

        $datos = [
            ['idcategoria', '>', '0']
        ];

        $consulta = $modelocategoria->consultar($datos);

        $data['categorias'] = $consulta;

        return view('almacen.nuevasubcategoria')->with($data);
    }

    public function mostrarNuevoarticulo(){

        $modelocategoria = new Categoria;
        $modelocategoriaU = new Unidadmedida;

        $datos = [
            ['idcategoria', '>', '0']
        ];
        $datosU = [
            ['idunidadmedida', '>', '0']
        ];

        $consulta = $modelocategoria->consultar($datos);
        $consultaU = $modelocategoriaU->consultar($datosU);

        $data['categorias'] = $consulta;
        $data['unidades'] = $consultaU;
        return view('almacen.nuevoarticulo')->with($data);
    }

//CONTROLADORES DEL MODULO UNIDAD DE MEDIDA

    public function addNuevaunidaddemedida(Request $request){
        $modelounidadmedida = new Unidadmedida;

        $idunidadmedida = $request->input('idunidadmedida');
        $datos['nombre']   = $request->input('nombre');
        $datos['prefijo'] = $request->input('prefijo');
        $datosA['idunidadmedida'] = $idunidadmedida;

         if (empty($idunidadmedida)){
            
            $consulta = $modelounidadmedida->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('unidadesdemedida');

        }else{
            $consulta = $modelounidadmedida->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('unidadesdemedida');
        }

    }

    public function mostrarUnidaddemedida(){
        $modelounidadmedida = new Unidadmedida;

        $datos = [
            ['idunidadmedida', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelounidadmedida->consultar($datos);

        $data['unidadmedida'] = $consulta;
        return view('almacen.unidadesdemedida')->with($data);
    }

    public function editarUnidaddemedida($idunidadmedida){
        $modelounidadmedida = new Unidadmedida;

        $datos = [
            ['idunidadmedida', '=', $idunidadmedida]
        ];

        $consulta = $modelounidadmedida->consultar($datos);
        $data['unidadmedida'] = $consulta;
        return view('almacen.nuevaunidaddemedida')->with($data);
    }

    public function deleteUnidaddemedida($idunidadmedida){

        $modelounidadmedida = new Unidadmedida;

        $datos = array(
            'idunidadmedida' => $idunidadmedida,
        );

        $datosA['estado'] = 0;

        $consulta = $modelounidadmedida->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('unidadesdemedida');
        
    }

    //CONTROLADORES DEL MODULO CATEGORIA

    public function addNuevacategoria(Request $request){
        $modelocategoria = new Categoria;

        $idcategoria = $request->input('idcategoria');
        $datos['nombre']   = $request->input('nombre');
        $datosA['idcategoria'] = $idcategoria;

         if (empty($idcategoria)){
            
            $consulta = $modelocategoria->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('categorias');

        }else{
            $consulta = $modelocategoria->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('categorias');
        }

    }

    public function mostrarCategoria(){
        $modelocategoria = new Categoria;

        $datos = [
            ['idcategoria', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelocategoria->consultar($datos);

        $data['categorias'] = $consulta;
        return view('almacen.categorias')->with($data);
    }

    public function editarCategoria($idcategoria){
        $modelocategoria = new Categoria;

        $datos = [
            ['idcategoria', '=', $idcategoria]
        ];

        $consulta = $modelocategoria->consultar($datos);
        $data['categorias'] = $consulta;
        return view('almacen.nuevacategoria')->with($data);
    }

    public function deleteCategoria($idcategoria){

        $modelocategoria = new Categoria;

        $datos = array(
            'idcategoria' => $idcategoria,
        );

        $datosA['estado'] = 0;

        $consulta = $modelocategoria->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('categorias');
        
    }

    //CONTROLADORES DEL MODULO ARTICULO

    public function addNuevoarticulo(Request $request){
        $modeloarticulo = new Articulo;
        $modelocategoria = new Categoria;
        $modelosubcategoria = new Subcategoria;
        $modelounidadmedida = new Unidadmedida;

        $idarticulo = $request->input('idarticulo');

        if (empty($idarticulo)){

            $file = $request->file('imagen');
            // Validamos si se sube una foto
            if (count($file) > 0) {
                // Hallamos el directorio donde se almacenará el archivo
                //$carpeta = storage_path();
                $carpeta = 'public/articulos';
                $nombre = $file->getClientOriginalName();
                $ruta = $carpeta.'/'.$nombre;
                // Indicamos que queremos guardar un nuevo archivo en el disco local
                Storage::disk('local')->put($ruta, File::get($file));
                $datos['imagen'] = $ruta;
            }
        }else{
            $datosA['idarticulo'] = $idarticulo;
        }

        $idcategoria = $datos['idcategoria']   = $request->input('categoria');
        $idsubcategoria = $datos['idsubcategoria'] = $request->input('subcategoria');
        //solo me sirve para obtener la unidad de medida
        $prefijo = $data['prefijo'] = $request->input('unidaddemedida');

        $dataC = [
            ['idcategoria','=',$idcategoria]
        ];

        $dataSc = [
            ['idsubcategoria','=',$idsubcategoria]
        ];

        $dataUm = [
            ['prefijo', '=', $prefijo]
        ];

        $consultaC = $modelocategoria->consultar($dataC);
        $consultarSubCat = $modelosubcategoria->consultar($dataSc);
        $consultaUnidadMedida = $modelounidadmedida->consultar($dataUm);

        $datos['categoria'] = $consultaC[0]->nombre;
        $datos['subcategoria'] = $consultarSubCat[0]->subcategoria;
        $datos['unidaddemedida'] = $consultaUnidadMedida[0]->nombre;
        $datos['articulo'] = $request->input('articulo');
        $datos['marca'] = $request->input('marca');
        $datos['descripcion'] = $request->input('descripcion');
        

        if (empty($idarticulo)){
            
            $consulta = $modeloarticulo->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('articulos');

        }else{
            $consulta = $modeloarticulo->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('articulos');
        }

    }

    public function mostrarArticulo(){
        $modeloarticulo = new Articulo;

        $datos = [
            ['idarticulo', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modeloarticulo->consultar($datos);

        foreach ($consulta as $con) {

            $path = storage_path('app/'.$con->imagen);
            $type = File::mimeType($path);
            $data2 = file_get_contents($path);
            $con->tipoimagen = $type;
            $con->enImg = base64_encode($data2);
        }

        $data['articulos'] = $consulta;
        //dd($consulta);
        return view('almacen.articulos')->with($data);
    }

    public function editarArticulo($idarticulo){
        $modeloarticulo = new Articulo;
        $modelocategoria = new Categoria;
        $modelocategoriaU = new Unidadmedida;

        $datos = [
            ['idarticulo', '=', $idarticulo]
        ];

        $datosC = [
            ['idcategoria', '>', '0']
        ];
        $datosU = [
            ['idunidadmedida', '>', '0']
        ];

        $consulta = $modeloarticulo->consultar($datos);
        $consultaC = $modelocategoria->consultar($datosC);
        $consultaU = $modelocategoriaU->consultar($datosU);
        $data['articulos'] = $consulta;
        $data['categorias'] = $consultaC;
        $data['unidades'] = $consultaU;
        return view('almacen.nuevoarticulo')->with($data);
    }

    public function deleteArticulo($idarticulo){

        $modeloarticulo = new Articulo;

        $datos = array(
            'idarticulo' => $idarticulo,
        );

        $datosA['estado'] = 0;

        $consulta = $modeloarticulo->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('articulos');
        
    }

    //CONTROLADORES DEL MODULO SUB CATEGORI
    
    public function addNuevasubcategoria(Request $request){
        $modelosubcategoria = new Subcategoria;
        $modelocategoria = new Categoria;

        $idsubcategoria = $request->input('idsubcategoria');
        $idcategoria = $request->input('idcategoria'); 

        $datos['idcategoria'] = $request->input('idcategoria'); 
        $datos['subcategoria']   = $request->input('subcategoria');
        $datosA['idsubcategoria'] = $idsubcategoria;

        $datosC = [
            ['idcategoria', '=' , $idcategoria]
        ];


        $consultaC = $modelocategoria->consultar($datosC);
        $datos['categoria'] = $consultaC[0]->nombre;


         if (empty($idsubcategoria)){
            
            $consulta = $modelosubcategoria->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('subcategorias');

        }else{
            $consulta = $modelosubcategoria->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('subcategorias');
        }

    }
    
    public function mostrarSubcategoria(){

        $modelosubcategoria = new Subcategoria;

        $datos = [
            ['idsubcategoria', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelosubcategoria->consultar($datos);

        $data['subcategorias'] = $consulta;


        return view('almacen.subcategorias')->with($data);
    }

    public function editarSubcategoria($idsubcategoria){
        $modelosubcategoria = new Subcategoria;
        $modelocategoria = new Categoria;

        $datos = [
            ['idsubcategoria', '=', $idsubcategoria]
        ];

        $datosC = [
            ['idcategoria', '>','0' ],
            ['estado', '=', '1']
        ];

        $consulta = $modelosubcategoria->consultar($datos);
        $consultaC = $modelocategoria->consultar($datosC);

        $data['subcategorias'] = $consulta;
        $data['categorias'] = $consultaC;
        return view('almacen.nuevasubcategoria')->with($data);
    }

    public function deleteSubcategoria($idsubcategoria){

        $modelosubcategoria = new Subcategoria;

        $datos = array(
            'idsubcategoria' => $idsubcategoria,
        );

        $datosA['estado'] = 0;

        $consulta = $modelosubcategoria->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('subcategorias');
        
    }


    public function mostrarcombosubcategoria(Request $request){

        $modelosubcategoria = new Subcategoria;
        $categoria = $request->input('elegido');

        $datos = [
            ['idsubcategoria','>','0'],
            ['idcategoria', '=', $categoria]
        ];

        $consulta = $modelosubcategoria->consultar($datos);

        return $consulta;
    }

}
