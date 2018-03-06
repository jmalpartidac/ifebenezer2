@extends('layout.home')
@section('contenido')

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Clasificación ABC
                </header>
                <div class="panel-body">


                     <!--tab nav start-->
                    <section class="panel">
                        <header class="panel-heading tab-dark ">
                            <ul class="nav nav-tabs">
                                <li class="active">
                                    <a data-toggle="tab" href="#home">Forma 1</a>
                                </li>
                                <li class="">
                                    <a data-toggle="tab" href="#about">Forma 2</a>
                                </li>
                                <li class="">
                                    <a data-toggle="tab" href="#profile">Forma 3</a>
                                </li>
                                <li class="">
                                    <a data-toggle="tab" href="#contact">Promedio</a>
                                </li>
                            </ul>
                        </header>
                        <div class="panel-body">
                            <div class="tab-content">
                                <div id="home" class="tab-pane active">
                                    Home
                                </div>
                                <div id="about" class="tab-pane">About</div>
                                <div id="profile" class="tab-pane">Profile</div>
                                <div id="contact" class="tab-pane">Contact</div>
                            </div>
                        </div>
                    </section>
                    <!--tab nav start-->



                </div>
            </section>
        </div>
    </div>
</div>

@endsection