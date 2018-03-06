<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\mantenimiento\User;
use App\Models\mantenimiento\Tipodocumento;
use App\Models\mantenimiento\Sucursal;
use App\Models\mantenimiento\Permiso;
use App\Models\mantenimiento\General;
Use Storage;
Use File;
use Auth;
use Illuminate\Support\Facades\Session;

class MantenimientoController extends Controller
{

    public function mostrarGeneral(){ 

        $modelogeneral = new General;

        $datos = [
            ['idgeneral', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelogeneral->consultar($datos);

        $data['general'] = $consulta;

        return view('mantenimiento.general')->with($data);
    }
    
    public function mostrarNuevoempleado(){
        return view('mantenimiento.nuevoempleado');
    }

    public function mostrarNuevotipodocumento(){
        return view('mantenimiento.nuevotipodocumento');
    }

    public function mostrarNuevasucursal(){
        return view('mantenimiento.nuevasucursal');
    }

    public function mostrarNuevopermiso(){

        $modelosucursal = new Sucursal;
        $modelouser = new User;

        $datos = [
            ['idsucursal', '>', '0']
        ];
        $datosU = [
            ['idusuario', '>', '0']
        ];

        $consultaS = $modelosucursal->consultar($datos);
        $consultaU = $modelouser->consultar($datosU);

        $data['sucursal'] = $consultaS;
        $data['usuarios'] = $consultaU;

        return view('mantenimiento.nuevopermiso')->with($data);;
    }

//CONTROLADORES DEL MODULO EMPLEADO

    public function addNuevoempleado(Request $request){
        $modelouser = new User;

        $idusuario = $request->input('idusuario');
        $pass = $request->input('password');
        $pass = bcrypt($pass);
        

        if (empty($idusuario)){

            $file = $request->file('foto');
            // Validamos si se sube una foto
            if (count($file) > 0) {
                // Hallamos el directorio donde se almacenará el archivo
                //$carpeta = storage_path();
                $carpeta = 'public/fotos';
                $nombre = $file->getClientOriginalName();
                $ruta = $carpeta.'/'.$nombre;
                // Indicamos que queremos guardar un nuevo archivo en el disco local
                Storage::disk('local')->put($ruta, File::get($file));
                $datos['imagen'] = $ruta;
                $datos['password']  = $pass;
            }
        }else{

            $datosA['idusuario'] = $idusuario;
        }
        
        $datos['apellidos'] = $request->input('apellidos');
        $datos['nombres']   = $request->input('nombres');
        $datos['documento'] = $request->input('documento');
        $datos['email']     = $request->input('email');
        $datos['telefono']  = $request->input('telefono');
        $datos['direccion'] = $request->input('direccion');
        $datos['fecnac']    = $request->input('fecnac');

        //dd($datos);
        
        if (empty($idusuario)){
            $consulta = $modelouser->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('empleados');

        }else{
            $consulta = $modelouser->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('empleados');
        }
    }

    public function mostrarEmpleado(){
        $modelouser = new User;

        $datos = [
            ['idusuario', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelouser->consultar($datos);

        foreach ($consulta as $con) {

            $path = storage_path('app/'.$con->imagen);
            $type = File::mimeType($path);
            $data2 = file_get_contents($path);
            $con->tipoimagen = $type;
            $con->enImg = base64_encode($data2);
        }

        $data['usuarios'] = $consulta;
        return view('mantenimiento.empleados')->with($data);
    }

    public function editarEmpleado($idusuario){
        $modelouser = new User;

        $datos = [
            ['idusuario', '=', $idusuario]
        ];

        $consulta = $modelouser->consultar($datos);
        $data['usuario'] = $consulta;
        return view('mantenimiento.nuevoempleado')->with($data);
    }

    public function deleteEmpleado($idusuario){

        $modelouser = new User;
        $validando = Auth::user();

        if ($validando['idusuario'] == $idusuario) {
            Session::put('flg_msj','No puede eliminar el usuario en sesion');
            Session::put('flg_tipo','3');
            return redirect('empleados');

        }else{
            $datos = array(
            'idusuario' => $idusuario,
            );
            $datosA['estado'] = 0;

        $consulta = $modelouser->eliminar($datosA, $datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('empleados');
        }
    }

//CONTROLADORES DEL MODULO TIPO DE DOCUMENTO

    public function addNuevotipodocumento(Request $request){
        $modelotipodocumento = new Tipodocumento;

        $idtipdoc = $request->input('idtipdoc');
        $datos['nombre']   = $request->input('nombre');
        $datos['operacion'] = $request->input('operacion');
        $datosA['idtipdoc'] = $idtipdoc;
        
        if (empty($idtipdoc)){
            
            $consulta = $modelotipodocumento->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('tipodocumento');

        }else{
            $consulta = $modelotipodocumento->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('tipodocumento');
        }
    }

    public function mostrarTipodocumento(){
        $modelotipodocumento = new Tipodocumento;

        $datos = [
            ['idtipdoc', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelotipodocumento->consultar($datos);

        $data['tipdoc'] = $consulta;
        return view('mantenimiento.tipodocumento')->with($data);
    }

    public function editarTipodocumento($idtipdoc){
        $modelotipodocumento = new Tipodocumento;

        $datos = [
            ['idtipdoc', '=', $idtipdoc]
        ];

        $consulta = $modelotipodocumento->consultar($datos);
        $data['tipdoc'] = $consulta;
        return view('mantenimiento.nuevotipodocumento')->with($data);
    }

    public function deleteTipodocumento($idtipdoc){

        $modelotipodocumento = new Tipodocumento;

        $datos = array(
            'idtipdoc' => $idtipdoc,
        );

        $datosA['estado'] = 0;

        $consulta = $modelotipodocumento->eliminar($datosA,$datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('tipodocumento');
        
    }

    //CONTROLADORES DEL MODULO SUCURSAL

    public function addNuevasucursal(Request $request){
        $modelosucursal = new Sucursal;

        $idsucursal = $request->input('idsucursal');
        $datos['razonsocial']   = $request->input('razonsocial');
        $datos['documento'] = $request->input('documento');
        $datos['direccion'] = $request->input('direccion');
        $datos['email'] = $request->input('email');
        $datosA['idsucursal'] = $idsucursal;
        
        if (empty($idsucursal)){
            
            $consulta = $modelosucursal->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('sucursal');

        }else{
            $consulta = $modelosucursal->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('sucursal');
        }
    }

    public function mostrarSucursal(){
        $modelosucursal = new Sucursal;

        $datos = [
            ['idsucursal', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelosucursal->consultar($datos);

        $data['sucursal'] = $consulta;
        return view('mantenimiento.sucursal')->with($data);
    }

    public function editarSucursal($idsucursal){
        $modelosucursal = new Sucursal;

        $datos = [
            ['idsucursal', '=', $idsucursal]
        ];

        $consulta = $modelosucursal->consultar($datos);
        $data['sucursal'] = $consulta;
        return view('mantenimiento.nuevasucursal')->with($data);
    }

    public function deleteSucursal($idsucursal){

        $modelosucursal = new Sucursal;

        $datos = array(
            'idsucursal' => $idsucursal,
        );

        $datosA['estado'] = 0;

        $consulta = $modelosucursal->eliminar($datosA,$datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('sucursal');
        
    }

    //CONTROLADORES DEL MODULO PERMISOS

    public function addNuevopermiso(Request $request){
        $modelopermiso = new Permiso;

        $idpermiso = $request->input('idpermiso');

        $datos['sucursal']   = $request->input('sucursal');
        $datos['usuario'] = $request->input('usuario');
        $datos['tipousuario'] = $request->input('tipusu');

        $datosA['idpermiso'] = $idpermiso;
        
        if (empty($idpermiso)){
            
            $consulta = $modelopermiso->insertar($datos);

            Session::put('flg_msj','Se registro de manera correcta');
            Session::put('flg_tipo','1');
            return redirect('permisos');

        }else{
            $consulta = $modelopermiso->actualizar($datos, $datosA);

            Session::put('flg_msj','Se realizo la actualizacion correctamente');
            Session::put('flg_tipo','1');
            return redirect('permisos');
        }
    }

    public function mostrarPermisos(){
        $modelopermiso = new Permiso;

        $datos = [
            ['idpermiso', '>', '0'],
            ['estado', '=', '1']
        ];

        $consulta = $modelopermiso->consultar($datos);

        $data['permisos'] = $consulta;
        return view('mantenimiento.permisos')->with($data);
    }

    public function editarPermiso($idpermiso){
        $modelopermiso = new Permiso;
        $modelosucursal = new Sucursal;
        $modelouser = new User;

        $datos = [
            ['idpermiso', '=', $idpermiso]
        ];

        $datosS = [
            ['idsucursal', '>', '0']
        ];
        $datosU = [
            ['idusuario', '>', '0']
        ];
        
        $consulta = $modelopermiso->consultar($datos);
        $consultaS = $modelosucursal->consultar($datosS);
        $consultaU = $modelouser->consultar($datosU);

        $data['permisos'] = $consulta;
        $data['sucursal'] = $consultaS;
        $data['usuarios'] = $consultaU;
        
        return view('mantenimiento.nuevopermiso')->with($data);
    }

    public function deletePermiso($idpermiso){

        $modelopermiso = new Permiso;

        $datos = array(
            'idpermiso' => $idpermiso,
        );

        $datosA['estado'] = 0;

        $consulta = $modelopermiso->eliminar($datosA,$datos);
        Session::put('flg_msj','Se elimino de manera correcta');
        Session::put('flg_tipo','2');
        return redirect('permisos');
        
    }



}
