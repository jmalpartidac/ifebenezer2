@extends('layout.home')
@section('contenido')

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Promedio
                </header>
                <div class="panel-body">
                    <div class="tab-content">
                        <div id="home" class="tab-pane active">

                            <table class="table responsive-data-table data-table">
                                <thead>
                                    <tr class="active">
                                        <th><i class="fa fa-asterisk"></i> Artículo</th>
                                        <th><i class="fa fa-money"></i> clasificación 1</th>
                                        <th><i class="fa fa-money"></i> clasificación 2</th>
                                        <th><i class="fa fa-money"></i> clasificación 3</th>
                                        <th><i class="fa fa-sitemap"></i> Promedio</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    foreach ($clasificacion as $class) {
                                ?>
                                    <tr>
                                        <td class="hidden-xs pull-left"><?php echo $class->articulo; ?></td>
                                        <td class="hidden-xs"><?php echo $class->clasificacion1; ?></td>
                                        <td class="hidden-xs"><?php echo $class->clasificacion2; ?></td>
                                        <td class="hidden-xs"><?php echo $class->clasificacion3; ?></td>
                                        <td class="hidden-xs">
                                        <?php 
                                            if ($class->promedio == 'A') {
                                        ?>
                                            <a class="btn btn-success" style="width: 100px; background: #f44336;"><i></i> A </a> 
                                        <?php 
                                            }else if ($class->promedio == 'B') {
                                        ?>
                                            <a class="btn btn-success" style="width: 100px; background: #ff9800;"><i></i> B </a> 
                                        <?php
                                            }else if ($class->promedio == 'C'){
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