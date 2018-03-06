@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">

                <header class="panel-heading head-border">
                        @if (isset($permisos))
                            Editar Permiso
                        @else 
                            Nuevo Permiso
                        @endif
                </header>

                <div class="panel-body">
                    <form action="{{ url('/') }}/addnuevopermiso" role="form" method="post" enctype="multipart/form-data"  >
                        {{ csrf_field() }}
                        <input type="hidden" name="idpermiso" 
                        @if (isset($permisos))
                        value="{{ $permisos[0]->idpermiso }}"
                        @endif >
                        <div class="form-group col-lg-4">
                            <label >Sucursal</label>
                            <select class="form-control select2" placeholder="Seleccione" name="sucursal" required>
                                    @if (isset($permisos))
                                        <option value="{{ $sucursal[0]->razonsocial }}">{{ $sucursal[0]->razonsocial }}</option>
                                        <?php
                                            foreach ($sucursal as $suc) {
                                        ?>
                                        <option value="<?php echo $suc->razonsocial; ?>"><?php echo $suc->razonsocial; ?></option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <option value="">Seleccione Categoria</option>
                                        <?php
                                            foreach ($sucursal as $suc) {
                                        ?>
                                        <option value="<?php echo $suc->razonsocial; ?>"><?php echo $suc->razonsocial; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Usuario</label>
                            <select class="form-control select2" placeholder="Seleccione" name="usuario" required>
                                    @if (isset($permisos))
                                        <option value="{{ $usuarios[0]->nombres }}">{{ $usuarios[0]->nombres }}</option>
                                        <?php
                                            foreach ($usuarios as $usu) {
                                        ?>
                                        <option value="<?php echo $usu->nombres; ?>"><?php echo $usu->nombres; ?></option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <option value="">Seleccione Categoria</option>
                                        <?php
                                            foreach ($usuarios as $usu) {
                                        ?>
                                        <option value="<?php echo $usu->nombres; ?>"><?php echo $usu->nombres; ?></option>
                                        <?php
                                            }
                                        ?>
                                    @endif
                            </select>
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Tipo de Usuario</label>
                            <select class="form-control select2" placeholder="Seleccione" name="tipusu">
                                    
                                    @if (isset($permisos))
                                        <option value="{{ $permisos[0]->tipousuario }}">{{ $permisos[0]->tipousuario }}</option>
                                        <?php
                                            foreach ($permisos as $permiso) {
                                        ?>
                                        <option value="Administrador">Administrador</option>
                                        <option value="Empleado">Empleado</option>
                                        <?php
                                            }
                                        ?>
                                        @else 
                                        <option value="">Seleccione Categoria</option>
                                        <option value="Administrador">Administrador</option>
                                        <option value="Empleado">Empleado</option>
                                    @endif
                            </select>
                        </div>
                        <div class="panel-body">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Guardar </button>
                                <a href="{{ url('/') }}/permisos" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Cancelar </a>
                            </div>
                        </div>

                    </form>
                </div>

            </section>
        </div>
    </div>

</div>

@endsection