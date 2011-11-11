<%@ Page Title="ACAF Disponibilidad" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
<script type='text/javascript'>
    $(document).ready(function () {
        HabilitarDisponibilidad(false);

        var oParametrosAjax = {};

        var funcionProcesamientoCliente = function (oRespuesta) {
            MostarDisponibilidad(oRespuesta.oDisponibilidad);
        }

        RealizarPeticionAjax("ObtenerDisponibilidad", "/Disponibilidad/ObtenerDisponibilidad", oParametrosAjax, true, true, "contenidoDisponibilidad", funcionProcesamientoCliente);

        $("#BtnGuardar").click(function () {
            HabilitarDisponibilidad(false);
            GuardarDiponibilidad();
        });

        $("#BtnEditar").click(function () {
            HabilitarDisponibilidad(true);
        });

        $("#BtnCancelar").click(function () {
            HabilitarDisponibilidad(false);
            MostarDisponibilidad(_Disponibilidad);
        });
    });


    _Disponibilidad = {};

    function GuardarDiponibilidad() {
        
        var tiempoLunesM = $("#ChkLunesM").attr('checked') == true ? 1 : 0;
        var tiempoMartesM = $("#ChkMartesM").attr('checked') == true ? 1 : 0;
        var tiempoMiercolesM = $("#ChkMiercolesM").attr('checked') == true ? 1 : 0;
        var tiempoJuevesM = $("#ChkJuevesM").attr('checked') == true ? 1 : 0;
        var tiempoViernesM = $("#ChkViernesM").attr('checked') == true ? 1 : 0;
        var tiempoSabadoM = $("#ChkSabadoM").attr('checked') == true ? 1 : 0;
        var tiempoDomingoM = $("#ChkDomingoM").attr('checked') == true ? 1 : 0;

        var tiempoLunesT = $("#ChkLunesT").attr('checked') == true ? 1 : 0;
        var tiempoMartesT = $("#ChkMartesT").attr('checked') == true ? 1 : 0;
        var tiempoMiercolesT = $("#ChkMiercolesT").attr('checked') == true ? 1 : 0;
        var tiempoJuevesT = $("#ChkJuevesT").attr('checked') == true ? 1 : 0;
        var tiempoViernesT = $("#ChkViernesT").attr('checked') == true ? 1 : 0;
        var tiempoSabadoT = $("#ChkSabadoT").attr('checked') == true ? 1 : 0;
        var tiempoDomingoT = $("#ChkDomingoT").attr('checked') == true ? 1 : 0;

        var tiempoLunesN = $("#ChkLunesN").attr('checked') == true ? 1 : 0;
        var tiempoMartesN = $("#ChkMartesN").attr('checked') == true ? 1 : 0;
        var tiempoMiercolesN = $("#ChkMiercolesN").attr('checked') == true ? 1 : 0;
        var tiempoJuevesN = $("#ChkJuevesN").attr('checked') == true ? 1 : 0;
        var tiempoViernesN = $("#ChkViernesN").attr('checked') == true ? 1 : 0;
        var tiempoSabadoN = $("#ChkSabadoN").attr('checked') == true ? 1 : 0;
        var tiempoDomingoN = $("#ChkDomingoN").attr('checked') == true ? 1 : 0;

        var oParametrosAjax = {
            id: _Disponibilidad.id,
            idArbitro: _Disponibilidad.idArbitro,
            lunes: $("#ChkLunes").attr('checked') == true ? 1 : -1,
            martes: $("#ChkMartes").attr('checked') == true ? 2 : -1,
            miercoles: $("#ChkMiercoles").attr('checked') == true ? 3 : -1,
            jueves: $("#ChkJueves").attr('checked') == true ? 4 : -1,
            viernes: $("#ChkViernes").attr('checked') == true ? 5 : -1,
            sabado: $("#ChkSabado").attr('checked') == true ? 6 : -1,
            domingo: $("#ChkDomingo").attr('checked')== true ? 7 : -1,
            tiempoLunes: tiempoLunesM + "" + tiempoLunesT + "" + tiempoLunesN,
            tiempoMartes: tiempoMartesM + "" + tiempoMartesT + "" + tiempoMartesN,
            tiempoMiercoles: tiempoMiercolesM + "" + tiempoMiercolesT + "" + tiempoMiercolesN,
            tiempoJueves: tiempoJuevesM + "" + tiempoJuevesT + "" + tiempoJuevesN,
            tiempoViernes: tiempoJuevesM + "" + tiempoJuevesT + "" + tiempoJuevesN,
            tiempoSabado: tiempoSabadoM + "" + tiempoSabadoT + "" + tiempoSabadoN,
            tiempoDomingo: tiempoDomingoM + "" + tiempoDomingoT + "" + tiempoDomingoN
        };

        var funcionProcesamientoCliente = function (oRespuesta) {
            MostarDisponibilidad(oRespuesta.ObjetoDetalle);
        }

        RealizarPeticionAjax("GuardarDisponibilidad", "/Disponibilidad/EditarDisponibilidad", oParametrosAjax, true, true, "contenidoDisponibilidad", funcionProcesamientoCliente);
    }

    function MostarDisponibilidad(oDisponibilidad) {
        _Disponibilidad = oDisponibilidad;
        $("#ChkLunes").attr('checked', oDisponibilidad.lunes);
        $("#ChkMartes").attr('checked', oDisponibilidad.martes);
        $("#ChkMiercoles").attr('checked', oDisponibilidad.miercoles);
        $("#ChkJueves").attr('checked', oDisponibilidad.jueves);
        $("#ChkViernes").attr('checked', oDisponibilidad.viernes);
        $("#ChkSabado").attr('checked', oDisponibilidad.sabado);
        $("#ChkDomingo").attr('checked', oDisponibilidad.domingo);

        $("#ChkLunesM").attr('checked', (oDisponibilidad.tiempoLunes[0] != "0"));
        $("#ChkMartesM").attr('checked', (oDisponibilidad.tiempoMartes[0] != "0"));
        $("#ChkMiercolesM").attr('checked', (oDisponibilidad.tiempoMiercoles[0] != "0"));
        $("#ChkJuevesM").attr('checked', (oDisponibilidad.tiempoJueves[0] != "0"));
        $("#ChkViernesM").attr('checked', (oDisponibilidad.tiempoViernes[0] != "0"));
        $("#ChkSabadoM").attr('checked', (oDisponibilidad.tiempoSabado[0] != "0"));
        $("#ChkDomingoM").attr('checked', (oDisponibilidad.tiempoDomingo[0] != "0"));

        $("#ChkLunesT").attr('checked', (oDisponibilidad.tiempoLunes[1] != "0"));
        $("#ChkMartesT").attr('checked', (oDisponibilidad.tiempoMartes[1] != "0"));
        $("#ChkMiercolesT").attr('checked', (oDisponibilidad.tiempoMiercoles[1] != "0"));
        $("#ChkJuevesT").attr('checked', (oDisponibilidad.tiempoJueves[1] != "0"));
        $("#ChkViernesT").attr('checked', (oDisponibilidad.tiempoViernes[1] != "0"));
        $("#ChkSabadoT").attr('checked', (oDisponibilidad.tiempoSabado[1] != "0"));
        $("#ChkDomingoT").attr('checked', (oDisponibilidad.tiempoDomingo[1] != "0"));

        $("#ChkLunesN").attr('checked', (oDisponibilidad.tiempoLunes[2] != "0"));
        $("#ChkMartesN").attr('checked', (oDisponibilidad.tiempoMartes[2] != "0"));
        $("#ChkMiercolesN").attr('checked', (oDisponibilidad.tiempoMiercoles[2] != "0"));
        $("#ChkJuevesN").attr('checked', (oDisponibilidad.tiempoJueves[2] != "0"));
        $("#ChkViernesN").attr('checked', (oDisponibilidad.tiempoViernes[2] != "0"));
        $("#ChkSabadoN").attr('checked', (oDisponibilidad.tiempoSabado[2] != "0"));
        $("#ChkDomingoN").attr('checked', (oDisponibilidad.tiempoDomingo[2] != "0"));
    }

    function HabilitarDisponibilidad(bHabilitar) {
        if (bHabilitar) {
            $("#ChkLunes").removeAttr("disabled");
            $("#ChkMartes").removeAttr("disabled");
            $("#ChkMiercoles").removeAttr("disabled");
            $("#ChkJueves").removeAttr("disabled");
            $("#ChkViernes").removeAttr("disabled");
            $("#ChkSabado").removeAttr("disabled");
            $("#ChkDomingo").removeAttr("disabled");

            $("#ChkLunesM").removeAttr("disabled");
            $("#ChkMartesM").removeAttr("disabled");
            $("#ChkMiercolesM").removeAttr("disabled");
            $("#ChkJuevesM").removeAttr("disabled");
            $("#ChkViernesM").removeAttr("disabled");
            $("#ChkSabadoM").removeAttr("disabled");
            $("#ChkDomingoM").removeAttr("disabled");

            $("#ChkLunesT").removeAttr("disabled");
            $("#ChkMartesT").removeAttr("disabled");
            $("#ChkMiercolesT").removeAttr("disabled");
            $("#ChkJuevesT").removeAttr("disabled");
            $("#ChkViernesT").removeAttr("disabled");
            $("#ChkSabadoT").removeAttr("disabled");
            $("#ChkDomingoT").removeAttr("disabled");

            $("#ChkLunesN").removeAttr("disabled");
            $("#ChkMartesN").removeAttr("disabled");
            $("#ChkMiercolesN").removeAttr("disabled");
            $("#ChkJuevesN").removeAttr("disabled");
            $("#ChkViernesN").removeAttr("disabled");
            $("#ChkSabadoN").removeAttr("disabled");
            $("#ChkDomingoN").removeAttr("disabled");

            $("#BtnGuardar").show();
            $("#BtnCancelar").show();
            $("#BtnEditar").hide();
        }
        else{
            $("#ChkLunes").attr("disabled", "disabled");
            $("#ChkMartes").attr("disabled", "disabled");
            $("#ChkMiercoles").attr("disabled", "disabled");
            $("#ChkJueves").attr("disabled", "disabled");
            $("#ChkViernes").attr("disabled", "disabled");
            $("#ChkSabado").attr("disabled", "disabled");
            $("#ChkDomingo").attr("disabled", "disabled");

            $("#ChkLunesM").attr("disabled", "disabled");
            $("#ChkMartesM").attr("disabled", "disabled");
            $("#ChkMiercolesM").attr("disabled", "disabled");
            $("#ChkJuevesM").attr("disabled", "disabled");
            $("#ChkViernesM").attr("disabled", "disabled");
            $("#ChkSabadoM").attr("disabled", "disabled");
            $("#ChkDomingoM").attr("disabled", "disabled");

            $("#ChkLunesT").attr("disabled", "disabled");
            $("#ChkMartesT").attr("disabled", "disabled");
            $("#ChkMiercolesT").attr("disabled", "disabled");
            $("#ChkJuevesT").attr("disabled", "disabled");
            $("#ChkViernesT").attr("disabled", "disabled");
            $("#ChkSabadoT").attr("disabled", "disabled");
            $("#ChkDomingoT").attr("disabled", "disabled");

            $("#ChkLunesN").attr("disabled", "disabled");
            $("#ChkMartesN").attr("disabled", "disabled");
            $("#ChkMiercolesN").attr("disabled", "disabled");
            $("#ChkJuevesN").attr("disabled", "disabled");
            $("#ChkViernesN").attr("disabled", "disabled");
            $("#ChkSabadoN").attr("disabled", "disabled");
            $("#ChkDomingoN").attr("disabled", "disabled");

            $("#BtnGuardar").hide();
            $("#BtnCancelar").hide();
            $("#BtnEditar").show();
        }
    }

</script>

<div id="contenidoDisponibilidad">
<fieldset class="Fieldset">
    <legend>Disponibilidad por día</legend>
    <div class="ContenidoOrdenado">
        <div class="fila">
            <div class="celdaLabel">
                Lunes
            </div>
            <div class="columna">
                <input id="ChkLunes" name="ChkLunes" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkLunesM" name="ChkLunesM" type="checkbox"/>
                    Tarde<input id="ChkLunesT" name="ChkLunesT" type="checkbox"/>
                    Noche<input id="ChkLunesN" name="ChkLunesN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Martes
            </div>
            <div class="columna">
                <input id="ChkMartes" name="ChkMartes" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkMartesM" name="ChkMartesM" type="checkbox"/>
                    Tarde<input id="ChkMartesT" name="ChkMartesT" type="checkbox"/>
                    Noche<input id="ChkMartesN" name="ChkMartesN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Miércoles
            </div>
            <div class="columna">
                <input id="ChkMiercoles" name="ChkMiercoles" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkMiercolesM" name="ChkMiercolesM" type="checkbox"/>
                    Tarde<input id="ChkMiercolesT" name="ChkMiercolesT" type="checkbox"/>
                    Noche<input id="ChkMiercolesN" name="ChkMiercolesN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Jueves
            </div>
            <div class="columna">
                <input id="ChkJueves" name="ChkJueves" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkJuevesM" name="ChkJuevesM" type="checkbox"/>
                    Tarde<input id="ChkJuevesT" name="ChkJuevesT" type="checkbox"/>
                    Noche<input id="ChkJuevesN" name="ChkJuevesN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Viernes
            </div>
            <div class="columna">
                <input id="ChkViernes" name="ChkViernes" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkViernesM" name="ChkViernesM" type="checkbox"/>
                    Tarde<input id="ChkViernesT" name="ChkViernesT" type="checkbox"/>
                    Noche<input id="ChkViernesN" name="ChkViernesN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Sábado
            </div>
            <div class="columna">
                <input id="ChkSabado" name="ChkSabado" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkSabadoM" name="ChkSabadoM" type="checkbox"/>
                    Tarde<input id="ChkSabadoT" name="ChkSabadoT" type="checkbox"/>
                    Noche<input id="ChkSabadoN" name="ChkSabadoN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Domingo
            </div>
            <div class="columna">
                <input id="ChkDomingo" name="ChkDomingo" type="checkbox"/>
            </div>
            <div class="celdaCampo">
                <fieldset class="Fieldset">
                    Mañana<input id="ChkDomingoM" name="ChkDomingoM" type="checkbox"/>
                    Tarde<input id="ChkDomingoT" name="ChkDomingoT" type="checkbox"/>
                    Noche<input id="ChkDomingoN" name="ChkDomingoN" type="checkbox"/>
                </fieldset>
            </div>
        </div>
    </div>
    <div class="ContenidoOrdenado">
        <div class="fila">
            <div class="celdaLabel">
                <input id="BtnEditar" value="Editar" type="button" />
            </div>
            <div class="celdaLabel">
                <input id="BtnGuardar" value="Guardar" type="button" />
            </div>
            <div class="celdaLabel">
                <input id="BtnCancelar" value="Cancelar" type="button" />
            </div>
        </div>
    </div>
    </fieldset>
</div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Disponibilidad</h1>
<h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
