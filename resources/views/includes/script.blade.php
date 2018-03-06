

<!--jquery-ui-->
<script src="{{ asset('js/jquery-ui/jquery-ui-1.10.1.custom.min.js') }}" type="text/javascript"></script>

<script src="{{ asset('js/jquery-migrate.js') }}"></script>
<script src="{{ asset('js/bootstrap.min.js') }}"></script>
<script src="{{ asset('js/modernizr.min.js') }}"></script>

<!--Nice Scroll-->
<script src="{{ asset('js/jquery.nicescroll.js') }}" type="text/javascript"></script>

<!--right slidebar-->
<script src="{{ asset('js/slidebars.min.js') }}"></script>

<!--switchery-->
<script src="{{ asset('js/switchery/switchery.min.js') }}"></script>


<!--flot chart -->
<script src="{{ asset('js/flot-chart/jquery.flot.js') }}"></script>
<script src="{{ asset('js/flot-chart/flot-spline.js') }}"></script>
<script src="{{ asset('js/flot-chart/jquery.flot.resize.js') }}"></script>
<script src="{{ asset('js/flot-chart/jquery.flot.tooltip.min.js') }}"></script>
<script src="{{ asset('js/flot-chart/jquery.flot.pie.js') }}"></script>
<script src="{{ asset('js/flot-chart/jquery.flot.selection.js') }}"></script>
<script src="{{ asset('js/flot-chart/jquery.flot.stack.js') }}"></script>
<script src="{{ asset('js/flot-chart/jquery.flot.crosshair.js') }}"></script>


<!--earning chart init-->
<script src="{{ asset('js/earning-chart-init.js') }}"></script>


<!--Sparkline Chart-->
<script src="{{ asset('js/sparkline/jquery.sparkline.js') }}"></script>
<script src="{{ asset('js/sparkline/sparkline-init.js') }}"></script>

<!--easy pie chart-->
<script src="{{ asset('js/jquery-easy-pie-chart/jquery.easy-pie-chart.js') }}"></script>
<script src="{{ asset('js/easy-pie-chart.js') }}"></script>


<!--vectormap-->
<script src="{{ asset('js/vector-map/jquery-jvectormap-1.2.2.min.js') }}"></script>
<script src="{{ asset('js/vector-map/jquery-jvectormap-world-mill-en.js') }}"></script>
<script src="{{ asset('js/dashboard-vmap-init.js') }}"></script>

<!--Icheck-->
<script src="{{ asset('js/icheck/skins/icheck.min.js') }}"></script>
<script src="{{ asset('js/todo-init.js') }}"></script>

<!--jquery countTo-->
<script src="{{ asset('js/jquery-countTo/jquery.countTo.js') }}"  type="text/javascript"></script>

<!--owl carousel-->
<script src="{{ asset('js/owl.carousel.js') }}"></script>

<!--bootstrap-fileinput-master-->
<script type="text/javascript" src="{{ asset('js/bootstrap-fileinput-master/js/fileinput.js') }}"></script>
<script type="text/javascript" src="{{ asset('js/file-input-init.js') }}"></script>

<!--bootstrap picker-->
<script type="text/javascript" src="{{ asset('js/bootstrap-datepicker/js/bootstrap-datepicker.js') }}"></script>
<script type="text/javascript" src="{{ asset('js/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js') }}"></script>
<script type="text/javascript" src="{{ asset('js/bootstrap-daterangepicker/moment.min.js') }}"></script>
<script type="text/javascript" src="{{ asset('js/bootstrap-daterangepicker/daterangepicker.js') }}"></script>
<script type="text/javascript" src="{{ asset('js/bootstrap-colorpicker/js/bootstrap-colorpicker.js') }}"></script>
<script type="text/javascript" src="{{ asset('js/bootstrap-timepicker/js/bootstrap-timepicker.js') }}"></script>

<!--picker initialization-->
<script src="{{ asset('js/picker-init.js') }}"></script>


<!--common scripts for all pages-->

<script src="{{ asset('js/scripts.js') }}"></script>
<script src="{{ asset('js/script.js') }}"></script>

<!--Data Table-->
<script src="{{ asset('js/data-table/js/jquery.dataTables.min.js') }}"></script>
<script src="{{ asset('js/data-table/js/dataTables.tableTools.min.js') }}"></script>
<script src="{{ asset('js/data-table/js/bootstrap-dataTable.js') }}"></script>
<script src="{{ asset('js/data-table/js/dataTables.colVis.min.js') }}"></script>
<script src="{{ asset('js/data-table/js/dataTables.responsive.min.js') }}"></script>
<script src="{{ asset('js/data-table/js/dataTables.scroller.min.js') }}"></script>
<!--data table init-->
<script src="{{ asset('js/data-table-init.js') }}"></script>

<!--toastr-->
<script src="{{ asset('js/toastr-master/toastr.js') }}"></script>
<script src="{{ asset('js/toastr-init.js') }}"></script>

<!--select2-->
<script src="{{ asset('js/select2.js') }}"></script>
<!--select2 init-->
<script src="{{ asset('js/select2-init.js') }}"></script>

<!--Morris Chart-->
<script src="js/morris-chart/morris.js"></script>
<script src="js/morris-chart/raphael-min.js"></script>

<!--morris chart initialization-->
<script src="js/morris-init.js"></script>

<!--toastr  para mostrar mensajes de confirmacion-->

<script type="text/javascript">
    @if (Session::has('flg_msj'))
        @if (Session::get('flg_tipo') == "1")
            toastr.success('{{Session::get("flg_msj")}}', 'Mensaje!')
        @endif
        @if (Session::get('flg_tipo') == "2")
            toastr.warning('{{Session::get("flg_msj")}}', 'Confirmacion!')
        @endif
        @if (Session::get('flg_tipo') == "3")
            toastr.error('{{Session::get("flg_msj")}}', 'Aviso!')
        @endif

        {{Session::forget("flg_msj")}}
        {{Session::forget("flg_tipo")}}
    @endif
</script>