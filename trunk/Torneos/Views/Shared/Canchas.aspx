<%@ Page Title="ACAF Canchas" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridCanchas">
    </table>
    <div id="barraGridCanchas">
    </div>
<script type='text/javascript'>
    $(document).ready(function () {

        $("#gridCanchas").jqGrid({
            url: '<%= Url.Action("ObtenerCanchas","Canchas") %>',
            datatype: "json",
            altRows: true,
            rowNum: 10,
            rowList: [10, 20, 30],
            mtype: "post",
            pager: '#barraGridCanchas',
            loadonce: true,
            viewrecords: true,
            caption: "Mantenimiento de Canchas",
            editurl: '<%= Url.Action("EditarCanchas","Canchas") %>',
            jsonReader: { repeatitems: false },
            ignoreCase: true,
            height: 250,
            width: 856,
            shrinkToFit: false,
            colNames: ['id', 'Nombre', 'Ubicacion', 'Observaciones'],
            colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'ubicacion', index: 'ubicacion', width: 300, editable: true, sortable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50" }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
        });

        var ProcesarEditar_gvCanchas = {
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

        $("#gridCanchas").jqGrid('navGrid', '#barraGridCanchas',
                 {
                     edit: true,
                     add: true,
                     del: true,
                     refresh: false,
                     search: true,
                     view: true
                 }, //options 
                 ProcesarEditar_gvCanchas, // edit options 
                 ProcesarEditar_gvCanchas, // add options 
                 Procesar_Eliminar_gvCanchas, // del options
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
<h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
