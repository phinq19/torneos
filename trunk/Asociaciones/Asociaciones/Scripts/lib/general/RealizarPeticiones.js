var _Ajax = [];
var _PeticionPendiente = null;

function RealizarPeticionAjax(
    cID,
    cURLPeticion,
    oParametrosAjax,
    bCritico,
    bAsync,
    cIDDiv,
    funcionProcesamientoCliente,
    funcionTerminadoCorrectamente,
    funcionErrorProcesamientoCliente,
    funcionErrorProcesamientoServidor) {

    if (cIDDiv != "" && cIDDiv != null) {
        BloquearDIV(cIDDiv);
    }
    if (bCritico == true) {
        if (_Ajax.length != 0) {
            for (keys in _Ajax) {
                _Ajax[keys].abort();
            }
            _Ajax = [];
        }
    }

    if (typeof (_Ajax[cID]) != "undefined") {
        _Ajax[cID].abort();
    }

    var jsonString = $.toJSON(oParametrosAjax);

    _Ajax[cID] = $.ajax({
        type: "POST",
        dataType: "json",
        contentType: "application/json",
        url: cURLPeticion,
        data: jsonString,
        async: bAsync,
        timeout: 60000,
        success: function (oRespuesta) {
            try {
                switch (oRespuesta.estado) {
                    case "exito":
                        if (oRespuesta.estadoValidacion == "sinAutenticar") {
                            SessionInactiva();
                        } else {
                            funcionProcesamientoCliente(oRespuesta);
                        }
                        break;
                    case "error":
                        ManejarErrorProcesamientoRespuesta(oRespuesta.mensaje, funcionErrorProcesamientoCliente);
                        break;
                    case "sesioninactiva":
                        //alert('Error en sesión');
                        SessionInactiva();
                        break;
                    default:
                        //MostrarDialogoError('Error desconocido: ' + oRespuesta);
                        break;
                }
            }
            catch (err) {
                ManejarErrorProcesamientoRespuesta(err, funcionErrorProcesamientoCliente);
            }
        },
        error: function (data, status, xhr) {

            ManejarErrorServidor(data, status, xhr);
        },
        complete: function (jqXHR, textStatus) {
            _Ajax[cID] = undefined;
            if (typeof (funcionTerminadoCorrectamente) != "undefined") {
                if (funcionTerminadoCorrectamente != null) {
                    funcionTerminadoCorrectamente(jqXHR, textStatus);
                }
            }
            if (cIDDiv != "" && cIDDiv != null) {
                DesbloquearDIV(cIDDiv);
            }
        }
    });


    function SessionInactiva() {
        /*_PeticionPendiente = function () {
            RealizarPeticionAjax(
                                    cID,
                                    cURLPeticion,
                                    oParametrosAjax,
                                    bCritico,
                                    bAsync,
                                    cIDDiv,
                                    funcionProcesamientoCliente,
                                    funcionTerminadoCorrectamente,
                                    funcionErrorProcesamientoCliente,
                                    funcionErrorProcesamientoServidor);
        }
        */
        window.location = "/";
    }
}



function ManejarErrorProcesamientoRespuesta(mensaje, funcionErrorProcesamientoCliente) {
    alert(mensaje);
    if (typeof (funcionErrorProcesamientoCliente) != "undefined") {
        if (funcionErrorProcesamientoCliente != null) {
            funcionErrorProcesamientoCliente(mensaje);
        }
    }
}

function MenejoErrorProcesamientoServidor(mensaje, funcionErrorProcesamientoServidor) {
    alert(mensaje);
    if (typeof (funcionErrorProcesamientoServidor) != "undefined") {
        if (funcionErrorProcesamientoServidor != null) {
            funcionErrorProcesamientoServidor(mensaje);
        }
    }
}

function ManejarErrorServidor(data, status, xhr) {
    switch (status) {
        case "timeout":
            //MostrarDialogoError(Mensajes.formMantenimiento.general.error.timeout);
            //window.location = "/";
            alert("El servidor a tardado en resolver. Vuelva a intentarlo");
            break;
        case "error":
            break;
        case "notmodified":
            break;
        case "parsererror":
            location.reload(true);
            break;
        default:
            //MostrarDialogoError('Error desconocido en servidor');
            alert('Error desconocido en servidor');
            break;
    }
}