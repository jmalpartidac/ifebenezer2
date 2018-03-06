@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($unidadmedida))
                            Editar Categoria
                        @else 
                            Nueva Categoria
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevacategoria" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idcategoria" 
                        @if (isset($categorias))
                        value="{{ $categorias[0]->idcategoria }}"
                        @endif >
                        <div class="form-group col-lg-8">
                            <label >Categoria</label>
                            <input 
                            @if (isset($categorias))
                            value="{{ $categorias[0]->nombre }}" 
                            @endif
                            type="text" class="form-control" name="nombre" placeholder="Ingrese Categoria" required>
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/categorias" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection