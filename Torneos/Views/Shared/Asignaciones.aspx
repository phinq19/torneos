﻿<%@ Page Title="ACAF Asignaciones" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <fieldset class="Fieldset">
    <legend>Filtro</legend>
        <div class="ContenidoOrdenado">
            <div class="fila">
                <div class="columna">
                    Estado del partido
                </div>
                <div class="celdaCampo">
                    <%= Torneos.Utilidades.CrearSelectorEstadosPartidos("selEstado") %>
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

            $("#selEstado").change(function () {
                var postData = jQuery("#gridPartidos").getGridParam("postData");
                postData.estado = $("#selEstado").val();
                jQuery("#gridPartidos").setGridParam("postData", postData);
                jQuery("#gridPartidos").trigger("reloadGrid");
            });

            $("#frmPartidos").validate();

            $("#ventanaEditar").dialog({
                autoOpen: false,
                zIndex: 500,
                resizable: false,
                modal: false,
                title: "Asignaciones de árbitros",
                //closeOnEscape: true,
                height: 580,
                width: 800
            });

            $("#gridArbitros").jqGrid({
                //url: '<%= Url.Action("ObtenerPartidos","Partidos") %>',
                datatype: "local",
                pager: '#barraGridArbitros',
                editurl: '<%= Url.Action("ValidarDetallePartido","Asignaciones") %>',
                height: 100,
                width: 739,
                colNames: ['id', 'Árbitro', 'Puesto'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'idArbitro', index: 'idArbitro', width: 250, editable: true, sortable: false, editrules: { required: true }, edittype: 'custom', editoptions: { custom_element: selArbitrosAsignaciones, custom_value: obtenerValorselArbitrosAsignaciones, value: '<%= Torneos.Utilidades.CrearSelectorArbitrosParaGrid() %>' }, /*editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorArbitrosParaGrid() %>' },*/formatter: 'select' },
                    { name: 'puesto', index: 'puesto', width: 150, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorTiposArbitroParaGrid() %>' }, formatter: 'select' }
                ]
            });

            var ProcesarEditar_gvArbitros = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "500",
                savekey: [true, 13],
                navkeys: [true, 38, 40],
                zIndex: 9999,
                recreateForm: true,
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
                                    for (var i = 0; i < _Partido.DetallePartidos.length; i++) {
                                        if (_Partido.DetallePartidos[i].id != datos.ObjetoDetalle.id &&
                                            _Partido.DetallePartidos[i].accionregistro != 3 &&
                                            _Partido.DetallePartidos[i].puesto == 0 &&
                                             datos.ObjetoDetalle.puesto == 0) {
                                            return [false, "Este partido ya tiene un árbitro central asignado", '-1'];
                                        }
                                    }
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
                }
            }

            var Procesar_Eliminar_gvArbitros = {
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
                }
            }


            $("#gridArbitros").jqGrid('navGrid', '#barraGridArbitros',
            {
                edit: true,
                add: false,
                del: false,
                refresh: false,
                search: false,
                view: true
            }, //options 
                 ProcesarEditar_gvArbitros, // edit options 
                 ProcesarEditar_gvArbitros, // add options 
                 Procesar_Eliminar_gvArbitros, // del options
                 {}, // search options 
                 {width: "600" }
            );


            $("#gridPartidos").jqGrid({
                url: '<%= Url.Action("ObtenerPartidos","Asignaciones") %>',
                postData: { estado: $("#selEstado").val() },
                datatype: "json",
                pager: '#barraGridPartidos',
                //editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
                colNames: ['id', 'Torneo', 'Programación', 'Partido', 'Equipo Local', 'Equipo Visita', 'Cancha', 'Cantidad Árbitros', 'Tipo Partido', 'Fecha', 'Hora', 'Horario','Coordinador', 'Teléfono Coord.', 'Estados', 'Observaciones', 'accionregistro'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 100, editable: true, editoptions: { readonly: true, size: 20} },
                    { name: 'numeroProgramacion', index: 'numeroProgramacion', width: 100, editable: true, editoptions: { readonly: true, size: 20} },
                    { name: 'numero', index: 'numero', width: 100, editable: true, editoptions: { readonly: true, size: 20} },
                    { name: 'equipoLocal', index: 'equipoLocal', width: 150, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'equipoVisita', index: 'equipoVisita', width: 150, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'idCancha', index: 'idCancha', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorCanchasParaGrid() %>' }, formatter: 'select' },
                    { name: 'arbitros', index: 'arbitros', width: 180, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorCantidadArbitrosParaGrid() %>' }, formatter: 'select' },
                    { name: 'tipo', index: 'tipo', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorTiposPartidoParaGrid() %>' }, formatter: 'select' },
                    { name: 'fecha', index: 'fecha', datefmt: 'd/m/y', width: 120, editable: true, editoptions: { size: 40 }, editrules: { required: true, date: true }, sorttype: "date", formatter: "fechaFmatter", editoptions: { defaultValue: '<%= DateTime.Now.ToShortDateString() %>'} },
                    { name: 'hora', index: 'hora', width: 120, editable: true, editoptions: { size: 40 }, editrules: { required: true }, formatter: "time" },
                    { name: 'tiempo', index: 'tiempo', width: 120, editable: true, sortable: false, edittype: 'select', editoptions: { readonly: true, value: '1:Mañana;2:Tarde;3:Noche' }, formatter: 'select' },
                    { name: 'coordinador', index: 'coordinador', width: 120, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'telefono_coordinador', index: 'telefono_coordinador', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'estado', index: 'estado', width: 150, editable: false, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorEstadoPartidosParaGrid() %>' }, formatter: 'select' },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} },
                    { name: 'accionregistro', index: 'accionregistro', width: 55, editable: true, hidden: true }
                ]
            });


        $("#gridPartidos").jqGrid("navGrid", "#barraGridPartidos",
        {
            addfunc: function () {
                MostrarVentana("add");
            },
            editfunc: function (id) {
                var oData = jQuery('#gridPartidos').getRowData(id);
                if (oData.estado.toString() == "2") {
                    alert("No se puede editar la asignación de árbitros de este partido, porque ya posee informe");
                }
                else {
                    MostrarVentana("edit", id);
                }
            },
            edit: true,
            add: false,
            del: false,
            search: false,
            refresh: true,
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
                case "add":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    $("#ventanaEditar").dialog("option", "buttons", {
                        "Aceptar": function () { GuardarAgregar(); },
                        "Cancelar": function () { $(this).dialog("close"); }
                    });
                    HabilitarCampos(true);
                    break;
                case "edit":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    $("#ventanaEditar").dialog("option", "buttons", {
                        "Aceptar": function () { GuardarEditar(); },
                        "Cancelar": function () { $(this).dialog("close"); }
                    });
                    ObtenerPartido(id);
                    HabilitarCampos(true);

                    break;
                case "view":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    ObtenerPartido(id);
                    HabilitarCampos(false);
                    $("#ventanaEditar").dialog("option", "buttons", { "Cerrar": function () { $(this).dialog("close"); } });
                    break;
            }

        }

        var _Partido = {
            DetallePartidos: []
        };

        function ActualizarEntidad(oRegistro) {
            var indiceRegistro = -1;
            for (var i = 0; i < _Partido.DetallePartidos.length; i++) {
                if (_Partido.DetallePartidos[i].id == oRegistro.id) {
                    indiceRegistro = i;
                }
            }
            
            _Partido.DetallePartidos[indiceRegistro] = oRegistro;
        }

        function MostarPartido(oPartido) {
            _Partido = oPartido;

            $("#TxtNumeroProgramacion").val(oPartido.numeroProgramacion);
            $("#TxtNombre").val(oPartido.nombre);
            $("#TxtNumero").val(oPartido.numero);
            $("#selEstadoPartido").val(oPartido.estado);
            $("#TxtLocal").val(oPartido.equipoLocal);
            $("#TxtVisita").val(oPartido.equipoVisita);
            $("#TxtFecha").val(Convertir_Json_A_Fecha(oPartido.fecha));
            $("#TxtHora").val(oPartido.hora);
            $("#selTipo").val(oPartido.tipo);
            $("#selCancha").val(oPartido.idCancha);
            $("#TxtCoordinador").val(oPartido.coordinador);
            $("#TxtTelefonoCoordinador").val(oPartido.telefono_coordinador);
            $("#TxtObservaciones").val(oPartido.observaciones);

            $('#gridArbitros').clearGridData();
            $('#gridArbitros').setGridParam({ data: oPartido.DetallePartidos }).trigger('reloadGrid');
        }

        function CargarCampos() {
            var Entidad = {};
            var oPartido = {};
            var oDetallesPartidos = [];
            
            oPartido.numero = $("#TxtNumero").val();
            oPartido.estado = $("#selEstadoPartido").val();
            oPartido.equipoLocal = $("#TxtLocal").val();
            oPartido.equipoVisita = $("#TxtVisita").val();
            oPartido.fecha = $("#TxtFecha").val();
            oPartido.hora = $("#TxtHora").val();
            oPartido.tipo = $("#selTipo").val();
            oPartido.idCancha = $("#selCancha").val();
            oPartido.coordinador = $("#TxtCoordinador").val();
            oPartido.telefono_coordinador = $("#TxtTelefonoCoordinador").val();
            oPartido.observaciones = $("#TxtObservaciones").val();
            oPartido.id = _Partido.id;

            for (var i = 0; i < _Partido.DetallePartidos.length; i++) {
                var oDetallePartidos = {};
                oDetallePartidos.id = _Partido.DetallePartidos[i].id;
                oDetallePartidos.idArbitro = _Partido.DetallePartidos[i].idArbitro;
                oDetallePartidos.puesto = _Partido.DetallePartidos[i].puesto;

                oDetallesPartidos.push(oDetallePartidos);
            }
            Entidad["oPartido"] = oPartido;
            Entidad["oDetallePartidos"] = oDetallesPartidos;
            return Entidad;

        }

        function Limpiar() {
            _Partido = {
                DetallePartidos: []
            };
            $("#frmPartidos").validate().resetForm();

            $("#TxtNumeroProgramacion").val("");
            $("#TxtNombre").val("");
            $("#TxtNumero").val("");
            $("#selEstadoPartido").val("");
            $("#TxtLocal").val("");
            $("#TxtVisita").val("");
            $("#TxtFecha").val("");
            $("#TxtHora").val("");
            $("#selTipo").val("");
            $("#selCancha").val("");
            $("#TxtCoordinador").val("");
            $("#TxtTelefonoCoordinador").val("");
            $("#TxtObservaciones").val("");

            $('#gridArbitros').clearGridData();
        }

        function ObtenerPartido(idPartido) {
            var oParametrosAjax = { cID: idPartido };

            var funcionProcesamientoCliente = function (oRespuesta) {
                MostarPartido(oRespuesta.oPartido);
            }

            RealizarPeticionAjax("ObtenerPartido", "/Asignaciones/ObtenerPartidoPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
        }

        function ValidarCampos() {
            var bCentral = false;
            for (var i = 0; i < _Partido.DetallePartidos.length; i++) {
                if (_Partido.DetallePartidos[i].idArbitro == -1) {
                    alert("No se puede realizar esta operación, hace falta asignar árbitros");
                    return false;
                }
                if (_Partido.DetallePartidos[i].puesto == 0) {
                    bCentral = true;
                }
            }
            if (bCentral == false) {
                alert("No se puede realizar esta operación, hace falta asignar un árbitro central");
                return false;
            }
            return true;
        }


        function HabilitarCampos(bHabilitar) {
            if (bHabilitar) {
                $("#TxtNumeroProgramacion").attr("disabled", "disabled");
                $("#TxtNombre").attr("disabled", "disabled");
                $("#TxtNumero").attr("disabled", "disabled");
                $("#selEstadoPartido").attr("disabled", "disabled");
                $("#TxtLocal").attr("disabled", "disabled");
                $("#TxtVisita").attr("disabled", "disabled");
                $("#TxtFecha").attr("disabled", "disabled");
                $("#TxtHora").attr("disabled", "disabled");
                $("#selTipo").attr("disabled", "disabled");
                $("#selCancha").attr("disabled", "disabled");
                $("#TxtCoordinador").attr("disabled", "disabled");
                $("#TxtTelefonoCoordinador").attr("disabled", "disabled");
                $("#TxtObservaciones").attr("disabled", "disabled");

                //$("#add_gridArbitros").show();
                $("#edit_gridArbitros").show();
                //$("#del_gridArbitros").show();

            } else {
                $("#TxtNumeroProgramacion").attr("disabled", "disabled");
                $("#TxtNombre").attr("disabled", "disabled");
                $("#TxtNumero").attr("disabled", "disabled");
                $("#selEstadoPartido").attr("disabled", "disabled");
                $("#TxtLocal").attr("disabled", "disabled");
                $("#TxtVisita").attr("disabled", "disabled");
                $("#TxtFecha").attr("disabled", "disabled");
                $("#TxtHora").attr("disabled", "disabled");
                $("#selTipo").attr("disabled", "disabled");
                $("#selCancha").attr("disabled", "disabled");
                $("#TxtCoordinador").attr("disabled", "disabled");
                $("#TxtTelefonoCoordinador").attr("disabled", "disabled");
                $("#TxtObservaciones").attr("disabled", "disabled");

                //$("#add_gridArbitros").hide();
                $("#edit_gridArbitros").hide();
                //$("#del_gridArbitros").hide();
            }
        }

        function GuardarEditar() {
            if (ValidarCampos()) {
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "edit";
                //var oParametrosAjax = { oTorneo: _Torneo, oCanchas: _Torneo.Torneos_Canchas, oper: "edit" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridPartidos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarAsignacion", "/Asignaciones/EditarPartidos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

        function GuardarAgregar() {
            if (ValidarCampos()) {
                CargarCampos();
                //var oParametrosAjax = { oTorneo: _Torneo, oper: "add" };
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "add";
                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridPartidos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarAsignacion", "/Asignaciones/EditarPartidos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

        function selArbitrosAsignaciones(value, options) {
            /*
            var el = document.createElement("input");
            el.type = "text";
            el.value = value;
            return el;
            */
            var elem = {};
            var idPartido = $("#gridPartidos").getGridParam("selrow");
            var oPartido = $("#gridPartidos").getRowData(idPartido);

            var idDetallePartido = $("#gridArbitros").getGridParam("selrow");
            var oDetallePartido = $("#gridArbitros").getRowData(idDetallePartido);

            var oParametrosAjax = {
                idSelector: "selArbitros",
                dFecha: oPartido.fecha,
                dHorario: oPartido.tiempo
            };

            var funcionProcesamientoCliente = function (oRespuesta) {
                elem = $(oRespuesta.selector).val(oDetallePartido.idArbitro);
            }

            RealizarPeticionAjax("ObtenerSelectorArbitrosParaAsignaciones", "/Asignaciones/ObtenerSelectorArbitrosParaAsignaciones", oParametrosAjax, true, false, null, funcionProcesamientoCliente);
            
            return elem;
        }

        function obtenerValorselArbitrosAsignaciones(elem, operation, value) {
            if (operation === 'get') {
                return $(elem).val();
            } else {
                if (operation === 'set') {
                    $(elem).val(value);
                }
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
                        Equipo Local
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtLocal" name="TxtLocal" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Equipo Visita
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtVisita" name="TxtVisita" class="required" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Fecha
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtFecha" name="TxtFecha" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Hora
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtHora" name="TxtHora" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Tipo
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorTiposPartido("selTipo") %>
                    </div>
                    <div class="celdaLabel">
                        Cancha
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorCanchas("selCancha") %>
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Coordinador
                    </div>
                    <div class="">
                        <input id="TxtCoordinador" name="TxtCoordinador" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Teléfono
                    </div>
                    <div class="">
                        <input id="TxtTelefonoCoordinador" name="TxtTelefonoCoordinador" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Estado
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorEstadosPartidos("selEstadoPartido")%>
                    </div>
                    <div class="celdaLabel">
                        Observaciones
                    </div>
                    <div class="">
                        <textarea id="TxtObservaciones" name="TxtObservaciones" class="required" rows="2" cols="40"></textarea>
                    </div>
                </div>
            </div>
        </fieldset>
    </form>
    <br />
    <fieldset class="Fieldset">
        <legend>Arbitros del partido</legend>
        <table id="gridArbitros">
        </table>
        <div id="barraGridArbitros">
        </div>
    </fieldset>
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Asignaciones</h1>
<h1><a href="/">Volver al menú principal</a></h1> 
</asp:Content>
