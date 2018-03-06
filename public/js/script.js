
$('.fotoemple').click(function(){

    var tipo = $(this).data('tipo');
    var contenido = $(this).data('contenido');
    var nombre = $(this).data('nombre');
    var src = 'data:image/' + tipo + ';base64,' + contenido;

    $('#fotoempleado').attr('src',src);
    $("#nombrefoto").html('<h4 class="modal-title">'+nombre+'</h4>');
});

$('.fotoarticulo').click(function(){

    var tipo = $(this).data('tipo');
    var contenido = $(this).data('contenido');
    var nombre = $(this).data('nombre');
    var src = 'data:image/' + tipo + ';base64,' + contenido;

    $('#fotoarticulo').attr('src',src);
    $("#nombrearticulo").html('<h4 class="modal-title">'+nombre+'</h4>');
});
        
