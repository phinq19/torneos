<%@ Page Title="Asociacion Solicitudes" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridSolicitudes">
    </table>
    <div id="barraGridSolicitudes">
    </div>
<script type='text/javascript'>
    $(document).ready(function () {



        $("#gridSolicitudes").jqGrid({
            url: '<%= Url.Action("ObtenerCanchas","Canchas") %>',
            datatype: "local",
            pager: '#barraGridSolicitudes',
            //editurl: '<%= Url.Action("EditarCanchas","Canchas") %>',
            colNames: ['id', 'Documento', 'Fecha', 'Monto Solicitado',  'Línea Credito', 'Estado', 'Cuota', 'Plazo (meses)', 'Interes', 'Observaciones'],
            colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'numero', index: 'numero', width: 120, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'fecha', index: 'fecha', width: 120, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'montoSolicitado', index: 'montoSolicitado', width: 120, editable: true, sortable: false, editoptions: { size: 30} },
                    { name: 'idLinea', index: 'idLinea', editable: true, width: 200, edittype: 'select', editoptions: { value: "1:Crédito Vivienda;2:Crédito Vehículo;3:Crédito Rapidito" }, formatter: 'select' },
                    { name: 'estado', index: 'estado', editable: false, width: 120, edittype: 'select', editoptions: { value: "1:Pendiente;2:Aprovada;3:Rechazada" }, formatter: 'select' },
                    { name: 'cuota', index: 'cuota', width: 120, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'plazo', index: 'plazo', width: 120, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'interes', index: 'interes', width: 120, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
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

        $("#gridSolicitudes").jqGrid('navGrid', '#barraGridSolicitudes',
                 {
                     edit: false,
                     add: true,
                     del: true,
                     refresh: true,
                     search: false,
                     view: true
                 }, //options 
                 ProcesarEditar_gvCanchas, // edit options 
                 ProcesarEditar_gvCanchas, // add options 
                 Procesar_Eliminar_gvCanchas, // del options
                 {}, // search options 
                 {width: "500" }
            );


        var Solicitud1 = {
            id: "1",
            numero: "SLT000001",
            fecha: "05/05/2011",
            estado: "2",
            idLinea: 1,
            montoSolicitado: "20000000",
            cuota: "80000",
            plazo: "60",
            interes: "0.14",
            observaciones: "Solicitud de préstamo para vivienda"
        };

        var Solicitud2 = {
            id: "2",
            numero: "SLT000002",
            fecha: "08/03/2011",
            estado: "3",
            idLinea: 2,
            montoSolicitado: "4500000",
            cuota: "120000",
            plazo: "48",
            interes: "0.18",
            observaciones: "Solicitud de préstamo para vehículo"
        };

        var Solicitud3 = {
            id: "3",
            numero: "SLT000003",
            fecha: "08/03/2011",
            estado: "1",
            idLinea: 2,
            montoSolicitado: "4500000",
            cuota: "900000",
            plazo: "60",
            interes: "0.18",
            observaciones: "Solicitud de préstamo para vehículo"
        };

        var _Solicitudes = [Solicitud1, Solicitud2, Solicitud3];

        $('#gridSolicitudes').clearGridData();
        $('#gridSolicitudes').setGridParam({ data: _Solicitudes }).trigger('reloadGrid');

    });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Solicitudes</h1>
<h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
