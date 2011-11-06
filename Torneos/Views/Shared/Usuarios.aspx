<%@ Page Title="ACAF Usuarios" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <div id="gridUsuarios_DIV">
    <table id="gridUsuarios">
    </table>
    <div id="barraGridUsuarios">
    </div>
    </div>
    <script type='text/javascript'>
        $(document).ready(function () {
            function validarCedula(value, colname) {
                if (value.indexOf(" ") != -1) {
                    return [false, "Por favor ingrese un valor para la cedula sin espacios en blanco"];
                }
                else {
                    return [true, ""];
                }
            }

            $("#gridUsuarios").jqGrid({
                url: "/Usuarios/ObtenerUsuarios", //'<%= Url.Action("ObtenerUsuarios","Usuarios") %>',
                datatype: "json",
                pager: "#barraGridUsuarios",
                editurl: "/Usuarios/EditarUsuarios", //'<%= Url.Action("EditarUsuarios","Usuarios") %>',
                colNames: ['id', 'Nombre', 'Cédula', 'Tipo', 'Torneo', 'Correo', 'Teléfono', 'Cuenta Bancaria', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'cedula', index: 'cedula', width: 80, editable: true, editoptions: { size: 20 }, editrules: { required: true, custom: true, custom_func: validarCedula} },
                    { name: 'tipo', index: 'tipo', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorTiposUsuarioParaGrid() %>" }, formatter: 'select' },
                    { name: 'idTorneo', index: 'idTorneo', width: 200, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorTorneosParaGrid() %>" }, formatter: 'select' },
                    { name: 'correo', index: 'correo', width: 120, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { required: true, email: true} },
                    { name: 'telefono1', index: 'telefono1', width: 80, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { required: true} },
                    { name: 'cuenta', index: 'cuenta', width: 120, editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'observaciones', index: 'observaciones', width: 200, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
            });

            
            var ProcesarEditar_gvUsuarios = {
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
                                    if (datos.ObjetoDetalle.idTorneo == null && datos.ObjetoDetalle.tipo.toString() == "1") {
                                        return [false, "Los Usuarios que son encargados de Torneo, deben de tener un Torneo asignado", "-1"];
                                    }
                                    return [true, '', datos.ObjetoDetalle.id];
                                    break;
                                case "error":
                                    return [false, datos.mensaje, '-1'];
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
                            return [false, datos.mensaje, '-1'];
                            break;
                    }
                }
            };

            var Procesar_Eliminar_gvUsuarios = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                //reloadAfterSubmit: true,
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
                                    return [true, '', datos.ObjetoDetalle.id];
                                    break;
                                case "error":
                                    return [false, datos.mensaje, '-1'];
                                    break;
                                case "sinAutenticar":
                                    window.location = "/";
                                    break;
                            }
                            break;
                        case "error":
                            return [false, datos.mensaje, '-1'];
                            break;
                    }
                }
            };

            $("#gridUsuarios").jqGrid('navGrid', '#barraGridUsuarios',
            {
                edit: true,
                add: true,
                del: true,
                refresh: false,
                search: false,
                view: true
            }, //options 
            ProcesarEditar_gvUsuarios, // edit options 
            ProcesarEditar_gvUsuarios, // add options 
            Procesar_Eliminar_gvUsuarios, // del options
            {}, // search options 
            {width: "500" }
            );

            //CargarDatos();

        });

        /*function CargarDatos() {
            var funcionProcesamientoCliente = function (oRespuesta) {
                $("#gridUsuarios").setGridParam({ data: oRespuesta.rows }).trigger('reloadGrid');
            }

            RealizarPeticionAjax("gridUsuarios", '<%= Url.Action("ObtenerUsuarios","Usuarios") %>', {}, true, true, "gridUsuarios_DIV", funcionProcesamientoCliente);
        }*/
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Usuarios</h1>
<h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
