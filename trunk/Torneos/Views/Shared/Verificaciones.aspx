<%@ Page Title="ACAF Verificaciones" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <fieldset class="Fieldset">
    <legend>Filtro</legend>
        <div class="ContenidoOrdenado">
            <div class="fila">
                <div class="celdaLabel">
                    Estado
                </div>
                <div class="celdaCampo">
                    <%= Torneos.Utilidades.CrearSelectorEstadosProgramaciones("selEstado") %>
                </div>
            </div>
        </div>
    </fieldset>
    <br />
    <table id="gridProgramaciones">
    </table>
    <div id="barraGridProgramaciones">
    </div>

    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $("#selEstado").change(function () {
                var postData = jQuery("#gridProgramaciones").getGridParam("postData");
                postData.estado = $("#selEstado").val();
                jQuery("#gridProgramaciones").setGridParam("postData", postData);
                jQuery("#gridProgramaciones").trigger("reloadGrid");
            });

            $("#gridProgramaciones").jqGrid({
                url: '<%= Url.Action("ObtenerProgramaciones","Programaciones") %>',
                postData: { estado: $("#selEstado").val() },
                datatype: "json",
                rowNum: 10,
                rowList: [10, 20, 30],
                mtype: "post",
                pager: '#barraGridProgramaciones',
                //loadonce: true,
                viewrecords: true,
                caption: "",
                //editurl: '<%= Url.Action("EditarProgramacions","Programacions") %>',
                jsonReader: { repeatitems: false },
                ignoreCase: true,
                height: 250,
                width: 856,
                altRows: true,
                shrinkToFit: false,
                colNames: ['id', 'Número', 'Torneo', 'Estado', 'Números Depósitos', 'Monto', 'Observaciones'],
                colModel: [
                        { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                        { name: 'numero', index: 'numero', width: 100, editable: true, editoptions: { readonly: true, size: 10} },
                        { name: 'idTorneo', index: 'idTorneo', width: 250, editable: true, editoptions: { size: 40 }, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorTorneosParaGrid() %>' }, formatter: 'select' },
                        { name: 'estado', index: 'estado', width: 100, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: '<%= Torneos.Utilidades.CrearSelectorEstadoProgramacionesParaGrid() %>' }, formatter: 'select' },
                        { name: 'deposito', index: 'deposito', width: 200, editable: true, sortable: false, editrules: { required: true} },
                        { name: 'monto', index: 'monto', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                        { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                    ]
            });

            $("#gridProgramaciones").jqGrid('navGrid', '#barraGridProgramaciones',
                        {
                            edit: true,
                            add: true,
                            del: true,
                            refresh: true,
                            search: true,
                            view: true
                        });
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
