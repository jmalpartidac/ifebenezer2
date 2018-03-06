@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($subcategorias))
                            Editar Sub Categoria
                        @else 
                            Nueva Subcategoria
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevasubcategoria" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idsubcategoria" 
                        @if (isset($subcategorias))
                        value="{{ $subcategorias[0]->idsubcategoria }}"
                        @endif >
                        <div class="form-group col-lg-4">
                            <label >Categoria</label>
                            <select class="form-control select2" name="idcategoria" required>
                            	@if (isset($subcategorias))
                                <option value="{{ $subcategorias[0]->idcategoria }}">{{ $subcategorias[0]->categoria }}</option>
                                <?php
                                    foreach ($categorias as $categoria) {
                                ?>
                                    <option value="<?php echo $categoria->idcategoria; ?>"><?php echo $categoria->nombre; ?></option>
                                <?php
                                    }
                                ?>
                                @else 
                                <?php
                                    foreach ($categorias as $categoria) {
                                ?>
                                <option value="<?php echo $categoria->idcategoria; ?>"><?php echo $categoria->nombre; ?></option>
                                <?php
                                    }
                                ?>
                                @endif
                            </select> 
                        </div>
                        
                        <div class="form-group col-lg-8">
                            <label >Sub. Categoria</label>
                            <input 
                            @if (isset($subcategorias))
                            value="{{ $subcategorias[0]->subcategoria }}" 
                            @endif
                            type="text" class="form-control" name="subcategoria" placeholder="Ingrese Categoria" required>
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/subcategorias" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection