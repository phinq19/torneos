<%@ Page Title="ACAF Tesorería" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">

    <fieldset class="Fieldset">
    <legend>Filtro</legend>
        <div class="ContenidoOrdenado">
            <div class="fila">
                <div class="columna">
                    Estado
                </div>
                <div class="celdaCampo">
                    <%= Torneos.Utilidades.CrearSelectorEstadosDetallePartidos("selEstadoDetallePartido")%>
                </div>
            </div>
        </div>
    </fieldset>
    <br />
    <table id="gridPartidos">
    </table>
    <div id="barraGridPartidos">
    </div>
    <script type='text/javascript'>
        $(document).ready(function () {
            $("#selEstadoDetallePartido").change(function () {
                var postData = jQuery("#gridPartidos").getGridParam("postData");
                postData.estado = $("#selEstadoDetallePartido").val();
                jQuery("#gridVPartidos").setGridParam("postData", postData);
                jQuery("#gridPartidos").trigger("reloadGrid");
            });

            $("#frmPartidos").validate();

            $("#ventanaEditar").dialog({
                autoOpen: false,
                zIndex: 500,
                resizable: false,
                modal: false,
                title: "Partidos",
                //closeOnEscape: true,
                height: 550,
                width: 800
            });

            $("#gridDeducciones").jqGrid({
                //url: '<%= Url.Action("ObtenerDetallePartidos","Torneos") %>',
                datatype: "local",
                loadonce: true,
                pager: '#barraGridDeducciones',
                editurl: '<%= Url.Action("ValidarDeducciones","Tesoreria") %>',
                height: 120,
                width: 756,
                colNames: ['id', 'Monto', 'Descripción', 'Observaciones', 'accionregistro'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'monto', index: 'monto', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'descripcion', index: 'descripcion', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} },
                    { name: 'accionregistro', index: 'accionregistro', width: 55, editable: true, hidden: true },
            ]
            });



            var ProcesarEditar_gridDeducciones = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "500",
                savekey: [true, 13],
                navkeys: [true, 38, 40],
                zIndex: 9999,
                afterShowForm: function (formId) {

                },
                onclickSubmit: function (params, registroCliente) {
                },
                afterSubmit: function (datosRespuesta, registroCliente, formid) {
                    var datos = JSON.parse(datosRespuesta.responseText);
                    switch (datos.estado) {
                        case "exito":
                            switch (datos.estadoValidacion) {
                                case "exito":
                                    //var registroCliente = datos.ObjetoDetalle;
                                    $.each(datos.ObjetoDetalle, function (att, value) {
                                        registroCliente[att] = value;
                                    });
                                    ActualizarEntidad(registroCliente);
                                    return [true, '', datos.ObjetoDetalle.id];
                                    break;
                                case "error":
                                    return [false, datos.mensaje, '-1']
                                    break;
                                case "falloLlave":
                                    return [false, datos.mensaje, '-1'];
                                    break;
                                case "sinAutenticar":
                                    window.location = "/";
                                    break;
                            }
                            break;
                        case "error":
                            return [false, datos.mensaje, '-1']
                            break;
                    }
                },
                afterComplete: function (response, postdata, formid) {
                    CalcularDeducciones();
                }
            }

            var Procesar_Eliminar_gridDeducciones = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "500",
                savekey: [true, 13],
                navkeys: [true, 38, 40],
                zIndex: 9999,
                afterShowForm: function (formId) {
                },
                onclickSubmit: function (params, registroCliente) {
                },
                afterSubmit: function (datosRespuesta, registroCliente, formid) {
                    var datos = JSON.parse(datosRespuesta.responseText);
                    switch (datos.estado) {
                        case "exito":
                            switch (datos.estadoValidacion) {
                                case "exito":
                                    $.each(datos.ObjetoDetalle, function (att, value) {
                                        registroCliente[att] = value;
                                    });
                                    ActualizarEntidad(registroCliente);
                                    return [true, '', datos.ObjetoDetalle.id];
                                    break;
                                case "error":
                                    return [false, datos.mensaje, '-1']
                                    break;
                                case "sinAutenticar":
                                    window.location = "/";
                                    break;
                            }
                            break;
                        case "error":
                            return [false, datos.mensaje, '-1']
                            break;
                    }
                },
                afterComplete: function (response, postdata, formid) {
                    CalcularDeducciones();
                }
            }


            $("#gridDeducciones").jqGrid('navGrid', '#barraGridDeducciones',
            {
                edit: true,
                add: true,
                del: true,
                refresh: false,
                search: false,
                view: true
            }, //options 
                 ProcesarEditar_gridDeducciones, // edit options 
                 ProcesarEditar_gridDeducciones, // add options 
                 Procesar_Eliminar_gridDeducciones, // del options
                 {}, // search options 
                 {width: "600" }
            );

            function CalcularDeducciones() {
                var monto = 0;
                var oRegistros = $("#gridDeducciones").jqGrid('getGridParam', 'data');
                for (var indice = 0; indice < oRegistros.length; indice++) {
                    monto += parseFloat(oRegistros[indice].monto);
                }
                $("#TxtMontoDeducciones").val(monto);
            }

            $("#gridPartidos").jqGrid({
                url: '<%= Url.Action("ObtenerDetallePartidos","Tesoreria") %>',
                datatype: "json",
                pager: '#barraGridPartidos',
                postData: { estado: $("#selEstadoDetallePartido").val() },
                //editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
                colNames: ['id', 'Torneo', 'Programación', 'Partido', 'Número Depósito', 'Monto depósito', 'Monto rebajos', 'Estado'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 100, editable: true, editoptions: { readonly: true, size: 20} },
                    { name: 'numeroProgramacion', index: 'numeroProgramacion', width: 100, editable: true, editoptions: { readonly: true, size: 20} },
                    { name: 'numero', index: 'numero', width: 100, editable: true, editoptions: { readonly: true, size: 20} },
                    { name: 'deposito', index: 'deposito', width: 200, editable: true, sortable: false, editrules: { required: true} },
                    { name: 'total_pagar', index: 'total_pagar', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'total_rebajos', index: 'total_rebajos', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'estado', index: 'estado', width: 150, editable: false, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorEstadosDetallePartidosParaGrid() %>' }, formatter: 'select' }
                ]
            });


            $("#gridPartidos").jqGrid("navGrid", "#barraGridPartidos",
        {
            addfunc: function () {
                MostrarVentana("add");
            },
            editfunc: function (id) {
                MostrarVentana("edit", id);
            },
            edit: true,
            add: false,
            del: false,
            search: true,
            refresh: false,
            view: false
        },
        { multipleSearch: true }
        );

            jQuery("#gridPartidos").jqGrid('navButtonAdd', '#barraGridPartidos',
        {
            id: "VerRegistrogvComponentes",
            caption: "",
            title: "Ver detalle",
            buttonicon: "ui-icon ui-icon-document",
            onClickButton: function () {
                var cIdView = jQuery('#gridPartidos').getGridParam("selrow");
                if (cIdView == null) {
                    alert("Seleccione una fila");
                }
                else {
                    MostrarVentana("view", cIdView);
                }
            },
            position: 'last'
        });

        });

        function MostrarVentana(accion, id) {
            switch (accion) {
                case "edit":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    $("#ventanaEditar").dialog("option", "buttons", {
                        "Aceptar": function () { GuardarEditar(); },
                        "Cancelar": function () { $(this).dialog("close"); }
                    });
                    ObtenerDetallePartido(id);
                    HabilitarCampos(true);

                    break;
                case "view":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    ObtenerDetallePartido(id);
                    HabilitarCampos(false);
                    $("#ventanaEditar").dialog("option", "buttons", { "Cerrar": function () { $(this).dialog("close"); } });
                    break;
            }

        }

        var _DetallePartido = {
            Deducciones: []
        };

        function ActualizarEntidad(oRegistro) {
            var indiceRegistro = -1;
            for (var i = 0; i < oDetallePartido.Deducciones.length; i++) {
                if (_DetallePartido.Deducciones[i].id == oRegistro.id) {
                    indiceRegistro = i;
                }
            }
            switch (oRegistro.accionregistro) {
                case 0:
                    _DetallePartido.Deducciones.splice(indiceRegistro, 1);
                    break;
                case 1:
                    _DetallePartido.Deducciones.push(oRegistro);
                    break;
                case 2:
                case 3:
                    _DetallePartido.Deducciones[indiceRegistro] = oRegistro;
                    break;
            }
        }

        function MostrarTorneo(oDetallePartido) {
            _DetallePartido = oDetallePartido;

            $("#TxtNumero").val(_DetallePartido.numero);
            $("#selArbitros").val(_DetallePartido.idArbitro);
            $("#TxtNumeroProgramacion").val(_DetallePartido.numeroProgramacion);
            $("#TxtNombre").val(_DetallePartido.nombre);
            $("#TxtDeposito").val(_DetallePartido.deposito);
            $("#TxtMontoDeposito").val(_DetallePartido.total_pagar);
            $("#TxtMontoDeducciones").val(_DetallePartido.total_rebajos);
            $("#selEstado").val(_DetallePartido.estado);

            $('#gridDeducciones').clearGridData();
            $('#gridDeducciones').setGridParam({ data: _DetallePartido.Deducciones }).trigger('reloadGrid');
        }

        function CargarCampos() {
            var Entidad = {};
            var oDetallePartido = {};
            var oDeducciones = [];

            oDetallePartido.deposito = $("#TxtDeposito").val();
            oDetallePartido.total_pagar = $("#TxtMontoDeposito").val();
            oDetallePartido.total_rebajos = $("#TxtMontoDeducciones").val();
            oDetallePartido.id = _DetallePartido.id;

            for (var i = 0; i < _DetallePartido.Deducciones.length; i++) {
                var oDeduccion = {};
                oDeduccion.id = _DetallePartido.Deducciones[i].id;
                oDeduccion.descripcion = _DetallePartido.Deducciones[i].descripcion;
                oDeduccion.monto = _DetallePartido.Deducciones[i].monto.toString();
                oDeduccion.observaciones = _DetallePartido.Deducciones[i].observaciones;
                oDeduccion.accionregistro = _DetallePartido.Deducciones[i].accionregistro;

                oDeducciones.push(oDeduccion);
            }
            Entidad["oDetallePartido"] = oDetallePartido;
            Entidad["oDeducciones"] = oDeducciones;
            return Entidad;

        }

        function Limpiar() {
            _DetallePartido = {
                Deducciones: []
            };

            $("#TxtNumero").val("");
            $("#selArbitros").val("");
            $("#TxtNumeroProgramacion").val("");
            $("#TxtNombre").val("");
            $("#TxtDeposito").val("");
            $("#TxtMontoDeposito").val("");
            $("#TxtMontoDeducciones").val("");
            $("#selEstado").val("");

            $('#gridDeducciones').clearGridData();
        }

        function ObtenerDetallePartido(idTorneo) {
            var oParametrosAjax = { cID: idTorneo };

            var funcionProcesamientoCliente = function (oRespuesta) {
                MostrarTorneo(oRespuesta.oDetallePartido);
            }

            RealizarPeticionAjax("ObtenerDetallePartido", "/Tesoreria/ObtenerDetallePartidoPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
        }

        function ValidarCampos() {
            var bCampos = $("#frmPartidos").valid();
            if (bCampos == false) {
                return false;
            }
            return true;
        }


        function HabilitarCampos(bHabilitar) {
            if (bHabilitar) {
                $("#TxtNumero").attr("disabled", "disabled");
                $("#selArbitros").attr("disabled", "disabled");
                $("#TxtNumeroProgramacion").attr("disabled", "disabled");
                $("#TxtNombre").attr("disabled", "disabled");
                $("#TxtDeposito").removeAttr("disabled");
                $("#TxtMontoDeposito").removeAttr("disabled");
                $("#TxtMontoDeducciones").attr("disabled", "disabled");
                $("#selEstado").attr("disabled", "disabled");

                $("#add_gridDeducciones").show();
                $("#edit_gridDeducciones").show();
                $("#del_gridDeducciones").show();

            } else {
                $("#TxtNumero").attr("disabled", "disabled");
                $("#selArbitros").attr("disabled", "disabled");
                $("#TxtNumeroProgramacion").attr("disabled", "disabled");
                $("#TxtNombre").attr("disabled", "disabled");
                $("#TxtDeposito").attr("disabled", "disabled");
                $("#TxtMontoDeposito").attr("disabled", "disabled");
                $("#TxtMontoDeducciones").attr("disabled", "disabled");
                $("#selEstado").attr("disabled", "disabled");

                $("#add_gridDeducciones").hide();
                $("#edit_gridDeducciones").hide();
                $("#del_gridDeducciones").hide();
            }
        }

        function GuardarEditar() {
            if (ValidarCampos()) {
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "edit";
                //var oParametrosAjax = { _DetallePartido: _Torneo, oCanchas: _DetallePartido.Deducciones, oper: "edit" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridPartidos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarTorneo", "/Tesoreria/EditarDetallePartidos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }
    </script>
    <div id="ventanaEditar">
        <form id="frmPartidos" action="">
            <fieldset class="Fieldset">
            <legend>Información General</legend>
            <div class="ContenidoOrdenado">
                <div class="fila">
                    <div class="celdaLabel">
                        Partido
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNumero" name="TxtNumero" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Árbitro
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorArbitros("selArbitros") %>
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Programación
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNumeroProgramacion" name="TxtNumeroProgramacion" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Torneo
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNombre" name="TxtNombre" class="required" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Número Depósito
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtDeposito" name="TxtDeposito" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Monto del Depósito
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtMontoDeposito" name="TxtMontoDeposito" type="text" class="required"/>
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Total de Deducciones
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtMontoDeducciones" name="TxtMontoDeducciones" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Estado
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorEstadosDetallePartidos("selEstado") %>
                    </div>
                </div>
            </div>
        </fieldset>
    </form>
    <br />
    <fieldset class="Fieldset">
        <legend>Deducciones</legend>
        <table id="gridDeducciones">
        </table>
        <div id="barraGridDeducciones">
        </div>
    </fieldset>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Tesorería</h1>
<h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
