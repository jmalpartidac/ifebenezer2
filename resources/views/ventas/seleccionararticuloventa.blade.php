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
                        SELECCIONAR ARTICULOS PARA DETALLE DE VENTA
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevaseleccionarticuloventa" role="form" method="post" enctype="multipart/form-data">
                        {{ csrf_field() }}
                        <input type="hidden" name="idventa" value="{{ $idventa }}">
						<input type="hidden" id="idarticulo" name="idarticulo">

                        <div class="form-group col-lg-4">
                            <label >Articulo</label>
                            <select  id="articulo" onchange="myFunction();" class="form-control select2" placeholder="Seleccione" name="idarticulo" required>
                                    <?php
                                        foreach ($articulos as $uni) {
                                    ?>
                                    <option value="<?php echo $uni->idarticulo; ?>"><?php echo $uni->articulo; ?></option>
                                    <?php
                                        }
                                    ?>
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Cantidad</label>
                            <input 
                            type="text" class="form-control" name="cantidad" placeholder="Ingrese Cantidad" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Precio Unitario</label>
                            <input type="text" class="form-control" name="preciodeventa" placeholder="Ingrese Precio Unitario" required>
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