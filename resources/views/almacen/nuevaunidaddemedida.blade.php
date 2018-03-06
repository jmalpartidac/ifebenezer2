@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($unidadmedida))
                            Editar Unidad de Medida
                        @else 
                            Nueva Unidad de Medida
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevaunidaddemedida" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idunidadmedida" 
                        @if (isset($unidadmedida))
                        value="{{ $unidadmedida[0]->idunidadmedida }}"
                        @endif >
                        <div class="form-group col-lg-6">
                            <label >Unidad de medida</label>
                            <input 
                            @if (isset($unidadmedida))
                            value="{{ $unidadmedida[0]->nombre }}" 
                            @endif
                            type="text" class="form-control" name="nombre" placeholder="Ingrese Unidad de medida" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Prefijo</label>
                            <input 
                            @if (isset($unidadmedida))
                            value="{{ $unidadmedida[0]->prefijo }}" 
                            @endif
                            type="text" class="form-control" name="prefijo" placeholder="Ingrese Prefijo" required>
                        </div>
                        
                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/unidadesdemedida" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection