@extends('layout.home')
@section('contenido')

<script type="text/javascript">
    function myFunction(id,id2) {
        var url = '{{ url('/') }}/eliminararticuloseleccionadoenventa/'+id+'/'+id2;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }
</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
					@if (isset($ventas))
                        Detalle de Venta
                    @else 
                        Nueva Venta
                        @endif
                </header>
                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevaventa" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idventa" 
                        @if (isset($ventas))
                        value="{{ $ventas[0]->idventa }}"
                        @endif >
                        <div class="form-group col-lg-4">
                            <label >Cliente</label>
                            <select class="form-control select2" name="idcliente" required>
                            	@if (isset($ventas))
                        			<option value="{{ $ventas[0]->idcliente }}">{{ $ventas[0]->cliente }}</option>
                        			<?php
                                        foreach ($clientes as $cliente) {
                                    ?>
                                    <option value="<?php echo $cliente->idcliente; ?>"><?php echo $cliente->cliente; ?></option>
                                    <?php
                                        }
                                    ?>
                        		@else 
                                    <?php
                                        foreach ($clientes as $cliente) {
                                    ?>
                                    <option value="<?php echo $cliente->idcliente; ?>"><?php echo $cliente->cliente; ?></option>
                                    <?php
                                        }
                                    ?>
                                @endif
                            </select> 
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Tipo de Comprobante</label>
                            <select class="form-control select2" name="tipocomprobante" required>
                            	@if (isset($ventas))
                            		<option value="{{ $ventas[0]->tipocomprobante }}">{{ $ventas[0]->tipocomprobante }}</option>
                        			<?php
                                        foreach ($tipocomprobante as $tipo) {
                                    ?>
                                    <option value="<?php echo $tipo->nombre; ?>"><?php echo $tipo->nombre; ?></option>
                                    <?php
                                        }
                                    ?>
                        		@else 
                                    <?php
                                        foreach ($tipocomprobante as $tipo) {
                                    ?>
                                    <option value="<?php echo $tipo->nombre; ?>"><?php echo $tipo->nombre; ?></option>
                                    <?php
                                        }
                                    ?>
                                @endif
                            </select> 
                        </div>
                        <div class="form-group col-lg-4">
                        <label >Impuesto</label>
                            <input 
                            @if (isset($ventas))
                            value="{{ $ventas[0]->impuesto }}"
                            @endif
                            value="{{ $general[0]->impuesto }}" 
                            disabled="" type="text" class="form-control" name="impuesto">
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-12">
                            	@if (isset($ventas))
                                <a href="{{ url('/') }}/seleccionararticulosventa/{{ $ventas[0]->idventa }}" type="button" class="btn btn-info" style="background-color: #356dc1;border-color: #144582;color: #ffffff;"><i class="fa fa-search"></i> Seleccionar Articulos para el detalle de Venta</a>
                                @endif
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/ventas" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>
                    </form>
                    @if (isset($ventas))
                    <div class="row">
                        <div class="col-sm-12">
                            <section class="panel">
                                <header class="panel-heading head-border">
                                    Articulos Ingresados
                                </header>
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;" ><i class="fa fa-barcode"></i> Cod. Reg</th>
                                        <th style="text-align: center;"><i class="fa fa-suitcase"></i> Articulo</th>
                                        <th style="text-align: center;"><i class="fa fa-maxcdn"></i> Marca</th>
                                        <th style="text-align: center;"><i class="fa fa-file-text"></i> Descripción</th>
                                        <th style="text-align: center;"><i class="fa fa-cubes"></i> Cantidad</th>
                                        <th style="text-align: center;"><i class="fa fa-money"></i> Precio Unitario</th>
                                        <th style="text-align: center;"><i class="fa fa-cogs"></i> Acción</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <?php
                                        foreach ($articulosvendidos as $articulo) {
                                    ?>
                                    <tr style="text-align: center;">
                                        <td><?php echo $articulo->idartxdocven; ?></td>
                                        <td><?php echo $articulo->articulo; ?></td>
                                        <td><?php echo $articulo->marca; ?></td>
                                        <td><?php echo $articulo->descripcion; ?></td>
                                        <td><?php echo $articulo->cantidad; ?></td>
                                        <td><?php echo $articulo->preciodeventa; ?></td>
                                        <td>
                                            <a href="javascript:;" onclick="myFunction('<?php echo $articulo->idartxdocven; ?>', {{ $ventas[0]->idventa }})" class="btn btn-danger btn-xs" ><i class="fa fa-trash-o "></i></a>
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