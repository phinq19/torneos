<%@ Page Title="ACAF Usuarios" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridUsuarios">
    </table>
    <div id="barraGridUsuarios">
    </div>
    <script type='text/javascript'>
        //$(document).ready(function () {
            
            $("#gridUsuarios").jqGrid({
                url: '<%= Url.Action("ObtenerUsuarios","Usuarios") %>',
                datatype: "json",
                rowNum: 10,
                rowList: [10, 20, 30],
                mtype: "post",
                pager: '#barraGridUsuarios',
                //sortname: 'id',
                loadonce: true,
                viewrecords: true,
                //sortorder: "desc",
                caption: "Mantenimiento de Usuarios",
                editurl: '<%= Url.Action("EditarUsuarios","Usuarios") %>',
                jsonReader: { repeatitems: false },
                colNames: ['id', 'nombre', 'codigo', 'cuenta', 'telefono1', 'telefono1', 'correo', 'observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10}, key:true, hidden:true },
                    { name: 'nombre', index: 'nombre',  width: 100, editable: true, editoptions: { size: 40} },
                    { name: 'codigo', index: 'codigo',  width: 80, editable: true, editoptions: { size: 20} },
                    { name: 'cuenta', index: 'cuenta',  width: 80, align: "right", editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'telefono1', index: 'telefono1', width: 80, align: "right", editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'telefono2', index: 'telefono2', width: 80, align: "right", editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'correo', index: 'correo',  width: 120, align: "right", editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'observaciones', index: 'observaciones', width: 200, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "20"} }
                ]
            });

            $("#gridUsuarios").jqGrid('navGrid', '#barraGridUsuarios',
                 { edit: true, add: true, del: true, refresh: true, search: true, view: true }, //options 
                 {height: 280, reloadAfterSubmit: false }, // edit options 
                 {height: 280, reloadAfterSubmit: false }, // add options 
                 {reloadAfterSubmit: false }, // del options
                 {} // search options 
            );
        //});
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
Usuarios <a href=""/">Vover al menú principal</a>    
</asp:Content>
