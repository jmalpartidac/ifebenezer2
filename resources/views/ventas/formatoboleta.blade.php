<!DOCTYPE html>
<html>
<head>
	<title>Imprimir <?= $venta[0]->tipodcumento?></title>
	<!--right slidebar-->
    <link href="{{ asset('css/slidebars.css') }}" rel="stylesheet">
    <!--switchery-->
    <link href="{{ asset('js/switchery/switchery.min.css') }}" rel="stylesheet" type="text/css" media="screen" />
    <!--common style-->
    <link href="{{ asset('css/style.css') }}" rel="stylesheet">
    <link href="{{ asset('css/style-responsive.css') }}" rel="stylesheet">
    <link href="{{ asset('css/print-invoice.css') }}" rel="stylesheet" media="print">
	<script type="text/javascript">
		if (confirm("¿Imprimir Boleta?")){
			window.print();
		}
	</script>
</head>
<body>
	<!--body wrapper start-->
            <div class="wrapper">
                <div class="panel invoice">
                    <div class="panel-body" style="background: #f1f8f9;">
                        <div class="row">
                            <div class="col-xs-3">
                                <div class="invoice-logo">
                                    <img src="{{ asset('img/logo_ebe.png') }}" alt="" style="width: 280px;"/>
                                </div>
                            </div>
                            <div class="col-xs-6" style="text-align: center;">
                                <h3>INVERSIONES FERRETERAS EBENEZER</h3>
                                <h4>Cal. Jorge K Basadre Mza. K Lote. 08 A.H. Mártires del Sutep</h4>
                                <h4>Los Olivos - Lima</h4>
                            </div>
                            <div class="col-xs-3" style="text-align: center;">
                                <div class="total-purchase">
                                    <?= $venta[0]->tipodcumento?> DE VENTA ELECTRONICA
                                </div>
                                <div class="total-purchase">
                                	<h1>20538131602</h1>
                                </div>
                                <div class="amount">
                                   N°: <?= $venta[0]->serie?> - <?= $venta[0]->numero?>
                                </div>
                            </div>
                        </div class="row">
                        <div>
                        	<div class="col-xs-8">
                                <label style="font-size: 15px; font-family: fantasy; padding: 15px;">Señor (a):</label>   <?= $venta[0]->cliente?>
                            </div>
                            <div class="col-xs-4">
                                <label style="font-size: 15px; font-family: fantasy; padding: 15px;">Fecha de Emisión:</label>   <?= $venta[0]->fechaderegistro?>
                            </div>
                        </div>
                        <table class="table table-striped table-hover">
                            <thead>
                            <tr>
                                <th>Item</th>
                                <th>Cantidad</th>
                                <th class="hidden-xs">Descripcion</th>
                                <th class="">Precio</th>
                                <th>Total</th>
                            </tr>
                            <?php 
								$i = 0;
								$totalTotal = 0;
								foreach ($lista as $fila) {
									$i++;
									$totalFila = $fila->cantidad * $fila->preciodeventa;
									$totalTotal+= $totalFila;
									echo "
										<tr>
											<td>".$i."</td>
											<td>".$fila->cantidad."</td>
											<td>".$fila->articulo."</td>
											<td>".$fila->preciodeventa."</td>
											<td>".$totalFila."</td>
										</tr>
									";
								}
							?>
                            </thead>
                            <tbody>                  
                            </tbody>
                        </table>
                        <div class="row">
                            <div class="col-xs-8">
                            </div>
                            <div class="col-xs-4">
                                <table class="table table-hover">
                                    <tbody>
                                    <tr>
                                        <td>
                                            <strong>IGV:</strong>
                                        </td>
                                        <td><strong><?= number_format($venta[0]->impuesto,2,'.',',');?></strong></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <strong>IMPUESTO:</strong>
                                        </td>
                                        <td>
                                        	<strong> S/. 
                                        		<?= $venta[0]->igv?>
                                        	</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <strong>SUB TOTAL:</strong>
                                        </td>
                                        <td>
                                        	<strong> S/. 
                                        		<?= $totalTotal - $venta[0]->igv ?>
                                        	</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <strong>TOTAL:</strong>
                                        </td>
                                        <td>
                                        	<strong> S/. 
                                        		<?= number_format($totalTotal,2,'.',',');?>
                                        	</strong>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="pull-left">
                                    <a class="btn btn-danger" onclick="javascript:window.print();"><i class="fa fa-print"></i> Imprimir</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--body wrapper end-->

	<!-- Placed js at the end of the document so the pages load faster -->
	<script src="{{ asset('js/jquery-1.10.2.min.js') }}"></script>
	<script src="{{ asset('js/jquery-migrate.js') }}"></script>
	<script src="{{ asset('js/bootstrap.min.js') }}"></script>
	<script src="{{ asset('js/modernizr.min.js') }}"></script>

	<!--Nice Scroll-->
	<script src="{{ asset('js/jquery.nicescroll.js') }}" type="text/javascript"></script>

	<!--right slidebar-->
	<script src="{{ asset('js/slidebars.min.js') }}"></script>

	<!--switchery-->
	<script src="{{ asset('js/switchery/switchery.min.js') }}"></script>
	<script src="{{ asset('js/switchery/switchery-init.js') }}"></script>

	<!--Sparkline Chart-->
	<script src="{{ asset('js/sparkline/jquery.sparkline.js') }}"></script>
	<script src="{{ asset('js/sparkline/sparkline-init.js') }}"></script>


	<!--common scripts for all pages-->
	<script src="{{ asset('js/scripts.js"></script>
</body>
</html>