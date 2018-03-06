@extends('layout.home')
@section('contenido')

<script type="text/javascript">
    function myFunction(id) {
        var url = '{{ url('/') }}/eliminarpedido/'+id;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }

    function confirmarPedido(id) {
        var url = '{{ url('/') }}/confirmarpedido/'+id;
        $('#confirmar').attr('href',url);
        $('#myModal2').modal('show');
    }
</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Pedidos
                </header>
                <div class="panel-body">
                    <div class="col-lg-6">
                        <a href="{{ url('/') }}/nuevopedido" type="button" class="btn btn-success"><i class="fa fa-plus"></i> Nuevo </a>
                    </div>
                </div>
                <table class="table responsive-data-table data-table">
                    <thead>
                        <tr class="active">
                            <th><i class="fa fa-barcode"></i> Cod. Pedido</th>
                            <th><i class="fa fa-male"></i> Cliente</th>
                            <th><i class="fa fa-male"></i> T. Pedido</th>
                            <th><i class="fa fa-folder-open"></i> T. Comprobante</th>
                            <th><i class="fa fa-jpy"></i> IGV</th>
                            <th><i class="fa fa-tumblr"></i> Sub Total</th>
                            <th><i class="fa fa-text-width"></i> Total</th>
                            <th><i class="fa fa-calendar"></i> Fecha de Entrega</th>
                            <th><i class="fa fa-check-circle"></i> Estado</th>
                            <th><i class="fa fa-cogs"></i> Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($pedidos as $pedido) {
                    ?>
                        <tr>
                            <td class="hidden-xs"><?php echo $pedido->idpedido; ?></td>
                            <td class="hidden-xs"><?php echo $pedido->cliente; ?></td>
                            <td class="hidden-xs"
                            <?php if ($pedido->tipopedido == 'Pedido'): ?>
                                style="color: #095eff;"
                            <?php endif ?>
                            <?php if ($pedido->tipopedido == 'Proforma'): ?>
                                style="color: #ff00f5;"
                            <?php endif ?>

                            ><?php echo $pedido->tipopedido; ?></td>
                            <td class="hidden-xs"><?php echo $pedido->tipocomprobante; ?></td>
                            <td class="hidden-xs"><?php echo $pedido->igv; ?></td>
                            <td class="hidden-xs"><?php echo $pedido->subtotal; ?></td>
                            <td class="hidden-xs"><?php echo $pedido->total; ?></td>
                            <td class="hidden-xs"><?php echo $pedido->fechadeentrega; ?></td>

                            <td class="hidden-xs" 
                            <?php if ($pedido->estadodepedido == 'Pendiente'): ?>
                                style="background: #dcdcdc; color: #000000;"
                            <?php endif ?>
                            <?php if ($pedido->estadodepedido == 'Atendido'): ?>
                                style="background: #072e4a; color: white;"
                            <?php endif ?>
                            ><?php echo $pedido->estadodepedido; ?></td>
                            <td class="hidden-xs">
                                <a href="javascript:;" onclick="confirmarPedido('<?php echo $pedido->idpedido; ?>')" class="btn btn-info btn-xs"
                                <?php if ($pedido->estadodepedido == 'Atendido'): ?>
                                    style="display: none;"
                                <?php endif ?>
                                ><i class="fa fa-check"></i></a>
                                <a href="{{ url('/') }}/editarpedido/<?php echo $pedido->idpedido; ?>" class="btn btn-info btn-xs" style="background-color: #dcdcdc; border-color: #dcdcdc; color: #000000;"><i class="fa fa-eye"></i></a>
                                <a href="javascript:;" onclick="myFunction('<?php echo $pedido->idpedido; ?>')" class="btn btn-danger btn-xs" ><i class="fa fa-trash-o "></i></a>
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
                                    <a href="{{ url('/') }}/pedidos" class="btn btn-danger"> No</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- modal -->
                    <!-- Modal -->
                    <div class="modal fade  " id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-sm">
                            <div class="modal-content">
                                <div class="modal-header" style="background: #041626; border-bottom: 5px solid #6e6e6e;     color: #ffffff;">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Confirmar Venta</h4>
                                </div>
                                <div class="modal-body">
                                    Estas seguro de Realizar La Venta Para el siguiente Pedido!
                                </div>
                                <div class="modal-footer">
                                    <a id="confirmar" href="javascript:;" class="btn btn-success"> Si</a>
                                    <a href="{{ url('/') }}/pedidos" class="btn btn-danger"> No</a>
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