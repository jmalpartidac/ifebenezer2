@extends('layout.home')

@section('cabecera')


<script type="text/javascript">

    $( document ).ready(function() {
        $('#btnConsulta03').click(function(){

            if ($('input[name=fechaini]').val() == ''){

                var fechaini = new Date();
                var afechaini = fechaini.getFullYear();
                var mfechaini = fechaini.getMonth()+1;

                if(mfechaini<10) {
                    mfechaini='0'+mfechaini.toString();
                } 

                var periodoIni = afechaini.toString()+mfechaini.toString();

            }else{
                var fechaini = $('input[name=fechaini]').val();
                var afechaini = fechaini.substr(0,4);
                var mfechaini = fechaini.substr(5,2);
                var periodoIni = afechaini+mfechaini;
            }

            if ($('input[name=fechafin]').val() == '') {
                var fechafin = new Date();
                var afechafin = fechafin.getFullYear();
                var mfechafin = fechafin.getMonth()+1;

                if(mfechaini<10) {
                    mfechafin='0'+mfechafin.toString();
                } 

                var periodoFin = afechafin.toString()+mfechafin.toString();
            }else{
                var fechafin = $('input[name=fechafin]').val();
                var afechafin = fechafin.substr(0,4);
                var mfechafin = fechafin.substr(5,2);
                var periodoFin = afechafin+mfechafin;
            }

            var cadena = 'fechaini=' + periodoIni + '&fechafin=' + periodoFin + '&pora=' + $('input[name=pclaseA]').val() + '&porb=' + $('input[name=pclaseB]').val();
            //alert(cadena);
            $(this).attr('href','{{ url('/') }}/forma3?'+cadena);
        });
    });
    
</script>
@endsection

@section('contenido')

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Clasificación Por Utilización y Valor
                </header>
                <div class="panel-body">
                    <div class="tab-content">
                        <div id="home" class="tab-pane active">

                            <div class="form-group col-lg-3">
                                <label >Fecha Inicio</label>
                                <div data-date-viewmode="years" data-date-format="yyyy-mm-dd" class="input-append date dpYears">
                                    <input name="fechaini" type="text" readonly="" size="16" class="form-control" required>
                                      <span class="input-group-btn add-on">
                                        <button class="btn btn-primary" type="button"><i class="fa fa-calendar"></i></button>
                                      </span>
                                </div>
                            </div>

                            <div class="form-group col-lg-3">
                                <label >Fecha Fin</label>
                                <div data-date-viewmode="years" data-date-format="yyyy-mm-dd" class="input-append date dpYears">
                                    <input name="fechafin" type="text" readonly="" size="16" class="form-control" required>
                                      <span class="input-group-btn add-on">
                                        <button class="btn btn-primary" type="button"><i class="fa fa-calendar"></i></button>
                                      </span>
                                </div>
                            </div>

                            <div class="form-group col-lg-3">
                                <label >% Clase A</label>
                                <input type="text" class="form-control" name="pclaseA" placeholder="Porcentaje Clasificación A" required>
                            </div>

                            <div class="form-group col-lg-3">
                                <label >% Clase B</label>
                                <input type="text" class="form-control" name="pclaseB" placeholder="Porcentaje Clasificación B" required>
                            </div>

                            <div class="panel-body">
                                <div class="col-lg-8">
                                    <a href="{{ url('/') }}/forma3" type="button" class="btn btn-success" id="btnConsulta03"><i></i> Realizar Clasificación por Uso</a> 
                                </div>
                            </div>

                            <table class="table responsive-data-table data-table">
                                <thead>
                                    <tr class="active">
                                        <th><i class="fa fa-renren"></i> Número</th>
                                        <th><i class="fa fa-asterisk"></i> Artículo</th>
                                        <th><i class="fa fa-plus-square"></i> Cantidad</th>
                                        <th><i class="fa fa-money"></i> Precio Unitario</th>
                                        <th><i class="fa fa-money"></i> Valor Total</th>
                                        <th><i class="fa fa-sitemap"></i> Clasificación</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    foreach ($clasificacion as $class) {
                                ?>
                                    <tr>
                                        <td class="hidden-xs"><?php echo $class->indice; ?></td>
                                        <td class="hidden-xs pull-left"><?php echo $class->articulo; ?></td>
                                        <td class="hidden-xs"><?php echo $class->cantidad; ?></td>
                                        <td class="hidden-xs"><?php echo $class->preciounitario; ?></td>
                                        <td class="hidden-xs"><?php echo $class->valortotal; ?></td>
                                        <td class="hidden-xs">
                                        <?php 
                                            if ($class->clasificacion == 'A') {
                                        ?>
                                            <a class="btn btn-success" style="width: 100px; background: #f44336;"><i></i> A </a> 
                                        <?php 
                                            }else if ($class->clasificacion == 'B') {
                                        ?>
                                            <a class="btn btn-success" style="width: 100px; background: #ff9800;"><i></i> B </a> 
                                        <?php
                                            }else if ($class->clasificacion == 'C'){
                                        ?>
                                            <a class="btn btn-success" style="width: 100px; background: #53d192;"><i></i> C </a> 
                                        <?php 
                                            }
                                        ?>
                                        </td>
                                    </tr>
                                <?php
                                    }
                                ?>
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>

            </section>
        </div>
    </div>
</div>

@endsection