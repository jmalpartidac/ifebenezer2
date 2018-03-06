@extends('layout.home')
@section('contenido')

<script type="text/javascript">
    function myFunction(id) {
        var url = '{{ url('/') }}/eliminarsubcategoria/'+id;
        $('#eliminar').attr('href',url);
        $('#myModal3').modal('show');
    }
</script>

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Sub. Categorias
                </header>
                <div class="panel-body">
                    <div class="col-lg-6">
                        <a href="{{ url('/') }}/nuevasubcategoria" type="button" class="btn btn-success"><i class="fa fa-plus"></i> Nuevo </a>
                    </div>
                </div>
                <table class="table responsive-data-table data-table">
                    <thead>
                        <tr class="active">
                            <th><i class="fa fa-barcode"></i> Codigo</th>
                            <th><i class="fa fa-book"></i> Categoria</th>
                            <th><i class="fa fa-book"></i> Sub. Categoria</th>
                            <th><i class="fa fa-cogs"></i> Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($subcategorias as $subcategoria) {
                    ?>
                        <tr>
                            <td class="hidden-xs"><?php echo $subcategoria->idsubcategoria; ?></td>
                            <td class="hidden-xs"><?php echo $subcategoria->categoria; ?></td>
                            <td class="hidden-xs"><?php echo $subcategoria->subcategoria; ?></td>
                            <td class="hidden-xs">
                                <a href="{{ url('/') }}/editarsubcategoria/<?php echo $subcategoria->idsubcategoria; ?>" class="btn btn-warning btn-xs"><i class="fa fa-pencil"></i></a>
                                <a href="javascript:;" onclick="myFunction('<?php echo $subcategoria->idsubcategoria; ?>')" class="btn btn-danger btn-xs" ><i class="fa fa-trash-o "></i></a>
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