<?php

namespace App\Models\ventas;

use Illuminate\Database\Eloquent\Model;
use DB;

class Pedido extends Model
{
    protected $table = 'pedido';
    protected $primaryKey = 'idpedido';
    public $timestamps = false;

    public function insertar($datos) {

        $id = DB::table($this->table)
            ->insertGetId($datos);
        return $id;
    }

    public function consultar($datos) {

        $id = DB::table($this->table)
                ->select('*')
                ->where($datos)
                ->get();

        return $id;

    }

    public function editar($datos) {

        $id = DB::table($this->table)
                ->select('*')
                ->where($datos)
                ->get();

        return $id;

    }

    public function actualizar($datos, $datosA) {

        $id = DB::table($this->table)
                ->where($datosA)
                ->update($datos);
        return true;

    }

    public function eliminar($datos, $datosA) {

        DB::table($this->table)
            ->where($datosA)
            ->update($datos);
        return true;
    }

    public function mantenedorPedido($idpedido) {
        $sql = "CALL sp_mantendedorPedido(1,".$idpedido.")";
        return DB::select($sql);
    }
}
