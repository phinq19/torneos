$(document).ready(function () {
    $("#slider1").s3Slider({
        timeOut: 8000
    });

    $("#frmLogin input").keypress(function (event) {
        var code = (event.keyCode ? event.keyCode : event.which);
        if (code == 13) {
            Autenticar();
            return false;
        }
    });

    $("#BtnIngresar").click(function (event) {
        Autenticar();
        return false;
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