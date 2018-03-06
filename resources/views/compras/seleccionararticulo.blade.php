@extends('layout.home')
@section('contenido')


<script type="text/javascript">

    function myFunction() {
         var seleccion = $('#articulo').val();
         $('#idarticulo').val(seleccion);
    }

</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        SELECCIONAR ARTICULOS
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevaseleccionarticulo" role="form" method="post" enctype="multipart/form-data">
                        {{ csrf_field() }}
                        <input type="hidden" name="idingresoalma" value="{{ $idingresoalma }}">
						<input type="hidden" id="idarticulo" name="idarticulo">

                        <div class="form-group col-lg-6">
                            <label >Articulo</label>
                            <select  id="articulo" onchange="myFunction();" class="form-control select2" placeholder="Seleccione" name="idarticulo" required>
                                    @if (isset($artxdoc))
                                        <option value="{{ $articulos[0]->idarticulo }}">{{ $articulos[0]->articulo }}</option>
                                        <?php
                                            foreach ($articulos as $uni) {
                                        ?>
                                        <option value="<?php echo $uni->idarticulo; ?>"><?php echo $uni->articulo; ?></option>
                                        <?php
                                            }
                                        ?> 
                                        @else 
                                        <?php
                                            foreach ($articulos as $uni) {
                                        ?>
                                        <option value="<?php echo $uni->idarticulo; ?>"><?php echo $uni->articulo; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-3">
                            <label >Cantidad en Unidades</label>
                            <input 
                            @if (isset($artxdoc))
                            value="{{ $artxdoc[0]->stockingreso }}" 
                            @endif
                            type="text" class="form-control" name="stockingreso" placeholder="Ingrese Cantidad" required>
                        </div>
                        <div class="form-group col-lg-3">
                            <label >Precio de Compra Unitario</label>
                            <input 
                            @if (isset($artxdoc))
                            value="{{ $artxdoc[0]->preciocompra }}" 
                            @endif
                            type="text" class="form-control" name="preciocompraunitario" placeholder="Ingrese Precio de Compra" required>
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-8">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Agregar </button>
                                <a href="{{ URL::previous() }}" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection