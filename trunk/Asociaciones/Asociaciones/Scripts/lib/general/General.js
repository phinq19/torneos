var cSeparadorMiles = '.';
var cSeparadorDecimal = ',';
var cSimboloMoneda = '₡ ';
var cFormatoFecha = 'dd/mm/yy';
var cFormatoHora = 'hh:MM:ss tt';


// Fecha
jQuery.extend($.fn.fmatter, {
    fechaFmatter: function (cellvalue, options, rowdata) {
        options.colModel.align = "right";
        //options.colModel.width = 500;
        options.colModel.sorttype = "date ";
        var dFecha = cellvalue;
        if (cellvalue.toLowerCase().indexOf("date") >= 0) {
            dFecha = Convertir_Json_A_Fecha(cellvalue);
        }
        /*var cFechaFormato = "";
        if (dFecha.getFullYear() > 1899) {
        cFechaFormato = dFecha.format(cFormatoFecha);
        }*/
        return dFecha;
    }
});

jQuery.extend($.fn.fmatter.fechaFmatter, {
    unformat: function (cellvalue, options) {
        return cellvalue; /*quitarSeparadores(cellvalue, cSeparadorMiles, cSeparadorDecimal, cSimboloMoneda);*/

    }
});

// Get/Set Input Fecha
function AsignarValorInputFechaJson(cID, cValor) {
    var dFecha = Convertir_Json_A_Fecha(cValor);

    /*var milli = cValor.toString().replace(/\/Date\((-?\d+)\)\//, '$1');
    var dFecha = new Date(parseInt(milli));

    var cFechaFormato = "";
    if (dFecha.getFullYear() > 1899) {
    cFechaFormato = dFecha.format(cFormatoFecha);
    }*/

    $('#' + cID).val(dFecha);
}

function AsignarValorInputFecha(cID, dFecha) {
    //var cFechaFormato = dFecha.format(cFormatoFecha);
    var cFechaFormato = $.datepicker.formatDate(cFormatoFecha, dFecha);
    $('#' + cID).val(cFechaFormato);
}


function ObtenerValorInputStringFecha(cID) {
    var cString = $('#' + cID).val();

    if (cString == "") {
        return new Date(1899, 1, 1);
    }

    return $.datepicker.parseDate(cFormatoFecha, cString);
}


// JSON a fecha
function Convertir_Json_A_Fecha(jsonFecha) {
    var fechahora = Convertir_Json_A_FechaHora(jsonFecha);

    var cFechaFormato = '';
    cFechaFormato = $.datepicker.formatDate(cFormatoFecha, fechahora);
    return cFechaFormato;
}

function Convertir_Json_A_Hora(jsonFecha) {
    var fechahora = Convertir_Json_A_FechaHora(jsonFecha);

    var cHoraFormato = '';
    cHoraFormato = fechahora.format(cFormatoHora);
    return cHoraFormato;
}

function Convertir_Json_A_FechaHora(jsonFecha) {
    var milli = jsonFecha.toString().replace(/\/Date\((-?\d+)\)\//, '$1');
    var dFecha = new Date(parseInt(milli));
    return dFecha;
}


function BloquearPaginaCompleta(bMostrarMensaje) {
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

function BloquearDIV(cID, bMostrarMensaje) {
    // Bloquear div
    var oParametros = {};
    if (typeof (bMostrarMensaje) == "undefined" || bMostrarMensaje == true) {
        oParametros = {
            message: "Cargando",
            theme: true
        };
    }
    else {
        oParametros = {
            message: null
        };
    }
    $("#" + cID).block(oParametros);
}

function DesbloquearDIV(cID) {
    $("#" + cID).unblock();
}

$(document).ready(function () {
    $("#LnkSalir").click(function (event) {
        CerrarSesion();
    });
});

function CerrarSesion() {
    BloquearPaginaCompleta(false);
    var funcionProcesamientoCliente = function (oRespuesta) {
        window.location = "/Home/";
    }

    var funcionPrecoseamientoCompleto = function () {
        DesbloquearPaginaCompleta();
    }
    RealizarPeticionAjax("CerrarSession", "/Home/CerrarSesion", {}, true, true, null, funcionProcesamientoCliente, funcionPrecoseamientoCompleto);
}

function replaceAll(txt, replace, with_this) {
    return txt.replace(new RegExp(replace, 'g'), with_this);
}