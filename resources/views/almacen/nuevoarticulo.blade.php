@extends('layout.home')
@section('contenido')

<script type="text/javascript">

$(document).ready(function(){

    $('#categoria').change(function() {
        $('#categoria option:selected').each(function(){
            var elegido = $(this).val();

            $.ajaxSetup({
                headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') }
            });

            $.post('consultasubcategoria',{elegido: elegido}, function(data){
                $('#subcategoria').html('');
                $.each(data, function(id, value){

                    $("#subcategoria").append('<option value="'+value.idsubcategoria+'">'+value.subcategoria+'</option>')

                });
                

            });
        });
    });
});

</script>

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($articulos))
                            Editar Articulo
                        @else 
                            Nuevo Articulo
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevoarticulo" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idarticulo" 
                        @if (isset($articulos))
                        value="{{ $articulos[0]->idarticulo }}"
                        @endif >
                        <div class="form-group col-lg-4">
                            <label >Categoria</label>
                            <select class="form-control select2" placeholder="Seleccione" id="categoria" name="categoria" required>
                                    @if (isset($articulos))
                                        <option value="{{ $articulos[0]->idcategoria }}">{{ $articulos[0]->categoria }}</option>
                                        <?php
                                            foreach ($categorias as $cat) {
                                        ?>
                                        <option value="<?php echo $cat->idcategoria; ?>"><?php echo $cat->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                        @else
                                        <option >Selecciones Categoria</option> 
                                        <?php
                                            foreach ($categorias as $cat) {
                                        ?>
                                        <option value="<?php echo $cat->idcategoria; ?>"><?php echo $cat->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Sub. Categoria</label>
                            <select class="form-control select2" placeholder="Seleccione" id="subcategoria" name="subcategoria" required>
                                @if (isset($articulos))
                                    <option value="{{ $articulos[0]->idsubcategoria }}">{{ $articulos[0]->subcategoria }}</option>
                                @else
                                    <option >Selecciones Sub. Categoria</option> 
                                    <option></option>
                                @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Unidad de medida</label>
                            <select class="form-control select2" placeholder="Seleccione" name="unidaddemedida" required>
                                    @if (isset($articulos))
                                        <option value="{{ $articulos[0]->unidaddemedida }}">{{ $articulos[0]->unidaddemedida }}</option>
                                        <?php
                                            foreach ($unidades as $uni) {
                                        ?>
                                        <option value="<?php echo $uni->prefijo; ?>"><?php echo $uni->nombre; ?></option>
                                        <?php
                                            }
                                        ?> 
                                        @else 
                                        <?php
                                            foreach ($unidades as $uni) {
                                        ?>
                                        <option value="<?php echo $uni->prefijo; ?>"><?php echo $uni->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Marca</label>
                            <input 
                            @if (isset($articulos))
                            value="{{ $articulos[0]->marca }}" 
                            @endif
                            type="text" class="form-control" name="marca" placeholder="Ingrese Marca" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Nombre de Articulo</label>
                            <input 
                            @if (isset($articulos))
                            value="{{ $articulos[0]->articulo }}" 
                            @endif
                            type="text" class="form-control" name="articulo" placeholder="Ingrese Nombre de Articulo" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Descripcion</label>
                            <input 
                            @if (isset($articulos))
                            value="{{ $articulos[0]->descripcion }}" 
                            @endif
                            type="text" class="form-control" name="descripcion" placeholder="Ingrese Descripcion" required>
                        </div>
                        @if (empty($articulos[0]->imagen))
                        <div class="form-group col-lg-6">
                            <label>Imagen</label>
                            <input 
                            @if (isset($articulos))
                            value="{{ $articulos[0]->imagen }}" 
                            @endif
                            name="imagen" class="file" type="file" required>
                        </div>
                        @endif
                        <div class="panel-body">
                            <div class="col-lg-8">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/articulos" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection