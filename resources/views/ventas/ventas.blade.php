@extends('layout.home')
@section('contenido')

<script type="text/javascript">
   
    function myFunction(id) {
        var url = '{{ url('/') }}/eliminarventa/'+id;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }

    function confirmarVenta(id) {
        var url = '{{ url('/') }}/confirmarventa/'+id;
        $('#confirmar').attr('href',url);
        $('#myModal2').modal('show');
    }

    function imprimirBoleta(id) {
        var url = '{{ url('/') }}/imprimirboleta/'+id;
        $('#confirmar04').attr('href',url);
        $('#myModal4').modal('show');
    }

    function habilitar(sel){

      if (sel.value=="Credito"){
           $("#contenedorcuotas").css('display','block');

      }else{

           $("#contenedorcuotas").css('display','none');
      }
    }
    $(document).ready(function(){
         @if (Session::has('flg_imprimirboleta'))
            @if (Session::get('flg_imprimirboleta') == "1")
                var id = '{{Session::get("flg_imprimirboleta_id")}}';
                $('#myModal4').modal('hide');
                imprimirBoleta(id);
            @endif
            {{Session::forget("flg_imprimirboleta")}}
            {{Session::forget("flg_imprimirboleta_id")}}
        @endif
    });

</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Ventas
                </header>
                <div class="panel-body">
                    <div class="col-lg-6">
                        <a href="{{ url('/') }}/nuevaventa" type="button" class="btn btn-success"><i class="fa fa-plus"></i> Nuevo </a>
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
                            <th><i class="fa fa-calendar"></i> Fecha de Registro</th>
                            <th><i class="fa fa-check-circle"></i> Estado</th>
                            <th><i class="fa fa-cogs"></i> Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($ventas as $venta) {
                    ?>
                        <tr>
                            <td class="hidden-xs"><?php echo $venta->idventa; ?></td>
                            <td class="hidden-xs"><?php echo $venta->cliente; ?></td>
                            <td class="hidden-xs"
                            <?php if ($venta->tipopedido == 'Venta'): ?>
                                style="color: #4ead08;"
                            <?php endif ?>
                            ><?php echo $venta->tipopedido; ?></td>
                            <td class="hidden-xs"><?php echo $venta->tipocomprobante; ?></td>
                            <td class="hidden-xs"><?php echo $venta->igv; ?></td>
                            <td class="hidden-xs"><?php echo $venta->subtotal; ?></td>
                            <td class="hidden-xs"><?php echo $venta->total; ?></td>
                            <td class="hidden-xs"><?php echo $venta->fechaderegistro; ?></td>
                            <td class="hidden-xs"
                            <?php if ($venta->estadodeventa == 'Por Confirmar'): ?>
                                style="background: #dcdcdc; color: #000000;"
                            <?php endif ?>
                            <?php if ($venta->estadodeventa == 'Confirmado'): ?>
                                style="background: #072d4b; color: #ffffff;"
                            <?php endif ?>
                            ><?php echo $venta->estadodeventa; ?></td>
                            <td class="hidden-xs">
                                <a href="javascript:;" onclick="confirmarVenta('<?php echo $venta->idventa; ?>')" class="btn btn-info btn-xs" 
                                <?php if ($venta->estadodeventa == 'Confirmado'): ?>
                                    style="display: none;"
                                <?php endif ?>
                                ><i class="fa fa-check"></i></a>
                                <a href="{{ url('/') }}/editarventa/<?php echo $venta->idventa; ?>" class="btn btn-info btn-xs" style="background-color: #dcdcdc; border-color: #dcdcdc; color: #000000;"><i class="fa fa-eye"></i></a>
                                <a href="javascript:;" onclick="myFunction('<?php echo $venta->idventa; ?>')" class="btn btn-danger btn-xs" ><i class="fa fa-trash-o "></i></a>
                                <a href="javascript:;" onclick="imprimirBoleta('<?php echo $venta->idventa; ?>')" class="btn btn-danger btn-xs" ><i class="fa fa-print "></i></a>
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
                                    <a href="{{ url('/') }}/ventas" class="btn btn-danger"> No</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- modal -->
                    <!-- Modal -->
                    <div class="modal fade  " id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header" style="background: #041626; border-bottom: 5px solid #6e6e6e;     color: #ffffff;">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Confirmación</h4>
                                </div>
                                <div class="modal-body">
                                    <form action="{{ url('/') }}/addnuevopedido" role="form" method="post" enctype="multipart/form-data">
                                    <div>
                                        <label >Tipo de Pago</label>
                                        <select  id="tipodepago" class="form-control select2" placeholder="Seleccione" name="tipodepago" onchange="habilitar(this)">
                                                <option value="Contado">Contado</option>
                                                <option value="Credito">Credito</option>
                                        </select>
                                    </div>
                                    <div id="contenedorcuotas" style="display: none;">
                                        <label >Número de Cuotas</label>
                                        <input type="text" class="form-control" name="cuotas" id="cuotas">
                                    </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <a id="confirmar" href="javascript:;" class="btn btn-success"> Si</a>
                                    <a href="{{ url('/') }}/ventas" class="btn btn-danger"> No</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- modal -->

                    <div class="modal fade  " id="myModal4" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header" style="background: #041626; border-bottom: 5px solid #6e6e6e;     color: #ffffff;">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Confirmación</h4>
                                </div>
                                <div class="modal-body">
                                    <h5>Desea imprimir comprobante de Pago ?</h5>
                                </div>
                                <div class="modal-footer">
                                    <a id="confirmar04" href="javascript:;" target="_blank" class="btn btn-success"> Si</a>
                                    <a href="#" class="btn btn-danger" onclick="$('#myModal4').modal('hide')"> No</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    </tbody>
                </table>
            </section>
        </div>
    </div>
</div>

@endsection