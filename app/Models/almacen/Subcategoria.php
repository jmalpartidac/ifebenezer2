<?php

namespace App\Models\almacen;

use Illuminate\Database\Eloquent\Model;
use DB;

class Subcategoria extends Model
{
    protected $table = 'subcategoria';
    protected $primaryKey = 'idsubcategoria';
    public $timestamps = false;

    public function insertar($datos) {

        $id = DB::table($this->table)
            ->insertGetId($datos);
        return $id;
    }

    public function consultar($datos) {

        $id = DB::table($this->table)
                ->orderBy('subcategoria', 'asc')
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
