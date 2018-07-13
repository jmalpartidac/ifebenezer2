<!DOCTYPE html>
<html lang="en">
<!-- head content start-->
@include('includes.head')
@yield('cabecera')
<!-- head content end-->
<body class="sticky-header sidebar-collapsed">
    <section>
       @include('includes.menu_principal')
        <!-- body content start-->
        <div class="body-content" >
            @include('includes.menu_cabecera')
            <!--body wrapper start-->
            @yield('contenido')
            <!--body wrapper end-->
            
            <!--footer section start-->
            @include('includes.pie_de_pagina')
            <!--footer section start-->
            <!-- Right Slidebar start -->
            @include('includes.menu_opciones')
            <!-- Right Slidebar end -->
        </div>
        <!-- body content end-->
    </section>
<!-- script content start-->
@include('includes.script')
<!-- script content end-->
</body>
</html>
