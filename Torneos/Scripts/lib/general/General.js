﻿function BloquearPaginaCompleta(bMostrarMensaje) {
    var oParametros = {};
    if (typeof (bMostrarMensaje) == "undefined" || bMostrarMensaje == true) {
        oParametros = {
            message: "Cargando...",
            theme: true
        };
    }
    else {
        oParametros = {
            message: null
        };
    }

    $.blockUI(oParametros); 
}

function DesbloquearPaginaCompleta() {
    $.unblockUI();
}


$(document).ready(function () {
    $("#LnkSalir").click(function (event) {
        CerrarSesion();
    });
});

function CerrarSesion() {
    BloquearPaginaCompleta(false);
    var funcionProcesamientoCliente = function (oRespuesta) {
        window.location = "/Usuarios/";
    }

    var funcionPrecoseamientoCompleto = function () {
        DesbloquearPaginaCompleta();
    }
    RealizarPeticionAjax("CerrarSession", "/Usuarios/CerrarSesion", {}, true, true, null, funcionProcesamientoCliente, funcionPrecoseamientoCompleto);
}