@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($sucursal))
                            Editar Sucursal
                        @else 
                            Nueva Sucursal
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevasucursal" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idsucursal" 
                        @if (isset($sucursal))
                        value="{{ $sucursal[0]->idsucursal }}"
                        @endif >
                        <div class="form-group col-lg-6">
                            <label >Razon Social</label>
                            <input 
                            @if (isset($sucursal))
                            value="{{ $sucursal[0]->razonsocial }}" 
                            @endif
                            type="text" class="form-control" name="razonsocial" placeholder="Ingrese Razon social" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Documento</label>
                            <input 
                            @if (isset($sucursal))
                            value="{{ $sucursal[0]->documento }}" 
                            @endif
                            type="text" class="form-control" name="documento" placeholder="Ingrese Documentol" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Direccion</label>
                            <input 
                            @if (isset($sucursal))
                            value="{{ $sucursal[0]->direccion }}" 
                            @endif
                            type="text" class="form-control" name="direccion" placeholder="Ingrese Direccion" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Email</label>
                            <input 
                            @if (isset($sucursal))
                            value="{{ $sucursal[0]->email }}" 
                            @endif
                            type="text" class="form-control" name="email" placeholder="Ingrese Email" required>
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/sucursal" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection