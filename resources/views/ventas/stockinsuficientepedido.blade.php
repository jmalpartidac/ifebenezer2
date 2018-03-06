@extends('layout.home')
@section('contenido')

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border" style="color:white; background: #a50000; border-bottom: 0px solid #082d4f;">
                    Alerta de Sistema
                </header>
                <div class="panel-body">
                    <div class="col-lg-6">
                        <a href="{{ url('/') }}/pedidos" class="btn btn-primary" style="background-color: #a50000;border-color: #500000;"><i class="fa fa-times"></i> Cerrar </a>
                    </div>
                </div>
                <table class="table responsive-data-table data-table dataTable no-footer dtr-inline" style="padding: 10px;">
                    <thead>
                        <tr class="active">
                            <th style="text-align: center;"><i class="fa fa-barcode"></i> Codigo de Articulo</th>
                            <th style="text-align: center;"><i class="fa fa-language"></i> Articulo</th>
                            <th style="text-align: center;"><i class="fa fa-cubes"></i> Stock Actual</th>
                            <th style="text-align: center;"><i class="fa fa-cube"></i> Cantidad Solicitada</th>
                            <th style="text-align: center;"><i class="fa fa-warning"></i> Error</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($stockinsuficiente as $stock) {
                    ?>
                        <tr>
                            <td class="hidden-xs"><?php echo $stock->idarticulo; ?></td>
                            <td class="hidden-xs"><?php echo $stock->nombre; ?></td>
                            <td class="hidden-xs"><?php echo $stock->stockenalmacen; ?></td>
                            <td class="hidden-xs"><?php echo $stock->cantidadsolicitada; ?></td>
                            <td class="hidden-xs" style="color: #ffffff; background: #a50000;"><?php echo $stock->msj; ?></td>
                        </tr>
                    <?php
                        }
                    ?>
                    </tbody>
                </table>
            </section>
        </div>
    </div>
</div>

@endsection