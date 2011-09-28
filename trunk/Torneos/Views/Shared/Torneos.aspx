<%@ Page Title="ACAF Torneos" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
                height: 500,
                width: 800
            });

            $("#gridCanchas").jqGrid({
                //url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
                datatype: "local",
                rowNum: 10,
                rowList: [10, 20, 30],
                mtype: "post",
                pager: '#barraGridCanchas',
                loadonce: true,
                viewrecords: true,
                caption: "Canchas en las que se juega el torneo",
                //editurl: '<%= Url.Action("EditarTorneos","Torneos") %>',
                jsonReader: { repeatitems: false },
                ignoreCase: true,
                height: 120,
                width: 775,
                shrinkToFit: false,
                colNames: ['id', 'Cancha', 'Viáticos', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'idCancha', index: 'idCancha', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorCanchasParaGrid() %>>" }, formatter: 'select' },
                    { name: 'viaticos', index: 'viaticos', width: 200, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
            ]
            });

            $("#gridCanchas").jqGrid('navGrid', '#barraGridCanchas',
            {
                edit: true,
                add: true,
                del: true,
                refresh: false,
                search: false,
                view: false
            });


            $("#gridTorneos").jqGrid({
                url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
                datatype: "json",
                rowNum: 10,
                rowList: [10, 20, 30],
                mtype: "post",
                pager: '#barraGridTorneos',
                //loadonce: true,
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
                    { name: 'categoria', index: 'tipo', width: 120, editable: true, sortable: false, editrules: { required: true }, edittype: 'select', editoptions: { value: "<%= Torneos.Utilidades.CrearSelectorCategoriasParaGrid() %>" }, formatter: 'select' },
                    { name: 'telefono1', index: 'telefono1', width: 80, editable: true, sortable: false, editoptions: { size: 20 }, editrules: { required: true} },
                    { name: 'telefono2', index: 'telefono2', width: 80, editable: true, sortable: false, editoptions: { size: 20} },
                    { name: 'dieta', index: 'nombre', width: 100, editable: true, editoptions: { size: 40 }, editrules: { required: true} },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
                ]
            });


            $("#gridTorneos").jqGrid("navGrid", "#barraGridTorneos",
        {
            addfunc: function () {
                MostrarVentana("add");
            },
            editfunc: function (id) {
                MostrarVentana("edit", id);
            },
            edit: true,
            add: true,
            del: true,
            search: true,
            refresh: false,
            view: false
        },
        { multipleSearch: true }
        );

            jQuery("#gridTorneos").jqGrid('navButtonAdd', '#barraGridTorneos',
        {
            id: "VerRegistrogvComponentes",
            caption: "",
            title: "Ver detalle",
            buttonicon: "ui-icon ui-icon-document",
            onClickButton: function () {
                var cIdView = jQuery('#gridTorneos').getGridParam("selrow");
                if (cIdView == null) {
                    alert("Seleccione una fila");
                }
                else {
                    MostrarVentana("view", cIdView);
                }
            },
            position: 'last'
        });

        });

        function MostrarVentana(accion, id) {
            switch (accion) {
                case "add":
                    Limpiar();
                    $("#ventanaEditar").dialog("option", "buttons", {
                        "Aceptar": function () { GuardarAgregar(); },
                        "Cancelar": function () { $(this).dialog("close"); }
                    });
                    HabilitarCampos(true);
                    $("#ventanaEditar").dialog('open');
                    break;
                case "edit":
                    Limpiar();
                    $("#ventanaEditar").dialog("option", "buttons", {
                        "Aceptar": function () { GuardarEditar(); },
                        "Cancelar": function () { $(this).dialog("close"); }
                    });
                    ObtenerTorneo(id);
                    HabilitarCampos(true);
                    $("#ventanaEditar").dialog('open');
                    break;
                case "view":
                    Limpiar();
                    ObtenerTorneo(id);
                    HabilitarCampos(false);
                    $("#ventanaEditar").dialog("option", "buttons", { "Cerrar": function () { $(this).dialog("close"); } });
                    $("#ventanaEditar").dialog('open');
                    
                    break;
            }
            
        }

        var _Torneo = {
            Torneos_Canchas: []
        };

        function MostrarTorneo(oTorneo) {
            _Torneo = oTorneo;

            $("#TxtNombre").val(oTorneo.nombre);
            $("#selCategoria").val(oTorneo.categoria);
            $("#TxtTelefono1").val(oTorneo.telefono1);
            $("#TxtTelefono2").val(oTorneo.telefono2);
            $("#TxtDieta").val(oTorneo.dieta);
            $("#TxtUbicacion").val(oTorneo.ubicacion);
            $("#TxtObservaciones").val(oTorneo.observaciones);

            $('#gridCanchas').clearGridData();
            $('#gridCanchas').setGridParam({ data: oTorneo.Torneos_Canchas }).trigger('reloadGrid');
        }

        function CargarCampos() {
            _Torneo.nombre = $("#TxtNombre").val();
            _Torneo.categoria = $("#selCategoria").val();
            _Torneo.telefono1 = $("#TxtTelefono1").val();
            _Torneo.telefono2 = $("#TxtTelefono2").val();
            _Torneo.dieta = $("#TxtDieta").val();
            _Torneo.ubicacion = $("#TxtUbicacion").val();
            _Torneo.observaciones = $("#TxtObservaciones").val();
        }

        function Limpiar() {
            $("#TxtNombre").val("");
            $("#selCategoria").val("");
            $("#TxtTelefono1").val("");
            $("#TxtTelefono2").val("");
            $("#TxtDieta").val("");
            $("#TxtUbicacion").val("");
            $("#TxtObservaciones").val("");

            $('#gridCanchas').clearGridData();
        }

        function ObtenerTorneo(idTorneo) {
            var oParametrosAjax = { cID: idTorneo };

            var funcionProcesamientoCliente = function (oRespuesta) {
                MostrarTorneo(oRespuesta.oTorneo);
            }

            RealizarPeticionAjax("ObtenerTorneo", "/Torneos/ObtenerTorneoPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
        }

        function ValidarCampos() {
            return true;   
        }


        function HabilitarCampos(bHabilitar) {
            if (bHabilitar) {
                $("#TxtNombre").removeAttr("disabled");
                $("#selCategoria").removeAttr("disabled");
                $("#TxtTelefono1").removeAttr("disabled");
                $("#TxtTelefono2").removeAttr("disabled");
                $("#TxtDieta").removeAttr("disabled");
                $("#TxtUbicacion").removeAttr("disabled");
                $("#TxtObservaciones").removeAttr("disabled");

                $("#add_gridCanchas").show();
                $("#edit_gridCanchas").show();
                $("#del_gridCanchas").show();

            } else {
                $("#TxtNombre").attr("disabled", "disabled");
                $("#selCategoria").attr("disabled", "disabled");
                $("#TxtTelefono1").attr("disabled", "disabled");
                $("#TxtTelefono2").attr("disabled", "disabled");
                $("#TxtDieta").attr("disabled", "disabled");
                $("#TxtUbicacion").attr("disabled", "disabled");
                $("#TxtObservaciones").attr("disabled", "disabled");

                $("#add_gridCanchas").hide();
                $("#edit_gridCanchas").hide();
                $("#del_gridCanchas").hide();
            }
        }

        function GuardarEditar() {
            if (ValidarCampos()) {
                CargarCampos();
                var oParametrosAjax = { oTorneo: _Torneo, oper: "edit" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridTorneos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }
                
                RealizarPeticionAjax("GuardarTorneo", "/Torneos/EditarTorneos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
        }

        function GuardarAgregar() {
            if (ValidarCampos()) {
                CargarCampos();
                var oParametrosAjax = { oTorneo: _Torneo, oper: "add" };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    $("#gridTorneos").trigger('reloadGrid');
                    $("#ventanaEditar").dialog("close");
                }

                RealizarPeticionAjax("GuardarTorneo", "/Torneos/EditarTorneos", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }
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
                        <%= Torneos.Utilidades.CrearSelectorCategorias("selCategoria") %>
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
                <div class="fila">
                    <div class="celdaLabel">
                        Ubicación
                    </div>
                    <div class="">
                        <textarea id="TxtUbicacion" rows="2" cols="40"></textarea>
                    </div>
                    <div class="celdaLabel">
                        Observaciones
                    </div>
                    <div class="">
                        <textarea id="TxtObservaciones" rows="2" cols="40"></textarea>
                    </div>
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
