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
            <div class="celdaCampo">
                <input id="ChkLunes" name="ChkLunes" type="checkbox"/>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Martes
            </div>
            <div class="celdaCampo">
                <input id="ChkMartes" name="ChkMartes" type="checkbox"/>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Miércoles
            </div>
            <div class="celdaCampo">
                <input id="ChkMiercoles" name="ChkMiercoles" type="checkbox"/>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Jueves
            </div>
            <div class="celdaCampo">
                <input id="ChkJueves" name="ChkJueves" type="checkbox"/>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Viernes
            </div>
            <div class="celdaCampo">
                <input id="ChkViernes" name="ChkViernes" type="checkbox"/>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Sábado
            </div>
            <div class="celdaCampo">
                <input id="ChkSabado" name="ChkSabado" type="checkbox"/>
            </div>
        </div>
        <div class="fila">
            <div class="celdaLabel">
                Domingo
            </div>
            <div class="celdaCampo">
                <input id="ChkDomingo" name="ChkDomingo" type="checkbox"/>
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
