    
        <!-- sidebar left start-->
        <div class="sidebar-left">
            <!--responsive view logo start-->
            <div class="logo dark-logo-bg visible-xs-* visible-sm-*">
                <a href="{{ url('/') }}/home">
                    <img src="{{ asset('img/logo_ebe.png') }}" alt="" style="width: 50px">
                    <!--<i class="fa fa-maxcdn"></i>-->
                    <span class="brand-name">IFEbenezer</span>
                </a>
            </div>
            <!--responsive view logo end-->

            <div class="sidebar-left-info">
                <!-- visible small devices start-->
                <div class=" search-field">  </div>
                <!-- visible small devices end-->

                <!--sidebar nav start-->
                <ul class="nav nav-pills nav-stacked side-navigation">
                    <li>
                        <h3 class="navigation-title">Navegación</h3>
                    </li>
                    <li class="active"><a href="{{ url('/') }}/tablero"><i class="fa fa-tachometer"></i> <span> Escritorio</span></a></li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-wrench"></i><span> Mantenimiento</span></a>
                        <ul class="child-list">
                            <li><a href="{{ url('/') }}/general"> General</a></li>
                            <li><a href="{{ url('/') }}/sucursal"> Sucursal</a></li>
                            <li><a href="{{ url('/') }}/empleados"> Usuarios</a></li>
                            <li><a href="{{ url('/') }}/permisos"> Permisos</a></li>
                            <li><a href="{{ url('/') }}/tipodocumento"> Tipo Documento</a></li>
                        </ul>
                    </li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-building"></i><span> Almacén</span></a>
                        <ul class="child-list">
                            <li><a href="{{ url('/') }}/articulos"> Articulos</a></li>
                            <li><a href="{{ url('/') }}/categorias"> Categorias</a></li>
                            <li><a href="{{ url('/') }}/subcategorias"> Sub. Categorias</a></li>
                            <li><a href="{{ url('/') }}/unidadesdemedida"> Unidades de Medida</a></li>
                        </ul>
                    </li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-shopping-cart"></i><span> Compras</span></a>
                        <ul class="child-list">
                            <li><a href="{{ url('/') }}/ingresoalma"> Ingresos</a></li>
                            <li><a href="{{ url('/') }}/proveedores"> Proveedores</a></li>
                        </ul>
                    </li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-money"></i><span> Ventas</span></a>
                        <ul class="child-list">
                            <li><a href="{{ url('/') }}/ventas"> Ventas</a></li>
                            <li><a href="{{ url('/') }}/pedidos"> Pedidos</a></li>
                            <li><a href="{{ url('/') }}/clientes"> Clientes</a></li>
                            <li><a href="{{ url('/') }}/creditos"> Creditos</a></li>
                            <li><a href="{{ url('/') }}/deudaspendientes"> Deudas Pendientes</a></li>
                            <li><a href="{{ url('/') }}/confcomprobantes"> Config Comprobantes</a></li>
                        </ul>
                    </li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-tasks"></i><span> Consultar Compras</span></a>
                        <ul class="child-list">
                            <li><a href="general.html"> Conculta de Compras Generales</a></li>
                            <li><a href="buttons.html"> Consulta de Compras Detalladas</a></li>
                            <li><a href="buttons.html"> Conculta de Compras Generales por Proveedor</a></li>
                            <li><a href="buttons.html"> Kardex Valorizado</a></li>
                            <li><a href="buttons.html"> Consulta de Stock de Articulos</a></li>
                        </ul>
                    </li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-bar-chart-o"></i><span> Consultar Ventas</span></a>
                        <ul class="child-list">
                            <li><a href="general.html"> Conculta de Ventas Generales</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Detalladas</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Pendientes</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Al Contado</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Al Credito</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Por Cliente</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Por Empleado</a></li>
                            <li><a href="buttons.html"> Consulta de Ventas Por Empleado detallado</a></li>
                        </ul>
                    </li>
                    <li class="menu-list">
                        <a href=""><i class="fa fa-plus-square"></i><span> Ayuda</span></a>
                        <ul class="child-list">
                            <li><a href="{{ url('/') }}/catalogo"> Catalogo</a></li>
                        </ul>
                    </li>
                    
                </ul>
                <!--sidebar nav end-->
            </div>
        </div>
    <!-- sidebar left end-->