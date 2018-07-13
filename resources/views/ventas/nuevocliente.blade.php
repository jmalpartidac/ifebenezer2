@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($clientesC))
                            Editar Cliente
                        @else 
                            Nuevo Cliente
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevocliente" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idcliente" 
                        @if (isset($clientesC))
                        value="{{ $clientesC[0]->idcliente }}"
                        @endif >
                        <div class="form-group col-lg-6">
                            <label >Nombres</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->nombre }}" 
                            @endif
                            type="text" class="form-control" name="nombre" placeholder="Ingrese Nombres" required>
                        </div>
                        <div class="form-group col-lg-3">
                            <label >Tipo de Documento</label>
                            <select class="form-control select2" placeholder="Seleccione" name="tipdoc" required>
                                @if (isset($clientesC))
                                        <option value="{{ $clientesC[0]->tipodocumento }}">{{ $clientesC[0]->tipodocumento }}</option>
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
                        <div class="form-group col-lg-3">
                            <label >Documento</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->documento }}" 
                            @endif
                            type="text" class="form-control" name="documento" placeholder="Ingrese Documento" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Telefono</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->telefono }}" 
                            @endif
                            type="text" class="form-control" name="telefono" placeholder="Ingrese Telefono" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Email</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->email }}" 
                            @endif
                            type="text" class="form-control" name="email" placeholder="Ingrese Email" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Departamento</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->departamento }}" 
                            @endif
                            type="text" class="form-control" name="departamento" placeholder="Ingrese Departamento" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Provincia</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->provincia }}" 
                            @endif
                            type="text" class="form-control" name="provincia" placeholder="Ingrese Provincia" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Distrito</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->distrito }}" 
                            @endif
                            type="text" class="form-control" name="distrito" placeholder="Ingrese Distrito" required>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Calle</label>
                            <input 
                            @if (isset($clientesC))
                            value="{{ $clientesC[0]->calle }}" 
                            @endif
                            type="text" class="form-control" name="calle" placeholder="Ingrese Calle" required>
                        </div>
                        
                        <div class="panel-body">
                            <div class="col-lg-8">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/clientes" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection