<?php

namespace App\Models\compras;

use Illuminate\Database\Eloquent\Model;
use DB;

class Articuloxdocumento extends Model
{
   protected $table = 'articuloxdocumento';
    protected $primaryKey = 'idartxdoc';
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
}
