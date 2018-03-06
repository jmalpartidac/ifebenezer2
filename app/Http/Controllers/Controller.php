<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use App\Models\ventas\Pedido;
use App\Models\ventas\Venta;
use Session;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function pedidosPendientes(){

        $modelopedido = new Pedido;


        if (Session::has('contadorpendientes')) {
        	
        	Session::forget('contadorpendientes');
		}
		
	        $datos = [
	            ['idpedido', '>', '0'],
	            ['estado', '=', '1'],
	            ['estadodepedido', '=', 'Pendiente'],
	            ['tipopedido', '=', 'Pedido']
	        ];

	        $consulta = $modelopedido->consultar($datos);

	        $numerodependiente = count($consulta); 

	        Session::put('contadorpendientes', $numerodependiente);

        return true;
    }

    public function ventasPorConfirmar(){

        $modeloventa = new Venta;


        if (Session::has('contadorventasporconfirmar')) {
        	
        	Session::forget('contadorventasporconfirmar');
		}
		
	        $datos = [
	            ['idventa', '>', '0'],
	            ['estado', '=', '1'],
	            ['estadodeventa', '=', 'Por Confirmar'],
	            ['tipopedido', '=', 'Venta']
	        ];

	        $consulta = $modeloventa->consultar($datos);

	        $numerodeventasxconfirmar = count($consulta); 

	        Session::put('contadorventasporconfirmar', $numerodeventasxconfirmar);

        return true;
    }
}
