@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($proveedores))
                            Editar Proveedor
                        @else 
                            Nuevo Proveedor
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevoproveedor" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idproveedor" 
                        @if (isset($proveedores))
                        value="{{ $proveedores[0]->idproveedor }}"
                        @endif >
                        <div class="form-group col-lg-6">
                            <label >Proveedor</label>
                            <input 
                            @if (isset($proveedores))
                            value="{{ $proveedores[0]->nombre }}" 
                            @endif
                            type="text" class="form-control" name="nombre" placeholder="Ingrese Proveedor" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Direccion</label>
                            <input 
                            @if (isset($proveedores))
                            value="{{ $proveedores[0]->direccion }}" 
                            @endif
                            type="text" class="form-control" name="direccion" placeholder="Ingrese Direccion" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Ruc</label>
                            <input 
                            @if (isset($proveedores))
                            value="{{ $proveedores[0]->ruc }}" 
                            @endif
                            type="text" class="form-control" name="ruc" placeholder="Ingrese Ruc" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Email</label>
                            <input 
                            @if (isset($proveedores))
                            value="{{ $proveedores[0]->email }}" 
                            @endif
                            type="text" class="form-control" name="email" placeholder="Ingrese Email" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Telefono</label>
                            <input 
                            @if (isset($proveedores))
                            value="{{ $proveedores[0]->telefono }}" 
                            @endif
                            type="text" class="form-control" name="telefono" placeholder="Ingrese Telefono" required>
                        </div>
                        
                        <div class="panel-body">
                            <div class="col-lg-8">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/proveedores" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection