<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ventas\Venta;

class HomeController extends Controller
{
    
    public function mostrarHome(){
        return view('includes.tablero');

    }

    public function mostrarTablero(){

    	$modeloventa = new Venta;

    	$datos = [
    		['idventa', '>', '0'],
    		['estado', '=', '1']
    	];

    	$consulta = $modeloventa->consultar($datos);

    	$data['ventas'] = $consulta;

        return view('includes.tablero')->with($data);

    }

}
