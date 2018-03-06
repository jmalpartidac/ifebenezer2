@extends('layout.home')
@section('contenido')

<script type="text/javascript">
    function myFunction(id) {
        var url = '{{ url('/') }}/eliminaringresoalmacen/'+id;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }
</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Ingreso Almacen
                </header>
                <div class="panel-body">
                    <div class="col-lg-6">
                        <a href="{{ url('/') }}/nuevoingresoalmacen" type="button" class="btn btn-success"><i class="fa fa-plus"></i> Nuevo </a>
                    </div>
                </div>
                <table class="table responsive-data-table data-table">
                    <thead>
                        <tr class="active">
                            <th><i class="fa fa-barcode"></i> Codigo</th>
                            <th><i class="fa fa-truck"></i> Proveedor</th>
                            <th><i class="fa fa-folder-open"></i> T. Comprobante</th>
                            <th><i class="fa fa-bolt"></i> serie</th>
                            <th><i class="fa fa-ticket"></i> Numero</th>
                            <th><i class="fa fa-calendar"></i> Fecha de Registro</th>
                            <th><i class="fa fa-money"></i> IGV</th>
                            <th><i class="fa fa-text-width"></i> Sub Total</th>
                            <th><i class="fa fa-text-width"></i> Total</th>
                            <th><i class="fa fa-cogs"></i> Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($ingresos as $ingreso) {
                    ?>
                        <tr>
                            <td class="hidden-xs"><?php echo $ingreso->idingresoalma; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->proveedor; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->tipocomprobante; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->serie; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->numero; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->fechaderegistro; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->igv; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->subtotal; ?></td>
                            <td class="hidden-xs"><?php echo $ingreso->total; ?></td>
                            <td class="hidden-xs">
                                <a href="{{ url('/') }}/editaringresoalmacen/<?php echo $ingreso->idingresoalma; ?>" class="btn btn-info btn-xs" style="background-color: #dcdcdc; border-color: #dcdcdc; color: #000000;" ><i class="fa fa-eye"></i></a>
                                <a href="javascript:;" onclick="myFunction('<?php echo $ingreso->idingresoalma; ?>')" class="btn btn-danger btn-xs" ><i class="fa fa-trash-o "></i></a>
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
</div>

@endsection