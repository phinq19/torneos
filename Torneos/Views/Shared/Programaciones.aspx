<%@ Page Title="ACAF Programaciones" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master"
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
                title: "Programaciones",
                //closeOnEscape: true,
                height: 550,
                width: 800
            });

            $("#gridPartidos").jqGrid({
                //url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
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
                colNames: ['id', 'Cancha', 'Viáticos', 'Observaciones', 'accionregistro'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'idCancha', index: 'idCancha', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorTorneosCanchasParaGrid() %>" }, formatter: 'select' },
                    { name: 'viaticos', index: 'viaticos', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
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
                //editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
                jsonReader: { repeatitems: false },
                ignoreCase: true,
                height: 250,
                width: 850,
                shrinkToFit: false,
                colNames: ['id', 'Nombre', 'Ubicacion', 'Categoría', 'Teléfono 1', 'Teléfono 2', 'Dieta', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'ubicacion', index: 'ubicacion', width: 300, editable: true, sortable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50" }, editrules: { required: true} },
                    { name: 'categoria', index: 'tipo', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorCategoriasParaGrid() %>" }, formatter: 'select' },
                    { name: 'telefono1', index: 'telefono1', width: 80, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { required: true} },
                    { name: 'telefono2', index: 'telefono2', width: 80, editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'dieta', index: 'nombre', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
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
                    oRegistros.splice(_Programacion.Partidos[indiceRegistro], 1);
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

        function MostrarTorneo(oTorneo) {
            _Programacion = oTorneo;

            $("#TxtNombre").val(oTorneo.nombre);
            $("#selCategoria").val(oTorneo.categoria);
            $("#TxtTelefono1").val(oTorneo.telefono1);
            $("#TxtTelefono2").val(oTorneo.telefono2);
            $("#TxtDieta").val(oTorneo.dieta);
            $("#TxtUbicacion").val(oTorneo.ubicacion);
            $("#TxtObservaciones").val(oTorneo.observaciones);

            $('#gridPartidos').clearGridData();
            $('#gridPartidos').setGridParam({ data: oTorneo.Partidos }).trigger('reloadGrid');
        }

        function CargarCampos() {
            var Entidad = {};
            var oProgramacion = {};
            var oPartidos = [];
            /*
            _Programacion.nombre = $("#TxtNombre").val();
            _Programacion.categoria = $("#selCategoria").val();
            _Programacion.telefono1 = $("#TxtTelefono1").val();
            _Programacion.telefono2 = $("#TxtTelefono2").val();
            _Programacion.dieta = $("#TxtDieta").val();
            _Programacion.ubicacion = $("#TxtUbicacion").val();
            _Programacion.observaciones = $("#TxtObservaciones").val();
            */
            oProgramacion.nombre = $("#TxtNombre").val();
            oProgramacion.categoria = $("#selCategoria").val();
            oProgramacion.telefono1 = $("#TxtTelefono1").val();
            oProgramacion.telefono2 = $("#TxtTelefono2").val();
            oProgramacion.dieta = $("#TxtDieta").val();
            oProgramacion.ubicacion = $("#TxtUbicacion").val();
            oProgramacion.observaciones = $("#TxtObservaciones").val();
            oProgramacion.idAsociacion = _Programacion.idAsociacion;
            oProgramacion.id = _Programacion.id;
            for (var i = 0; i < _Programacion.Partidos.length; i++) {
                var oPartido = {};
                oPartido.id = _Programacion.Partidos[i].id;
                oPartido.viaticos = _Programacion.Partidos[i].viaticos.toString();
                oPartido.idCancha = _Programacion.Partidos[i].idCancha;
                oPartido.observaciones = _Programacion.Partidos[i].observaciones;
                oPartido.idTorneo = _Programacion.Partidos[i].idTorneo;
                oPartido.accionregistro = _Programacion.Partidos[i].accionregistro;

                Partidos.push(oCancha);

            }
            Entidad["oProgramacion"] = oTorneo;
            Entidad["oPartidos"] = oCanchas;
            return Entidad;
            
        }

        function Limpiar() {
            _Programacion = {
                Partidos: []
            };
            
            $("#TxtNombre").val("");
            $("#selCategoria").val("");
            $("#TxtTelefono1").val("");
            $("#TxtTelefono2").val("");
            $("#TxtDieta").val("");
            $("#TxtUbicacion").val("");
            $("#TxtObservaciones").val("");

            $('#gridPartidos').clearGridData();
        }

        function ObtenerProgramacion(idTorneo) {
            var oParametrosAjax = { cID: idTorneo };

            var funcionProcesamientoCliente = function (oRespuesta) {
                MostrarTorneo(oRespuesta.oTorneo);
            }

            RealizarPeticionAjax("ObtenerTorneo", "/Torneos/ObtenerProgramacionPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
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
                $("#TxtNombre").removeAttr("disabled");
                $("#selCategoria").removeAttr("disabled");
                $("#TxtTelefono1").removeAttr("disabled");
                $("#TxtTelefono2").removeAttr("disabled");
                $("#TxtDieta").removeAttr("disabled");
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
                //var oParametrosAjax = { oTorneo: _Programacion, oCanchas: _Programacion.Partidos, oper: "edit" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridProgramaciones").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarProgramaciones", "/Programaciones/EditarProgramacioness", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

        function GuardarAgregar() {
            if (ValidarCampos()) {
                CargarCampos();
                //var oParametrosAjax = { oTorneo: _Programacion, oper: "add" };
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
                        Nombre
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNombre" class="required" type="text" />
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
                        <input id="TxtTelefono1" class="required" type="text" />
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
                        <input id="TxtDieta" class="required" type="text" />
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Ubicación
                    </div>
                    <div class="">
                        <textarea id="TxtUbicacion" class="required" rows="2" cols="40"></textarea>
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
