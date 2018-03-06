@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($configuracion))
                            Editar Configuracion de Comprobante
                        @else 
                            Nueva Configuracion de Comprobante
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevaconfcomprobante" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idconfcomprobante" 
                        @if (isset($configuracion))
                        value="{{ $configuracion[0]->idconfcomprobante }}"
                        @endif >
                        <div class="form-group col-lg-4">
                            <label >Tipo de Documento</label>
                            <select class="form-control select2" placeholder="Seleccione" name="tipdoc" required>
                                    @if (isset($configuracion))
                                        <option value="{{ $configuracion[0]->tipodocumento }}">{{ $configuracion[0]->tipodocumento }}</option>
                                        <?php
                                            foreach ($tipdoc as $tip) {
                                        ?>
                                        <option value="<?php echo $tip->nombre; ?>"><?php echo $tip->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <?php
                                            foreach ($tipdoc as $tip) {
                                        ?>
                                        <option value="<?php echo $tip->nombre; ?>"><?php echo $tip->nombre; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Serie</label>
                            <input 
                            @if (isset($configuracion))
                            value="{{ $configuracion[0]->serie }}" 
                            @endif
                            type="text" class="form-control" name="serie" placeholder="Ingrese Serie" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Número</label>
                            <input 
                            @if (isset($configuracion))
                            value="{{ $configuracion[0]->numero }}" 
                            @endif
                            type="text" class="form-control" name="numero" placeholder="Ingrese Número" required>
                        </div>
                        
                        
                        <div class="panel-body">
                            <div class="col-lg-8">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/confcomprobantes" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection