<?php

namespace App\Models\ventas;

use Illuminate\Database\Eloquent\Model;
use DB;

class Venta extends Model
{
    protected $table = 'venta';
    protected $primaryKey = 'idventa';
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

    public function mantenedorVenta($idventa) {
        $sql = "CALL sp_mantendedorVenta(1,".$idventa.")";
        return DB::select($sql);
    }

    public function consultarVenta($opcion,$idventa) {
        $sql = "CALL sp_consultarVenta(".$opcion.",".$idventa.")";
        return DB::select($sql);
    }
}
