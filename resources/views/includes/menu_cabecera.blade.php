
<!-- header section start-->
            <div class="header-section">

                <!--logo and logo icon start-->
                <div class="logo dark-logo-bg hidden-xs hidden-sm">
                    <a href="{{ url('/') }}/home">
                        <img src="{{ asset('img/logo_ebe.png') }}" alt="" style="width: 50px">
                        <!--<i class="fa fa-maxcdn"></i>-->
                        <span class="brand-name">IFEbenezer</span>
                    </a>
                </div>

                <div class="icon-logo dark-logo-bg hidden-xs hidden-sm">
                    <a href="{{ url('/') }}/home">
                        <img src="{{ asset('img/logo_ebe.png') }}" alt="" style="width: 30px">
                        <!--<i class="fa fa-maxcdn"></i>-->
                    </a>
                </div>
                <!--logo and logo icon end-->

                <!--toggle button start-->
                <a class="toggle-btn"><i class="fa fa-outdent"></i></a>
                <!--toggle button end-->
               
                <div class="notification-wrap">
                <!--left notification start-->
                <div class="left-notification">
                <ul class="notification-menu">
                <!--mail info start-->
                <li class="d-none">
                    <a href="javascript:;" class="btn btn-default dropdown-toggle info-number" data-toggle="dropdown">
                        
                        <i class="fa fa-envelope-o"></i>
                        <span class="badge bg-primary">6</span>
                    </a>

                </li>
                <!--mail info end-->

                <!--task info start-->
                <li class="d-none">
                    <a href="javascript:;" class="btn btn-default dropdown-toggle info-number" data-toggle="dropdown">
                        Ventas Por Confirmar 
                        <i class="fa fa-tasks"></i>
                        <span class="badge bg-success" 
                        <?php if (Session::get('contadorventasporconfirmar') <= 0): ?>
                            style="background-color: #dcdcdc; color: black;"
                        <?php endif ?>
                            style="background-color: #072f49;">{{ Session::get('contadorventasporconfirmar') }}</span>
                    </a>

                </li>
                <!--task info end-->

                <!--notification info start-->
                <li>
                    <a href="javascript:;" class="btn btn-default dropdown-toggle info-number" data-toggle="dropdown">
                        Pedidos Pendientes 
                        <i class="fa fa-bell-o"></i>
                        <span class="badge bg-warning" 
                        <?php if (Session::get('contadorpendientes') <= 0): ?>
                            style="background-color: #dcdcdc; color: black;"
                        <?php endif ?> 
                            style="background-color: #072f49;">{{ Session::get('contadorpendientes') }}</span>
                    </a>
                </li>
                <!--notification info end-->
                </ul>
                </div>
                <!--left notification end-->


                <!--right notification start-->
                <div class="right-notification">
                    <ul class="notification-menu">

                        <li>
                            <a href="javascript:;" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                <img src="{{ Session::get('imagen') }}" alt="">
                                {{ Auth::user()->nombres }}
                                <span class=" fa fa-angle-down"></span>
                            </a>
                            <ul class="dropdown-menu dropdown-usermenu purple pull-right">
                                <li><a href="{{ url('/') }}/logout"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
                            </ul>
                        </li>
                        <li>
                            <div class="sb-toggle-right">
                                <i class="fa fa-indent"></i>
                            </div>
                        </li>

                    </ul>
                </div>
                <!--right notification end-->
                </div>

            </div>
            <!-- header section end-->