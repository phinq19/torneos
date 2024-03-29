﻿<%@ Page Title="ACAF Torneos" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridTorneos">
    </table>
    <div id="barraGridTorneos">
    </div>
    <script type='text/javascript'>
        $(document).ready(function () {

            $("#frmTorneos").validate();

            $("#ventanaEditar").dialog({
                autoOpen: false,
                zIndex: 500,
                resizable: false,
                modal: false,
                title: "Torneos",
                //closeOnEscape: true,
                height: 510,
                width: 800
            });

            $("#gridCanchas").jqGrid({
                //url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
                datatype: "local",
                loadonce: true,
                pager: '#barraGridCanchas',
                editurl: '<%= Url.Action("ValidarTorneoCanchas","Torneos") %>',
                height: 120,
                width: 756,
                colNames: ['id', 'Cancha', 'Viáticos', 'Observaciones', 'accionregistro'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'idCancha', index: 'idCancha', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorCanchasParaGrid() %>" }, formatter: 'select' },
                    { name: 'viaticos', index: 'viaticos', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true, integer: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} },
                    { name: 'accionregistro', index: 'accionregistro', width: 55, editable: true, hidden: true },
            ]
            });

            function ObtenerMonto(elem, option) {
                return "1000,5";
            }

            var ProcesarEditar_gvCanchas = {
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
                                    for (var i = 0; i < _Torneo.Torneos_Canchas.length; i++) {
                                        if (_Torneo.Torneos_Canchas[i].id != datos.ObjetoDetalle.id &&
                                            _Torneo.Torneos_Canchas[i].accionregistro != 3 &&
                                             _Torneo.Torneos_Canchas[i].idCancha == datos.ObjetoDetalle.idCancha) {
                                            return [false, "Esta cancha ya pertenece al torneo", '-1'];
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

            var Procesar_Eliminar_gvCanchas = {
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


            $("#gridCanchas").jqGrid('navGrid', '#barraGridCanchas',
            {
                edit: true,
                add: true,
                del: true,
                refresh: false,
                search: false,
                view: true
            }, //options 
                 ProcesarEditar_gvCanchas, // edit options 
                 ProcesarEditar_gvCanchas, // add options 
                 Procesar_Eliminar_gvCanchas, // del options
                 {}, // search options 
                 {width: "600" }
            );


            $("#gridTorneos").jqGrid({
                url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
                datatype: "json",
                pager: '#barraGridTorneos',
                //editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
                colNames: ['id', 'Nombre', 'Ubicacion', 'Categoría', 'Teléfono 1', 'Teléfono 2', 'Correo', 'Dieta', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'ubicacion', index: 'ubicacion', width: 300, editable: true, sortable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50" }, editrules: { required: true} },
                    { name: 'categoria', index: 'categoria', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorCategoriasParaGrid() %>" }, formatter: 'select' },
                    { name: 'telefono1', index: 'telefono1', width: 80, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { required: true} },
                    { name: 'telefono2', index: 'telefono2', width: 80, editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'email', index: 'email', width: 120, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { email: true} },
                    { name: 'dieta', index: 'dieta', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
            });


            $("#gridTorneos").jqGrid("navGrid", "#barraGridTorneos",
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
            search: false,
            refresh: true,
            view: false
        },
        { multipleSearch: true }
        );

            jQuery("#gridTorneos").jqGrid('navButtonAdd', '#barraGridTorneos',
        {
            id: "VerRegistrogvComponentes",
            caption: "",
            title: "Ver detalle",
            buttonicon: "ui-icon ui-icon-document",
            onClickButton: function () {
                var cIdView = jQuery('#gridTorneos').getGridParam("selrow");
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
                    ObtenerTorneo(id);
                    HabilitarCampos(true);

                    break;
                case "view":
                    Limpiar();
                    $("#ventanaEditar").dialog('open');
                    ObtenerTorneo(id);
                    HabilitarCampos(false);
                    $("#ventanaEditar").dialog("option", "buttons", { "Cerrar": function () { $(this).dialog("close"); } });
                    break;
            }

        }

        var _Torneo = {
            Torneos_Canchas: []
        };

        function ActualizarEntidad(oRegistro) {
            var indiceRegistro = -1;
            for (var i = 0; i < _Torneo.Torneos_Canchas.length; i++) {
                if (_Torneo.Torneos_Canchas[i].id == oRegistro.id) {
                    indiceRegistro = i;
                }
            }
            switch (oRegistro.accionregistro) {
                case 0:
                    _Torneo.Torneos_Canchas.splice(indiceRegistro, 1);
                    break;
                case 1:
                    if (indiceRegistro != -1) {
                        _Torneo.Torneos_Canchas[indiceRegistro] = oRegistro;
                    }
                    else {
                        _Torneo.Torneos_Canchas.push(oRegistro);
                    }
                    break;
                case 2:
                case 3:
                    _Torneo.Torneos_Canchas[indiceRegistro] = oRegistro;
                    break;
            }
        }

        function MostrarTorneo(oTorneo) {
            _Torneo = oTorneo;

            $("#TxtNombre").val(oTorneo.nombre);
            $("#selCategoria").val(oTorneo.categoria);
            $("#TxtTelefono1").val(oTorneo.telefono1);
            $("#TxtTelefono2").val(oTorneo.telefono2);
            $("#TxtDieta").val(oTorneo.dieta);
            $("#TxtCorreo").val(oTorneo.email);
            $("#TxtUbicacion").val(oTorneo.ubicacion);
            $("#TxtObservaciones").val(oTorneo.observaciones);

            $('#gridCanchas').clearGridData();
            $('#gridCanchas').setGridParam({ data: oTorneo.Torneos_Canchas }).trigger('reloadGrid');
        }

        function CargarCampos() {
            var Entidad = {};
            var oTorneo = {};
            var oCanchas = [];

            oTorneo.nombre = $("#TxtNombre").val();
            oTorneo.categoria = $("#selCategoria").val();
            oTorneo.telefono1 = $("#TxtTelefono1").val();
            oTorneo.telefono2 = $("#TxtTelefono2").val();
            oTorneo.dieta = $("#TxtDieta").val().replace(".", ",");
            oTorneo.email = $("#TxtCorreo").val();
            oTorneo.ubicacion = $("#TxtUbicacion").val();
            oTorneo.observaciones = $("#TxtObservaciones").val();
            oTorneo.idAsociacion = _Torneo.idAsociacion;
            oTorneo.id = _Torneo.id;
            for (var i = 0; i < _Torneo.Torneos_Canchas.length; i++) {
                var oCancha = {};
                oCancha.id = _Torneo.Torneos_Canchas[i].id;
                oCancha.viaticos = _Torneo.Torneos_Canchas[i].viaticos.toString();
                oCancha.idCancha = _Torneo.Torneos_Canchas[i].idCancha;
                oCancha.observaciones = _Torneo.Torneos_Canchas[i].observaciones;
                oCancha.idTorneo = _Torneo.Torneos_Canchas[i].idTorneo;
                oCancha.accionregistro = _Torneo.Torneos_Canchas[i].accionregistro;

                oCanchas.push(oCancha);

            }
            Entidad["oTorneo"] = oTorneo;
            Entidad["oCanchas"] = oCanchas;
            return Entidad;

        }

        function Limpiar() {
            _Torneo = {
                Torneos_Canchas: []
            };

            $("#frmTorneos").validate().resetForm();

            $("#TxtNombre").val("");
            $("#selCategoria").val("");
            $("#TxtTelefono1").val("");
            $("#TxtTelefono2").val("");
            $("#TxtDieta").val("");
            $("#TxtCorreo").val("");
            $("#TxtUbicacion").val("");
            $("#TxtObservaciones").val("");

            $('#gridCanchas').clearGridData();
        }

        function ObtenerTorneo(idTorneo) {
            var oParametrosAjax = { cID: idTorneo };

            var funcionProcesamientoCliente = function (oRespuesta) {
                MostrarTorneo(oRespuesta.oTorneo);
            }

            RealizarPeticionAjax("ObtenerTorneo", "/Torneos/ObtenerTorneoPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
        }

        function ValidarCampos() {
            var bCampos = $("#frmTorneos").valid();
            var bCanchas = $('#gridCanchas').getGridParam("data").length > 0;
            if (bCanchas == false) {
                alert("Debe de asignar al menos una cancha al torneos");
            }
            if (bCanchas == false || bCampos == false) {
                return false;
            }
            return true;
        }


        function HabilitarCampos(bHabilitar) {
            if (bHabilitar) {
                $("#TxtNombre").removeAttr("disabled");
                $("#selCategoria").removeAttr("disabled");
                $("#TxtTelefono1").removeAttr("disabled");
                $("#TxtTelefono2").removeAttr("disabled");
                $("#TxtDieta").removeAttr("disabled");
                $("#TxtCorreo").removeAttr("disabled");
                $("#TxtUbicacion").removeAttr("disabled");
                $("#TxtObservaciones").removeAttr("disabled");

                $("#add_gridCanchas").show();
                $("#edit_gridCanchas").show();
                $("#del_gridCanchas").show();

            } else {
                $("#TxtNombre").attr("disabled", "disabled");
                $("#selCategoria").attr("disabled", "disabled");
                $("#TxtTelefono1").attr("disabled", "disabled");
                $("#TxtTelefono2").attr("disabled", "disabled");
                $("#TxtDieta").attr("disabled", "disabled");
                $("#TxtCorreo").attr("disabled", "disabled");
                $("#TxtUbicacion").attr("disabled", "disabled");
                $("#TxtObservaciones").attr("disabled", "disabled");

                $("#add_gridCanchas").hide();
                $("#edit_gridCanchas").hide();
                $("#del_gridCanchas").hide();
            }
        }

        function GuardarEditar() {
            if (ValidarCampos()) {
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "edit";
                //var oParametrosAjax = { oTorneo: _Torneo, oCanchas: _Torneo.Torneos_Canchas, oper: "edit" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridTorneos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarTorneo", "/Torneos/EditarTorneos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

        function GuardarAgregar() {
            if (ValidarCampos()) {
                CargarCampos();
                //var oParametrosAjax = { oTorneo: _Torneo, oper: "add" };
                var oParametrosAjax = CargarCampos();
                oParametrosAjax["oper"] = "add";
                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridTorneos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarTorneo", "/Torneos/EditarTorneos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

    </script>
    <div id="ventanaEditar">
        <form id="frmTorneos" action="">
        <fieldset class="Fieldset">
            <legend>Información General</legend>
            <div class="ContenidoOrdenado">
                <div class="fila">
                    <div class="celdaLabel">
                        Nombre
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNombre" name="TxtNombre" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Categoría
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorCategorias("selCategoria") %>
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Teléfono 1
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtTelefono1" name="TxtTelefono1" class="required" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Teléfono 2
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtTelefono2" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Dieta
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtDieta" name="TxtDieta" class="required number" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Correo
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtCorreo" name="TxtCorreo" type="text" class="required email" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Ubicación
                    </div>
                    <div class="">
                        <textarea id="TxtUbicacion" name="TxtUbicacion" class="required" rows="2" cols="40"></textarea>
                    </div>
                    <div class="celdaLabel">
                        Observaciones
                    </div>
                    <div class="">
                        <textarea id="TxtObservaciones" rows="2" cols="40"></textarea>
                    </div>
                </div>
            </div>
        </fieldset>
        </form>
        <br />
        <fieldset class="Fieldset">
            <legend>Canchas en las que se juega el torneo</legend>
            <table id="gridCanchas">
            </table>
            <div id="barraGridCanchas">
            </div>
        </fieldset>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
    <h1>
        Torneos</h1>
    <h1>
        <a href="/">Volver al menú principal</a></h1>
</asp:Content>
