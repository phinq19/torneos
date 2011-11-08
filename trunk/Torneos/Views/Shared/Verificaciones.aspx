<%@ Page Title="ACAF Verificaciones" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <fieldset class="Fieldset">
    <legend>Filtro</legend>
        <div class="ContenidoOrdenado">
            <div class="fila">
                <div class="columna">
                    Estado de la programación
                </div>
                <div class="celdaCampo">
                    <%= Torneos.Utilidades.CrearSelectorEstadosProgramaciones("selEstado") %>
                </div>
            </div>
        </div>
    </fieldset>
    <br />
    <table id="gridVerificaciones">
    </table>
    <div id="barraGridVerificaciones">
    </div>

    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $("#selEstado").change(function () {
                var postData = jQuery("#gridVerificaciones").getGridParam("postData");
                postData.estado = $("#selEstado").val();
                jQuery("#gridVerificaciones").setGridParam("postData", postData);
                jQuery("#gridVerificaciones").trigger("reloadGrid");
            });

            $("#gridVerificaciones").jqGrid({
                url: '<%= Url.Action("ObtenerProgramaciones","Verificaciones") %>',
                postData: { estado: $("#selEstado").val() },
                datatype: "json",
                pager: '#barraGridVerificaciones',
                editurl: '<%= Url.Action("EditarProgramaciones","Verificaciones") %>',
                colNames: ['id', 'Número', 'Torneo', 'Estado', 'Números Depósitos', 'Monto depositado', 'Monto Calculado', 'Observaciones del Cliente', 'Observaciones Asociación'],
                colModel: [
                        { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                        { name: 'numero', index: 'numero', width: 100, editable: false },
                        { name: 'idTorneo', index: 'idTorneo', width: 250, editable: false, editoptions: { size: 40 }, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorTorneosParaGrid() %>' }, formatter: 'select' },
                        { name: 'estado', index: 'estado', width: 100, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorEstadoProgramacionesParaGrid() %>' }, formatter: 'select' },
                        { name: 'deposito', index: 'deposito', width: 200, editable: false, sortable: false, editrules: { required: true} },
                        { name: 'monto', index: 'monto', width: 100, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                        { name: 'montoCalculado', index: 'montoCalculado', width: 100, editable: false, editoptions: { size: 40 }, editrules: { required: true} },
                        { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50"} },
                        { name: 'observacionesAsoc', index: 'observacionesAsoc', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                    ]
            });

            var ProcesarEditar_gvVerificaciones = {
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

            $("#gridVerificaciones").jqGrid('navGrid', '#barraGridVerificaciones',
                        {
                            edit: true,
                            add: false,
                            del: false,
                            refresh: true,
                            search: false,
                            view: true
                        }, //options 
            ProcesarEditar_gvVerificaciones, // edit options 
            ProcesarEditar_gvVerificaciones, // add options 
            {}, // del options
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
    <h1>Verificar Programaciones</h1>
    <h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
