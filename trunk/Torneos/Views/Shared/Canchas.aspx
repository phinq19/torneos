<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridCanchas">
    </table>
    <div id="barraGridCanchas">
    </div>
<script type='text/javascript'>
    $(document).ready(function () {
        /*
        function validarCodigo(value, colname) {
            if (value.indexOf(" ") != -1) {
                return [false, "Por favor ingrese un valor para el código sin espacios en blanco"];
            }
            else {
                return [true, ""];
            }
        }*/

        $("#gridCanchas").jqGrid({
            url: '<%= Url.Action("ObtenerCanchas","Canchas") %>',
            datatype: "json",
            rowNum: 10,
            rowList: [10, 20, 30],
            mtype: "post",
            pager: '#barraGridUsuarios',
            loadonce: true,
            viewrecords: true,
            caption: "Mantenimiento de Usuarios",
            editurl: '<%= Url.Action("EditarCanchas","Canchas") %>',
            jsonReader: { repeatitems: false },
            ignoreCase: true,
            height: 250,
            width: 830,
            shrinkToFit: false,
            colNames: ['id', 'Nombre', 'Ubicacion', 'Observaciones'],
            colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'ubicacion', index: 'ubicacion', width: 80, align: "right", editable: true, sortable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50"} },
                    { name: 'observaciones', index: 'observaciones', width: 200, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
        });


        var ProcesarAgregar_gvUsuarios = {
            closeAfterAdd: true,
            closeAfterEdit: true,
            closeOnEscape: true,
            reloadAfterSubmit: true,
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

        var ProcesarEditar_gvUsuarios = {
            closeAfterAdd: true,
            closeAfterEdit: true,
            closeOnEscape: true,
            reloadAfterSubmit: true,
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

        var Procesar_Eliminar_gvUsuarios = {
            closeAfterAdd: true,
            closeAfterEdit: true,
            closeOnEscape: true,
            reloadAfterSubmit: true,
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

        $("#gridUsuarios").jqGrid('navGrid', '#barraGridUsuarios',
                 {
                     afterRefresh: function () {
                         //$("#gridUsuarios").setGridParam({ loadonce: false }).trigger('reloadGrid');
                         //$("#gridUsuarios").setGridParam({ loadonce: true })
                     },
                     edit: true,
                     add: true,
                     del: true,
                     refresh: true,
                     search: true,
                     view: true
                 }, //options 
                 ProcesarEditar_gvUsuarios, // edit options 
                 ProcesarAgregar_gvUsuarios, // add options 
                 Procesar_Eliminar_gvUsuarios, // del options
                 {}, // search options 
                 {width: "500" }
            );
    });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Canchas</h1>
</asp:Content>
