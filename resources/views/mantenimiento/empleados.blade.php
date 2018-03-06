@extends('layout.home')
@section('contenido')
<script type="text/javascript">

    function myFunction(id) {
        var url = '{{ url('/') }}/eliminarempleado/'+id;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }
</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Usuarios
                </header>
                <div class="panel-body">
                    <div class="col-lg-6">
                        <a  href="{{ url('/') }}/nuevoempleado" class="btn btn-success"><i class="fa fa-plus"></i> Nuevo </a>
                    </div>
                </div>
                <table class="table responsive-data-table data-table">
                    <thead>
                        <tr class="active">
                            <th><i class="fa fa-barcode"></i> Codigo</th>
                            <th><i class="fa fa-mortar-board"></i> Apellidos</th>
                            <th><i class="fa fa-mortar-board"></i> Nombres</th>
                            <th><i class="fa fa-list-alt"></i> Documento</th>
                            <th><i class="fa fa-envelope"></i> Email</th>
                            <th><i class="fa fa-mobile-phone"></i> Telefono</th>
                            <th><i class="fa fa-home"></i> Direccion</th>
                            <th><i class="fa fa-calendar"></i> Fec. Nacimiento</th>
                            <th><i class="fa fa-calendar"></i> Foto</th>
                            <th><i class="fa fa-cogs"></i> Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($usuarios as $usuario) {
                    ?>
                        <tr>
                            <td class="hidden-xs"><?php echo $usuario->idusuario; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->apellidos; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->nombres; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->documento; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->email; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->telefono; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->direccion; ?></td>
                            <td class="hidden-xs"><?php echo $usuario->fecnac; ?></td>
                            <td class="hidden-xs">
                                <a class="btn btn-success btn-xs fotoemple" data-toggle="modal" data-tipo="{{ $usuario->tipoimagen }}" data-contenido="{{ $usuario->enImg }}" data-nombre="{{ $usuario->nombres }}" href="#galeria"><i class="fa fa-camera"></i></a>
                            </td>
                            <td class="hidden-xs">
                                <a href="{{ url('/') }}/editarempleado/<?php echo $usuario->idusuario; ?>" class="btn btn-warning btn-xs"><i class="fa fa-pencil"></i></a>
                                <a href="javascript:;" onclick="myFunction('<?php echo $usuario->idusuario; ?>')" class="btn btn-danger btn-xs"><i class="fa fa-trash-o "></i></a>
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
                                    Estas seguro de Eliminar este registro!!
                                </div>
                                <div class="modal-footer">
                                    <a id="eliminar" href="javascript:;" class="btn btn-success"> Si</a>
                                    <a data-dismiss="modal" href="javascript:void(0);" class="btn btn-danger"> No</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- modal -->
                    <!-- Modal fotografia-->
                    <div class="modal fade  " id="galeria" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-sm">
                            <div class="modal-content">
                                <div class="modal-header" id="nombrefoto">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                </div>
                                <!--body wrapper start-->
                                <div class="profile-desk">
                                    <aside>
                                        <ul class="gallery">
                                            <li>
                                                <a>
                                                    <img id="fotoempleado">
                                                </a>
                                            </li>
                                        </ul>
                                    </aside>
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