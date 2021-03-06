@extends('layout.home')
@section('contenido')

<script type="text/javascript">
    function myFunction(id,id2,id3) {
        var url = '{{ url('/') }}/eliminararticuloseleccionado/'+id+'/'+id2+'/'+id3;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }
</script>

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($ingresos))
                            Detalle de Ingreso
                        @else 
                            Nuevo Ingreso Almacen
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevoingresoalmacen" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idingresoalma" 
                        @if (isset($ingresos))
                        value="{{ $ingresos[0]->idingresoalma }}"
                        @endif >
                        <div class="form-group col-lg-8">
                            <label >Proveedor</label>
                            <select class="form-control select2" 
                            @if (isset($ingresos))
                            disabled=""
                            @endif
                            placeholder="Seleccione" name="proveedor" required>
                                    @if (isset($ingresos))
                                        <option value="{{ $proveedores[0]->nombre }}">{{ $proveedores[0]->nombre }}</option>
                                        <?php
                                            foreach ($proveedores as $proveedor) {
                                        ?>
                                        <option value="<?php echo $proveedor->nombre; ?>"><?php echo $proveedor->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <?php
                                            foreach ($proveedores as $proveedor) {
                                        ?>
                                        <option value="<?php echo $proveedor->nombre; ?>"><?php echo $proveedor->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Impuesto</label>
                            <input 
                            @if (isset($ingresos))
                            value="{{ $ingresos[0]->impuesto }}"
                            @endif
                            value="{{ $general[0]->impuesto }}" disabled="" type="text" class="form-control" name="impuesto">
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Tipo de Comprobante</label>
                            <select class="form-control select2" 
                            @if (isset($ingresos))
                            disabled=""
                            @endif
                            placeholder="Seleccione" name="tipocomprobante" required>
                                    @if (isset($ingresos))
                                        <option value="{{ $tipodocumento[0]->nombre }}">{{ $tipodocumento[0]->nombre }}</option>
                                        <?php
                                            foreach ($tipodocumento as $tipdoc) {
                                        ?>
                                        <option value="<?php echo $tipdoc->nombre; ?>"><?php echo $tipdoc->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <?php
                                            foreach ($tipodocumento as $tipdoc) {
                                        ?>
                                        <option value="<?php echo $tipdoc->nombre; ?>"><?php echo $tipdoc->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Serie</label>
                            <input 
                            @if (isset($ingresos))
                            value="{{ $ingresos[0]->serie }}" disabled=""
                            @endif
                            type="text" class="form-control" name="serie" placeholder="" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Numero</label>
                            <input
                            @if (isset($ingresos))
                            value="{{ $ingresos[0]->numero }}" disabled=""
                            @endif
                            type="text" class="form-control" name="numero" placeholder="" required>
                        </div>
                        </table>
                        <div class="panel-body">
                            <div class="col-lg-8">
                                @if (isset($ingresos))
                                <a href="{{ url('/') }}/seleccionararticulo/{{ $ingresos[0]->idingresoalma }}" type="button" class="btn btn-info" style="background-color: #356dc1;border-color: #144582;color: #ffffff;"><i class="fa fa-search"></i> Seleccionar Articulos para el detalle de ingreso</a>
                                @endif
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/ingresoalma" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>
                    </form>
                    @if (isset($ingresos))
                    <div class="row">
                        <div class="col-sm-12">
                            <section class="panel">
                                <header class="panel-heading head-border">
                                    Articulos Ingresados
                                </header>
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;" ><i class="fa fa-barcode"></i> Codigo</th>
                                        <th style="text-align: center;"><i class="fa fa-suitcase"></i> Articulo</th>
                                        <th style="text-align: center;"><i class="fa fa-maxcdn"></i> Marca</th>
                                        <th style="text-align: center;"><i class="fa fa-file-text"></i> Descripción</th>
                                        <th style="text-align: center;"><i class="fa fa-cubes"></i> Stock Ingreso</th>
                                        <th style="text-align: center;"><i class="fa fa-money"></i> Precio de Compra Unitario</th>
                                        <th style="text-align: center;"><i class="fa fa-cogs"></i> Acción</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <?php
                                        foreach ($articulos as $articulo) {
                                    ?>
                                    <tr style="text-align: center;">
                                        <td><?php echo $articulo->idartxdoc; ?></td>
                                        <td><?php echo $articulo->articulo; ?></td>
                                        <td><?php echo $articulo->marca; ?></td>
                                        <td><?php echo $articulo->descripcion; ?></td>
                                        <td><?php echo $articulo->stockingreso; ?></td>
                                        <td><?php echo $articulo->preciocompraunitario; ?></td>
                                        <td>
                                            <a href="javascript:;" onclick="myFunction('<?php echo $articulo->idartxdoc; ?>', {{ $ingresos[0]->idingresoalma }}, '<?php echo $articulo->idarticulo; ?>')" class="btn btn-danger btn-xs" ><i class="fa fa-trash-o "></i></a>
                                        </td>
                                    </tr>
                                    <?php
                                        }
                                    ?>
                                    <!-- Modal -->
                                    <div class="modal fade  " id="myModal3" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                        <div class="modal-dialog modal-sm">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                                    <h4 class="modal-title">Confirmación</h4>
                                                </div>
                                                <div class="modal-body">
                                                    Estas seguro de Eliminar este registro!
                                                </div>
                                                <div class="modal-footer">
                                                    <a id="eliminar" href="javascript:;" class="btn btn-success"> Si</a>
                                                    <a data-dismiss="modal" href="javascript:void(0);" class="btn btn-danger"> No</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- modal -->
                                    </tbody>
                                </table>
                            </section>
                        </div>
                    </div>
                    @endif
                </div>
            </section>
        </div>
    </div>
</div>




@endsection