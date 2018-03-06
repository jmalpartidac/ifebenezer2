<?php

namespace App\Models\ventas;

use Illuminate\Database\Eloquent\Model;
use DB;

class Cliente extends Model
{
    protected $table = 'cliente';
    protected $primaryKey = 'idcliente';
    public $timestamps = false;

    public function insertar($datos) {

        $id = DB::table($this->table)
            ->insertGetId($datos);
        return $id;
    }

    public function consultar($datos) {

        $id = DB::table($this->table)
                ->orderBy('cliente', 'asc')
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
