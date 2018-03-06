<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
Use Storage;
Use File;
use Auth;
use App\Models\almacen\Articulo;
use Illuminate\Support\Facades\Session;

class AyudaController extends Controller
{
    public function mostrarCatalogo(){

    	$modeloarticulo = new Articulo;

    	$data = [
    		['idarticulo','>','0'],
    		['estado','=','1']
    	];

    	$consulta = $modeloarticulo->consultar($data);

    	foreach ($consulta as $con) {

            $path = storage_path('app/'.$con->imagen);
            $type = File::mimeType($path);
            $data2 = file_get_contents($path);
            $con->tipoimagen = $type;
            $con->enImg = base64_encode($data2);
        }

    	$datos['articulos'] = $consulta;

    	return view('ayuda.catalogo')->with($datos);
    }

}
