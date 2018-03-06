@extends('layout.home')
@section('contenido')

<!-- page head start-->
<div class="wrapper no-pad">
    <div class="profile-desk">
       <!--body wrapper start-->
            <div class="wrapper">

                <div class="row">
                    <div class="col-md-7">
                        <section class="panel" >
                            <header class="panel-heading">
                                Area Chart
                                <span class="tools pull-right">
                                    <a class="fa fa-repeat box-refresh" href="javascript:;"></a>
                                    <a class="t-collapse fa fa-chevron-down" href="javascript:;"></a>
                                    <a class="t-close fa fa-times" href="javascript:;"></a>
                                </span>
                            </header>
                            <div class="panel-body">
                                <div id="area-chart"></div>
                            </div>
                        </section>
                    </div>
                    <div class="col-md-5">
                        <section class="panel" >
                            <header class="panel-heading">
                                Bar Chart
                                <span class="tools pull-right">
                                    <a class="fa fa-repeat box-refresh" href="javascript:;"></a>
                                    <a class="t-collapse fa fa-chevron-down" href="javascript:;"></a>
                                    <a class="t-close fa fa-times" href="javascript:;"></a>
                                </span>
                            </header>
                            <div class="panel-body">
                                <div id="bar-chart"></div>
                            </div>
                        </section>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-7">
                        <section class="panel" >
                            <header class="panel-heading">
                                Area Line Chart
                                <span class="tools pull-right">
                                    <a class="fa fa-repeat box-refresh" href="javascript:;"></a>
                                    <a class="t-collapse fa fa-chevron-down" href="javascript:;"></a>
                                    <a class="t-close fa fa-times" href="javascript:;"></a>
                                </span>
                            </header>
                            <div class="panel-body">
                                <div id="area-line-chart"></div>
                            </div>
                        </section>
                    </div>

                    <div class="col-md-5">
                        <section class="panel" >
                            <header class="panel-heading">
                                Donut Chart
                                <span class="tools pull-right">
                                    <a class="fa fa-repeat box-refresh" href="javascript:;"></a>
                                    <a class="t-collapse fa fa-chevron-down" href="javascript:;"></a>
                                    <a class="t-close fa fa-times" href="javascript:;"></a>
                                </span>
                            </header>
                            <div class="panel-body">
                                <div id="donut-chart"></div>
                            </div>
                        </section>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-12">
                        <section class="panel" >
                            <header class="panel-heading">
                                Line Chart
                                <span class="tools pull-right">
                                    <a class="fa fa-repeat box-refresh" href="javascript:;"></a>
                                    <a class="t-collapse fa fa-chevron-down" href="javascript:;"></a>
                                    <a class="t-close fa fa-times" href="javascript:;"></a>
                                </span>
                            </header>
                            <div class="panel-body">
                                <div id="line-chart"></div>
                            </div>
                        </section>
                    </div>

                </div>

            </div>
            <!--body wrapper end-->
    </div>
</div>
<!-- page head end-->

@endsection