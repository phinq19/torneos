﻿<%@ Page Title="ACAF Programaciones" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridProgramaciones">
    </table>
    <div id="barraGridProgramaciones">
    </div>
    <script type='text/javascript'>
        $(document).ready(function () {

            $("#frmProgramaciones").validate();

            $("#ventanaEditar").dialog({
                autoOpen: false,
                zIndex: 500,
                resizable: false,
                modal: true,
                title: "Programación de Partidos",
                //closeOnEscape: true,
                height: 500,
                width: 810
            });

            $("#gridPartidos").jqGrid({
                //url: '<%= Url.Action("ObtenerProgramacions","Programacions") %>',
                datatype: "local",
                rowNum: 10,
                rowList: [10, 20, 30],
                mtype: "post",
                pager: '#barraGridPartidos',
                loadonce: true,
                viewrecords: true,
                caption: "Partidos de la jornada",
                editurl: '<%= Url.Action("ValidarPartidos","Programaciones") %>',
                jsonReader: { repeatitems: false },
                ignoreCase: true,
                height: 120,
                width: 775,
                shrinkToFit: false,
                colNames: ['id', 'Número', 'Cancha', 'Equipos', 'Fecha', 'Coordinador', 'Teléfono Coord.', 'Estados', 'Observaciones', 'accionregistro'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'numero', index: 'numero', width: 100, editable: true, editoptions: { size: 20 }},
                    { name: 'idCancha', index: 'idCancha', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorTorneosCanchasParaGrid(Convert.ToInt32(Context.Request.Cookies["idTorneo"].Value)) %>' }, formatter: 'select' },
                    { name: 'equipos', index: 'equipos', width: 150, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'fecha_hora', index: 'fecha_hora', width: 120, editable: true, editoptions: { size: 40 }, editrules: { required: true}, formatter:"date"},
                    { name: 'coordinador', index: 'coordinador', width: 120, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'telefono_coordinador', index: 'telefono_coordinador', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'estado', index: 'estado', width: 120, editable: false, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorEstadoPartidosParaGrid() %>' }, formatter: 'select' },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} },
                    { name: 'accionregistro', index: 'accionregistro', width: 55, editable: true, hidden: true },
            ]
            });

            var ProcesarEditar_gvPartidos = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "500",
                savekey: [true, 13],
                navkeys: [true, 38, 40],
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

            var Procesar_Eliminar_gvPartidos = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "500",
                savekey: [true, 13],
                navkeys: [true, 38, 40],
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


            $("#gridPartidos").jqGrid('navGrid', '#barraGridPartidos',
            {
                edit: true,
                add: true,
                del: true,
                refresh: false,
                search: false,
                view: true
            }, //options 
                 ProcesarEditar_gvPartidos, // edit options 
                 ProcesarEditar_gvPartidos, // add options 
                 Procesar_Eliminar_gvPartidos, // del options
                 {}, // search options 
                 {width: "600" }
            );


            $("#gridProgramaciones").jqGrid({
                url: '<%= Url.Action("ObtenerProgramaciones","Programaciones") %>',
                datatype: "json",
                rowNum: 10,
                rowList: [10, 20, 30],
                mtype: "post",
                pager: '#barraGridProgramaciones',
                //loadonce: true,
                viewrecords: true,
                caption: "Programación de partidos",
                //editurl: '<%= Url.Action("EditarProgramacions","Programacions") %>',
                jsonReader: { repeatitems: false },
                ignoreCase: true,
                height: 250,
                width: 850,
                shrinkToFit: false,
                colNames: ['id', 'Número', 'Torneo', 'Estado', 'Depósitos', 'Monto', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'numero', index: 'numero', width: 100, editable: true, editoptions: { readonly: true, size: 10} },
                    { name: 'idTorneo', index: 'idTorneo', width: 250, editable: true, editoptions: { size: 40 }, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorTorneosParaGrid() %>' }, formatter: 'select' },
                    { name: 'estado', index: 'estado', width: 100, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorEstadoProgramacionesParaGrid() %>' }, formatter: 'select' },
                    { name: 'deposito', index: 'deposito', width: 300, editable: true, sortable: false, editrules: { required: true} },
                    { name: 'monto', index: 'monto', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
            });


        $("#gridProgramaciones").jqGrid("navGrid", "#barraGridProgramaciones",
        {
            addfunc: function () {
                MostrarVentana("add");
            },
            editfunc: function (id) {
                MostrarVentana("edit", id);
            },
            edit: true,
            add: true,
            del: true,
            search: true,
            refresh: false,
            view: false
        },
        { multipleSearch: true }
        );

            jQuery("#gridProgramaciones").jqGrid('navButtonAdd', '#barraGridProgramaciones',
        {
            id: "VerRegistrogvComponentes",
            caption: "",
            title: "Ver detalle",
            buttonicon: "ui-icon ui-icon-document",
            onClickButton: function () {
                var cIdView = jQuery('#gridProgramaciones').getGridParam("selrow");
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
                    ObtenerProgramacion(id);
                    HabilitarCampos(true);
                    
                    break;
                case "view":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    ObtenerProgramacion (id);
                    HabilitarCampos(false);
                    $("#ventanaEditar").dialog("option", "buttons", { "Cerrar": function () { $(this).dialog("close"); } });
                    break;
            }
            
        }

        var _Programacion = {
            Partidos: []
        };

        function ActualizarEntidad(oRegistro) {
            var indiceRegistro = -1;
            for (var i = 0; i < _Programacion.Partidos.length; i++) {
                if (_Programacion.Partidos[i].id == oRegistro.id) {
                    indiceRegistro = i;
                }
            }
            switch (oRegistro.accionregistro) {
                case 0:
                    _Programacion.Partidos.splice(indiceRegistro, 1);
                break;
                case 1:
                    _Programacion.Partidos.push(oRegistro);
                break;
                case 2:
                case 3:
                    _Programacion.Partidos[indiceRegistro] = oRegistro;
                    break;
            }
        }

        function MostrarProgramacion(oProgramacion) {
            _Programacion = oProgramacion;

            $("#selEstado").val(oProgramacion.estado);
            $("#TxtDeposito").val(oProgramacion.deposito);
            $("#TxtMonto").val(oProgramacion.monto);
            $("#TxtNumero").val(oProgramacion.numero);
            $("#selTorneo").val(oProgramacion.idTorneo);
            $("#TxtObservaciones").val(oProgramacion.observaciones);

            $('#gridPartidos').clearGridData();
            $('#gridPartidos').setGridParam({ data: oProgramacion.Partidos }).trigger('reloadGrid');
        }

        function CargarCampos() {
            var Entidad = {};
            var oProgramacion = {};
            var oPartidos = [];

            oProgramacion.deposito = $("#TxtDeposito").val();
            oProgramacion.monto = $("#TxtMonto").val();
            oProgramacion.idTorneo = $("#selTorneosTorneo").val();
            oProgramacion.observaciones = $("#TxtObservaciones").val();
            oProgramacion.id = _Programacion.id;

            for (var i = 0; i < _Programacion.Partidos.length; i++) {
                var oPartido = {};
                oPartido.id = _Programacion.Partidos[i].id;
                oPartido.coordinador = _Programacion.Partidos[i].coordinador.toString();
                oPartido.equipos = _Programacion.Partidos[i].equipos.toString();
                oPartido.observaciones = _Programacion.Partidos[i].observaciones.toString();
                oPartido.telefono_coordinador = _Programacion.Partidos[i].telefono_coordinador.toString();
                oPartido.fecha_hora = _Programacion.Partidos[i].fecha_hora.toString();
                oPartido.idCancha = _Programacion.Partidos[i].idCancha.toString();
                oPartido.accionregistro = _Programacion.Partidos[i].accionregistro;

                oPartidos.push(oPartido);

            }
            Entidad["oProgramacion"] = oProgramacion;
            Entidad["oPartidos"] = oPartidos;
            return Entidad;
            
        }

        function Limpiar() {
            _Programacion = {
                Partidos: []
            };
            
            $("#selTorneo").val("");
            $("#selEstado").val("");
            $("#TxtMonto").val("");
            $("#TxtDeposito").val("");
            $("#TxtObservaciones").val("");
            $("#TxtObservacionesAsociacion").val("");
            $("#TxtNumero").val("");

            $('#gridPartidos').clearGridData();
        }

        function ObtenerProgramacion(idProgramacion) {
            var oParametrosAjax = { cID: idProgramacion };

            var funcionProcesamientoCliente = function (oRespuesta) {
                MostrarProgramacion(oRespuesta.oProgramacion);
            }

            RealizarPeticionAjax("ObtenerProgramacion", "/Programaciones/ObtenerProgramacionPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
        }

        function ValidarCampos() {
            var bCampos = $("#frmProgramaciones").valid();
            var bCanchas = $('#gridPartidos').getGridParam("data").length > 0;
            if(bCanchas == false){
                alert("Debe de agregar al menos un partidos a la jornada");
            }
            if (bCanchas == false || bCampos == false) {
                return false;
            }
            return true;
        }


        function HabilitarCampos(bHabilitar) {
            if (bHabilitar) {
                //$("#selTorneo").removeAttr("disabled");
                //$("#selEstado").removeAttr("disabled");
                $("#selTorneo").attr("disabled", "disabled");
                $("#selEstado").attr("disabled", "disabled");

                $("#TxtNumero").attr("disabled", "disabled");

                $("#TxtMonto").removeAttr("disabled");
                $("#TxtDeposito").removeAttr("disabled");
                $("#TxtObservaciones").removeAttr("disabled");

                //$("#TxtObservacionesAsociacion").removeAttr("disabled");
                $("#TxtObservacionesAsociacion").attr("disabled", "disabled");

                $("#add_gridPartidos").show();
                $("#edit_gridPartidos").show();
                $("#del_gridPartidos").show();

            } else {
                $("#selTorneo").attr("disabled", "disabled");
                $("#selEstado").attr("disabled", "disabled");
                $("#TxtMonto").attr("disabled", "disabled");
                $("#TxtDeposito").attr("disabled", "disabled");
                $("#TxtObservaciones").attr("disabled", "disabled");
                $("#TxtObservacionesAsociacion").attr("disabled", "disabled");
                $("#TxtNumero").attr("disabled", "disabled");

                $("#add_gridPartidos").hide();
                $("#edit_gridPartidos").hide();
                $("#del_gridPartidos").hide();
            }
        }

        function GuardarEditar() {
            if (ValidarCampos()) {
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "edit";
                //var oParametrosAjax = { oProgramacion: _Programacion, oCanchas: _Programacion.Partidos, oper: "edit" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridProgramaciones").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarProgramaciones", "/Programaciones/EditarProgramaciones", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

        function GuardarAgregar() {
            if (ValidarCampos()) {
                CargarCampos();
                //var oParametrosAjax = { oProgramacion: _Programacion, oper: "add" };
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "add";

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridProgramaciones").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarProgramaciones", "/Programaciones/EditarProgramaciones", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

    </script>
    <div id="ventanaEditar">
        <form id="frmProgramaciones" action="">
            <fieldset class="Fieldset">
            <legend>Identificación</legend>
            <div class="ContenidoOrdenado">
                <div class="fila">
                    <div class="celdaLabel">
                        Número
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNumero" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Torneos
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorTorneos("selTorneo")%>
                    </div>
                    <div class="celdaLabel">
                        Estado
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorEstadosProgramaciones("selEstado") %>
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Depósitos
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtDeposito" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Monto
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtMonto" class="required" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Observaciones
                    </div>
                    <div class="">
                        <textarea id="TxtObservaciones" rows="2" cols="40"></textarea>
                    </div>
                    <div class="celdaLabel">
                        Observaciones Asociación
                    </div>
                    <div class="">
                        <textarea id="TxtObservacionesAsociacion" rows="2" cols="40"></textarea>
                    </div>
                </div>
            </div>
        </fieldset>
    </form>
    <br />
    <table id="gridPartidos">
    </table>
    <div id="barraGridPartidos">
    </div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
    <h1>Programación de Partidos</h1>
    <h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
