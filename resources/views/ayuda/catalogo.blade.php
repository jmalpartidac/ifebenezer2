@extends('layout.home')
@section('contenido')

<div class="wrapper">  
    <div class="row">
        <div class="col-lg-12">
            <section class="panel">
                <header class="panel-heading head-border">
                    Catalogo de Productos
                </header>
                <!--body wrapper start-->
                <div class="wrapper no-pad">
                    <div class="profile-desk">
                        <aside class="p-aside">
                            
                            <ul class="gallery">
                            <?php
                                foreach ($articulos as $art) {
                            ?>  
                                <li style="width: 23%; height: 23%">
                                    <a href="#" style="text-align: center; color: #072e4a;">
                                        <div class="form-group">
                                            <label>{{ $art->articulo }}</label>
                                            <img src="data:image/png;base64,{{ $art->enImg }}" alt=""/>
                                        </div>
                                    </a>
                                </li>

                            <?php
                                }
                            ?>
                            </ul>
                        </aside>
                        
                    </div>
                </div>
                <!--body wrapper end-->
            </section>
        </div>
    </div>
</div>

@endsection