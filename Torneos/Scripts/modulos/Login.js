$(document).ready(function () {
    $("#slider1").s3Slider({
        timeOut: 8000
    });

    $("#frmLogin input").keypress(function (event) {
        var code = (event.keyCode ? event.keyCode : event.which);
        if (code == 13) {
            if ($("#frmLogin").valid()) {
                Autenticar();
            }
            return false;
        }
    });

    $("#BtnIngresar").click(function (event) {
        if ($("#frmLogin").valid()) {
            Autenticar();
        }
        return false;
    });

    $("#LnkRecuperar").click(function (event) {
    $("#frmRecuperar").validate().resetForm();
        $("#ventanaRecuparar").dialog("open");
        return false;
    });

    $("#TxtCodigo").focus();

    $("#frmLogin").validate();
    $("#frmRecuperar").validate();
    $("#frmIngresarContrasena").validate();

    $("#ventanaContrasena").dialog({
        autoOpen: false,
        zIndex: 100,
        resizable: false,
        modal: false,
        title: "Ingresar Contraseña",
        //closeOnEscape: true,
        height: 220,
        width: 450,
        buttons: {
            "Aceptar": function () {
                if ($("#frmIngresarContrasena").valid()) {
                    GuardarContrasena();
                }
            },
            "Cancelar": function () { $(this).dialog("close"); }
        }
    });

    $("#ventanaRecuparar").dialog({
        autoOpen: false,
        zIndex: 100,
        resizable: false,
        modal: false,
        title: "Recuperar Contraseña",
        //closeOnEscape: true,
        height: 150,
        width: 450,
        buttons: {
            "Aceptar": function () {
                if ($("#frmRecuperar").valid()) {
                    alert("Esta función todavia está con contrucción")
                }
            },
            "Cancelar": function () { $(this).dialog("close"); }
        }
    });

});



function ObtenerValorQueryString(nombre) {
    name = nombre.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + nombre + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results == null) {
        return "";
    }
    else {
        return results[1];
    }
}

function GuardarContrasena() { 
        
    var cClave = $('#TxtIngresarContrasena').val();

    var oParametrosAjax = { cContrasena: cClave};

    var funcionProcesamientoCliente = function (oRespuesta) {
        window.location = "/Home";
    }

    BloquearPaginaCompleta(false);

    RealizarPeticionAjax("Autenticar", "/Home/CambiarContrasena", oParametrosAjax, true, true, null, funcionProcesamientoCliente);
}

function Autenticar() {
    var cUsuario = $('#TxtCodigo').val();
    var cClave = $('#TxtContrasena').val();

    var oParametrosAjax = { cCodigoUsuario: cUsuario, cContrasena: cClave};

    var funcionProcesamientoCliente = function (oRespuesta) {
        var cURL = ObtenerValorQueryString("ReturnUrl");

        if (cURL == "") {
            cURL = "/Home/";
        }
        else {
            cURL = replaceAll(cURL, "%2f", "/");
            cURL = replaceAll(cURL, "%3f", "?");
            cURL = replaceAll(cURL, "%3d", "=");
        }

        switch (oRespuesta.estadoAutenticacion) {
            case "autenticado":
                $("#mensajeAutenticacio").html("");
                window.location = cURL;
                break;
            case "Inactivo":
                $("#frmIngresarContrasena").validate().resetForm();
                $("#ventanaContrasena").dialog("open");
                break;
            case "falloAutenticacion":
                DesbloquearPaginaCompleta();
                /*alert(oRespuesta.mensaje);*/
                $("#mensajeAutenticacio").html(oRespuesta.mensaje);
                break;
            case "fallo":
                DesbloquearPaginaCompleta();
                alert(oRespuesta.mensaje);
                break;
        }
    }
    BloquearPaginaCompleta(false);

    var funcionTerminadoCorrectamente = function () {
        DesbloquearPaginaCompleta();
    }

    RealizarPeticionAjax("Autenticar", "/Home/Autenticar", oParametrosAjax, true, true, null, funcionProcesamientoCliente, funcionTerminadoCorrectamente);
}