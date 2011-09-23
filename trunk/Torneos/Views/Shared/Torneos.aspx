<%@ Page Title="ACAF Torneos" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridTorneos">
    </table>
    <div id="barraGridTorneos">
    </div>
<script type='text/javascript'>
    $(document).ready(function () {


        $("#ventanaEditar").dialog({ autoOpen: false });


        $("#gridTorneos").jqGrid({
            url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
            datatype: "local",
            rowNum: 10,
            rowList: [10, 20, 30],
            mtype: "post",
            pager: '#barraGridTorneos',
            loadonce: true,
            viewrecords: true,
            caption: "Mantenimiento de Torneos",
            editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
            jsonReader: { repeatitems: false },
            ignoreCase: true,
            height: 250,
            width: 850,
            shrinkToFit: false,
            colNames: ['id', 'Nombre', 'Ubicacion', 'Observaciones'],
            colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'nombre', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'ubicacion', index: 'ubicacion', width: 300, editable: true, sortable: false, edittype: "textarea", editoptions: { rows: "2", cols: "50" }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
        });


        $("#gridTorneos").jqGrid("navGrid", "#barraGridTorneos",
        {
            addfunc: function() {
                MostrarVentana("view");
            },
            editfunc: function(id) {
                MostrarVentana("view");
            },
            edit: true,
            add: true,
            del: true,
            search: true,
            refresh: false,
            view: false
        },
        {multipleSearch:true}
        );

        jQuery("#gridTorneos").jqGrid('navButtonAdd', '#barraGridTorneos',
        {
            id: "VerRegistrogvComponentes",
            caption: "",
            title: "Ver detalle",
            buttonicon: "ui-icon ui-icon-document",
            onClickButton: function () {
                MostrarVentana("view");
            },
            position: 'last'
        });
        
    });

    function MostrarVentana(accion, id){
        switch(accion){
            case "add":
            break;
            case "edit":
            break;
            case "view":
            break;
        }
        $("#ventanaEditar").dialog('open');
    }
    </script>

    <div id="ventanaEditar">
        
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Torneos</h1>
</asp:Content>
