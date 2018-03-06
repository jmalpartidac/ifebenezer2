@extends('layout.home')
@section('contenido')
<!--body wrapper start-->

<div class="wrapper no-pad">
    <div class="profile-desk">
        <aside class="p-aside" style="width: 22%; background-color: #05182b;">
            <ul class="gallery">
                <li>
                    <a href="#">
                        <img  src="{{ asset('img/logo_ebe.png') }}" alt=""/>
                    </a>
                </li> 
            </ul>
        </aside>
        <aside class="p-short-info">
            <div class="widget">
                <div class="title">
                    <h1 style="font-size: 35px; color: #346b64;" >Datos Generales</h1>
                </div>
                <form role="form">
                    <div class="form-group col-lg-12">
                        <div class="form-group col-lg-12">
                            <label >Empresa</label>
                            <input value="{{ $general[0]->empresa }}" disabled="" type="text" class="form-control" name="empresa">
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Tipo Impuesto</label>
                            <input value="{{ $general[0]->tipoimpuesto }}" disabled="" type="text" class="form-control" name="tipoimpuesto">
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Impuesto</label>
                            <input value="{{ $general[0]->impuesto }}" disabled="" type="text" class="form-control" name="impuesto">
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Moneda</label>
                            <input value="{{ $general[0]->moneda }}" disabled="" type="text" class="form-control" name="moneda">
                        </div>
                        <div class="form-group col-lg-8">
                            <label >Email</label>
                            <input value="{{ $general[0]->email }}" disabled="" type="text" class="form-control" name="email">
                        </div>
                        <div class="form-group col-lg-4">
                            <label >Telefono</label>
                            <input value="{{ $general[0]->telefono }}" disabled="" type="text" class="form-control" name="telefono">
                        </div>
                        <div class="form-group col-lg-12">
                            <label >Direccion</label>
                            <input value="{{ $general[0]->direccion }}" disabled="" type="text" class="form-control" name="direccion">
                        </div>
                    </div>
                </form>
            </div>
        </aside>
    </div>
</div>
<!--body wrapper end-->

@endsection