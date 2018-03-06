@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($tipdoc))
                            Editar Tipo de Documento
                        @else 
                            Nuevo Tipo de Documento
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevotipodocumento" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idtipdoc" 
                        @if (isset($tipdoc))
                        value="{{ $tipdoc[0]->idtipdoc }}"
                        @endif >
                        <div class="form-group col-lg-6">
                            <label >Nombre</label>
                            <input 
                            @if (isset($tipdoc))
                            value="{{ $tipdoc[0]->nombre }}" 
                            @endif
                            type="text" class="form-control" name="nombre" placeholder="Ingrese Nombre" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Operación</label>
                            <select class="form-control select2" placeholder="Seleccione" name="operacion">
                                    
                                    @if (isset($tipdoc))
                                        <option value="{{ $tipdoc[0]->nombre }}">{{ $tipdoc[0]->operacion }}</option>
                                        <?php
                                            foreach ($tipdoc as $tip) {
                                        ?>
                                        <option value="Persona">Persona</option>
                                        <option value="Comprobante">Comprobante</option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <option value="Persona">Persona</option>
                                        <option value="Comprobante">Comprobante</option>
                                    @endif
                            </select>
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/tipodocumento" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection