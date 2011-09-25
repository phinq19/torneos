<%@ Page Title="ACAF Torneos" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridTorneos">
    </table>
    <div id="barraGridTorneos">
    </div>
<script type='text/javascript'>
    $(document).ready(function () {

        $("#ventanaEditar").dialog({
            autoOpen: false,
            modal: true,
            title: "Torneos", 
            closeOnEscape: true,
            height: 570,
            width: 750
        });

        $("#gridCanchas").jqGrid({
            //url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
            datatype: "local",
            rowNum: 10,
            rowList: [10, 20, 30],
            mtype: "post",
            //pager: '#barraGridTorneos',
            loadonce: true,
            viewrecords: true,
            caption: "Canchas en las que se juega el torneo",
            //editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
            jsonReader: { repeatitems: false },
            ignoreCase: true,
            height: 150,
            width: 700,
            shrinkToFit: false,
            colNames: ['id', 'Cancha', 'Viáticos', 'Observaciones'],
            colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'cancha', index: 'cancha', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "3:Encargado Torneo;2:Árbitro;4:Encargado Asociación;5:Tesorero;1:Administrador" }, formatter: 'select' },
                    { name: 'viaticos', index: 'viaticos', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
            ]
        });


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
                    { name: 'categoria', index: 'tipo', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "3:Encargado Torneo;2:Árbitro;4:Encargado Asociación;5:Tesorero;1:Administrador" }, formatter: 'select' },
                    { name: 'telefono1', index: 'telefono1', width: 80, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { required: true} },
                    { name: 'telefono2', index: 'telefono2', width: 80, editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'dieta', index: 'nombre', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
        });


        $("#gridTorneos").jqGrid("navGrid", "#barraGridTorneos",
        {
            addfunc: function() {
                MostrarVentana("add");
            },
            editfunc: function(id) {
                MostrarVentana("edit");
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
                $("#ventanaEditar").dialog("option", "buttons", {
                    "Aceptar": function () { $(this).dialog("close"); },
                    "Cancelar": function () { $(this).dialog("close"); }
                });
                HabilitarCampos(true);
                break;
            case "edit":
                $("#ventanaEditar").dialog("option", "buttons", {
                    "Aceptar": function () { $(this).dialog("close"); },
                    "Cancelar": function () { $(this).dialog("close"); }
                });
                HabilitarCampos(true);
            break;
            case "view":
                $("#ventanaEditar").dialog("option", "buttons", { "Cerrar": function () { $(this).dialog("close"); } });
                HabilitarCampos(false);
            break;
        }
        $("#ventanaEditar").dialog('open');
    }

    function MostrarTorneo() {

    }

    function CargarTorneo() {

    }

    function ObtenerTorneo() {

    }

    function HabilitarCampos(bHabilitados) {

    }

    function GuardarEditar() {

    }

    function GuardarAgregar() { 
    
    }
    </script>
    <div id="ventanaEditar">
        <fieldset class="Fieldset">
            <legend>Identificación</legend>
            <div class="ContenidoOrdenado">
                <div class="fila">
                    <div class="celdaLabel">
                        Nombre
                    </div>
                    <div class="celdaCampo">
                        <input id="TxtNombre" type="text" />
                    </div>
                    <div class="celdaLabel">
                        Categoría
                    </div>
                    <div class="celdaCampo">
                        <%= Torneos.Utilidades.CrearSelectorCategorias() %>
                    </div>
                </div>
                <div class="fila">
                    <div class="celdaLabel">
                        Teléfono 1
                    </div>
                    <div class="">
                        <input id="TxtTelefono1" type="text" />
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
                        <input id="TxtDieta" type="text" />
                    </div>
                </div>
            </div>
            <div class="fila">
                <div class="celdaLabel">
                    Ubicación
                </div>
                <div class="">
                    <textarea id="TxtUbicacion" rows="2" cols="80"></textarea>
                </div>
            </div>
            <div class="fila">
                <div class="celdaLabel">
                    Observaciones
                </div>
                <div class="">
                    <textarea id="TxtObservaciones" rows="2" cols="80"></textarea>
                </div>
            </div>
        </fieldset>
        <br />
        <table id="gridCanchas">
        </table>
        <div id="barraGridCanchas">
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Torneos</h1>
</asp:Content>
