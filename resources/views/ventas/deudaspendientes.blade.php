@extends('layout.home')
@section('contenido')

<div class="wrapper">  

    <section class="panel">
        <div class="panel-body">
            <div class="col-lg-6">
                <button type="button" class="btn btn-success"><i class="fa fa-plus"></i> Nuevo </button>
                <button type="button" class="btn btn-primary"><i class="fa fa-cloud-download"></i> Exportar </button>
            </div>
            <div class="col-lg-6">
                <div class="input-group m-b-10">
                      <span class="input-group-btn">
                        <button type="button" class="btn btn-white"><i class="fa fa-search"></i></button>
                      </span>
                    <input type="text" class="form-control">
                </div>
            </div>
        </div>
    </section>

    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Deudas Pendientes
                </header>
                <table class="table table-striped custom-table table-hover">
                    <thead>
                        <tr>
                            <th><i class="fa fa-barcode"></i> Codigo</th>
                            <th><i class="fa fa-asterisk"></i> T. Venta</th>
                            <th><i class="fa fa-laptop"></i> T. Comprobante</th>
                            <th><i class="fa fa-ticket"></i> Serie</th>
                            <th><i class="fa fa-tag"></i> Numero</th>
                            <th><i class="fa fa-calendar"></i> Fecha</th>
                            <th><i class="fa fa-money"></i> Impuesto</th>
                            <th><i class="fa fa-text-width"></i> Total</th>
                            <th><i class="fa fa-credit-card"></i> Total Pagado</th>
                            <th><i class="fa fa-institution"></i> Total Deuda</th>
                            <th><i class="fa fa-cogs"></i> Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">valor</td>
                            <td class="hidden-xs">
                                <button class="btn btn-info btn-xs"><i class="fa fa-pencil"></i></button>
                                <button class="btn btn-danger btn-xs"><i class="fa fa-trash-o "></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </section>
        </div>
    </div>
</div>

@endsection