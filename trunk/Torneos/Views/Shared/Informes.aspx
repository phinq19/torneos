<%@ Page Title="ACAF Informes" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    
    <fieldset class="Fieldset">
    <legend>Filtro</legend>
        <div class="ContenidoOrdenado">
            <div class="fila">
                <div class="columna">
                    Estado de la partido
                </div>
                <div class="celdaCampo">
                    <select id="selEstado">
                        <option value="1">Pendiente_De_Informe</option>
                        <option value="2">Con_Informe</option>
                    </select>
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


            $("#gridPartidos").jqGrid({
                url: '<%= Url.Action("ObtenerPartidos", "Informes")%>',
                datatype: "json",
                postData: { estado: $("#selEstado").val() },
                pager: '#barraGridPartidos',
                editurl: '<%= Url.Action("EditarDisponibilidad","Informes") %>',
                colNames: ['id', 'Torneo','Programación', 'Partido', 'Equipo Local', 'Equipo Visita', 'Cancha', 'Tipo Partido', 'Fecha', 'Hora', 'Estados', 'Observaciones', 'Informe'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 100, editable: true, editoptions: { disabled: true, size: 20} },
                    { name: 'numeroProgramacion', index: 'numeroProgramacion', width: 100, editable: true, editoptions: { disabled: true, size: 20} },
                    { name: 'numero', index: 'numero', width: 100, editable: true, editoptions: { disabled: true, size: 20} },
                    { name: 'equipoLocal', index: 'equipoLocal', width: 150, editable: true, editoptions: { disabled: true, size: 40} },
                    { name: 'equipoVisita', index: 'equipoVisita', width: 150, editable: true, editoptions: { disabled: true, size: 40} },
                    { name: 'idCancha', index: 'idCancha', width: 120, editable: true, sortable: false, edittype: 'select', editoptions: { disabled: true, value: '<%= Torneos.Utilidades.CrearSelectorCanchasParaGrid() %>' }, formatter: 'select' },
                    { name: 'tipo', index: 'tipo', width: 120, editable: true, sortable: false, edittype: 'select', editoptions: { disabled: true, value: '<%= Torneos.Utilidades.CrearSelectorTiposPartidoParaGrid() %>' }, formatter: 'select' },
                    { name: 'fecha', index: 'fecha', datefmt: 'd/m/y', width: 120, editable: true, editoptions: { disabled: true, size: 40 }, sorttype: "date", formatter: "fechaFmatter" },
                    { name: 'hora', index: 'hora', width: 120, editable: true, editoptions: { readonly: true, size: 40 }, formatter: "time" },
                    { name: 'estado', index: 'estado', width: 150, editable: false, sortable: false, edittype: 'select', editoptions: { disabled: true, value: '<%= Torneos.Utilidades.CrearSelectorEstadoPartidosParaGrid() %>' }, formatter: 'select' },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: false, edittype: "textarea", editoptions: { disabled: true, rows: "2", cols: "50"} },
                    { name: 'informe', index: 'informe', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "50", cols: "120"} },
                ]
            });

            var ProcesarEditar_gvPartidos = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "800",
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

            var Procesar_Eliminar_gvPartidos = {
                closeAfterAdd: true,
                closeAfterEdit: true,
                closeOnEscape: true,
                reloadAfterSubmit: false,
                modal: false,
                width: "800",
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
                add: false,
                del: false,
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
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
    <h1>Informes</h1>
    <h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
