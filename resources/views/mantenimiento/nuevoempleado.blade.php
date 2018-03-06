@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                    @if (isset($usuario))
                        Editar Empleado
                    @else 
                        Nuevo Empleado
                    @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevoempleado" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}

                        <input type="hidden" name="idusuario" 
                        @if (isset($usuario))
                        value="{{ $usuario[0]->idusuario }}"
                        @endif >

                        <div class="form-group col-lg-6">
                            <label >Apellidos</label>
                            <!--  isset valida si la variable a sido decladara para mostrarla en el formulario o no -->
                            <input
                            @if (isset($usuario))
                            value="{{ $usuario[0]->apellidos }}" 
                            @endif
                            type="text" class="form-control" name="apellidos" placeholder="Ingrese Apellidos" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Nombres</label>
                            <input 
                            @if (isset($usuario))
                            value="{{ $usuario[0]->nombres }}" 
                            @endif
                            type="text" class="form-control" name="nombres" placeholder="Ingrese Nombres" required>
                        </div>
                        <div class="form-group col-lg-3">
                            <label >Documento</label>
                            <input 
                            @if (isset($usuario))
                            value="{{ $usuario[0]->documento }}" 
                            @endif
                            type="text" class="form-control" name="documento" placeholder="Ingrese Documento" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label for="exampleInputEmail1">Email</label>
                            <input 
                            @if (isset($usuario))
                            value="{{ $usuario[0]->email }}" 
                            @endif
                            type="email" class="form-control" name="email" placeholder="Ingrese email" required>
                        </div>
                        <div class="form-group col-lg-3">
                            <label >Telefono</label>
                            <input 
                            @if (isset($usuario))
                            value="{{ $usuario[0]->telefono }}" 
                            @endif
                            type="text" class="form-control" name="telefono" placeholder="Ingrese Telefono" required>
                        </div>
                        <div class="form-group col-lg-6">
                            <label >Direccion</label>
                            <input 
                            @if (isset($usuario))
                            value="{{ $usuario[0]->direccion }}" 
                            @endif
                            type="text" class="form-control" name="direccion" placeholder="Ingrese Direccion" required>
                        </div>

                        <!-- valida si la variable esta vacia -->
                        @if (empty($usuario[0]->password))
                        <div class="form-group col-lg-3">
                            <label for="exampleInputPassword1">Password</label>
                            <input type="password" class="form-control" name="password" placeholder="Ingrese Password" required>
                        </div>

                        @endif

                        @if (empty($usuario[0]->imagen))
                        <div class="form-group col-lg-6">
                            <label>Foto</label>
                            <input 
                            @if (isset($usuario))
                            value="{{ $usuario[0]->imagen }}" 
                            @endif
                            name="foto" class="file" type="file" required>
                        </div>
                        @endif

                        <div class="form-group col-lg-6">
                            <label >Fecha de Nacimiento</label>
                            <div data-date-viewmode="years" data-date-format="yyyy-mm-dd" class="input-append date dpYears">
                                <input  
                                @if (isset($usuario))
                                value="{{ $usuario[0]->fecnac }}" 
                                @endif
                                name="fecnac" type="text" readonly="" size="16" class="form-control">
                                  <span class="input-group-btn add-on">
                                    <button class="btn btn-primary" type="button"><i class="fa fa-calendar"></i></button>
                                  </span>
                            </div>
                        </div>

                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/empleados" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection