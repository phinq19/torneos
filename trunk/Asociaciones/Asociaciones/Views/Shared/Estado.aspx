<%@ Page Title="Asociación Estado" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <table id="gridTorneos">
    </table>
    <div id="barraGridTorneos">
    </div>
    <script type='text/javascript'>
        $(document).ready(function () {
            
            
            $("#frmTorneos").validate();

            $("#tabs").tabs();

            $("#gridOperacionesCredito").jqGrid({
                //url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
                datatype: "local",
                loadonce: true,
                pager: '#barragridOperacionesCredito',
                height: 120,
                width: 836,
                colNames: ['id', 'Documento', 'Fecha', 'Principal', 'Saldo', 'Tipo', 'Cuota', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'documento', index: 'documento', width: 120 },
                    { name: 'fecha', index: 'fecha', width: 100 },
                    { name: 'montoPrincipal', index: 'montoPrincipal', width: 120 },
                    { name: 'saldoActual', index: 'saldoActual', width: 55 },
                    { name: 'tipo', index: 'tipo', width: 200, edittype: 'select', editoptions: { value: "1:Crédito Vivienda;2:Crédito Vehículo;3:Crédito Rapidito" }, formatter: 'select' },
                    { name: 'cuota', index: 'cuota', width: 55 },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
            ]
            });


            $("#gridOperacionesAhorro").jqGrid({
                //url: '<%= Url.Action("ObtenerTorneos","Torneos") %>',
                datatype: "local",
                loadonce: true,
                pager: '#barragridOperacionesAhorro',
                height: 120,
                width: 836,
                colNames: ['id', 'Documento', 'Fecha', 'Principal', 'Tipo', 'Cuota', 'Observaciones'],
                colModel: [
                    { name: 'id', index: 'id', width: 55, editable: false, editoptions: { readonly: true, size: 10 }, key: true, hidden: true },
                    { name: 'documento', index: 'documento', width: 120 },
                    { name: 'fecha', index: 'fecha', width: 100 },
                    { name: 'montoPrincipal', index: 'montoPrincipal', width: 120 },
                    { name: 'tipo', index: 'tipo', width: 120, edittype: 'select', editoptions: { value: "1:Navideño;2:Personal;3:Plan de viaje" }, formatter: 'select' },
                    { name: 'cuota', index: 'cuota', width: 55 },
                    { name: 'observaciones', index: 'observaciones', width: 300, sortable: false, editable: true, edittype: "textarea", editoptions: { rows: "2", cols: "50"} }
            ]
            });

            $("#gridOperacionesCredito").jqGrid('navGrid', '#barragridOperacionesCredito',
            {
                edit: false,
                add: false,
                del: false,
                refresh: false,
                search: false,
                view: true
            }, //options 
                 {}, // edit options 
                 {}, // add options 
                 {}, // del options
                 {}, // search options 
                 {width: "600" }
            );

            $("#gridOperacionesAhorro").jqGrid('navGrid', '#barragridOperacionesAhorro',
            {
                edit: false,
                add: false,
                del: false,
                refresh: false,
                search: false,
                view: true
            }, //options 
                 {}, // edit options 
                 {}, // add options 
                 {}, // del options
                 {}, // search options 
                 {width: "600" }
            );

            var OperacionCredito1 = {
                id: "1",
                documento: "PRT000001",
                fecha: "05/05/2011",
                montoPrincipal: "1200000",
                saldoActual: "800000",
                tipo: "1",
                cuota: "50000",
                observaciones: "Préstamo aprobado para vivienda"
            };

            var OperacionCredito2 = {
                id: "2",
                documento: "PRT000002",
                fecha: "08/03/2011",
                montoPrincipal: "400000",
                saldoActual: "300000",
                tipo: "2",
                cuota: "38000",
                observaciones: "Préstamo aprobado para vehículo"
            };

            var OperacionCredito3 = {
                id: "3",
                documento: "PRT000043",
                fecha: "24/07/2011",
                montoPrincipal: "5000",
                saldoActual: "5000",
                tipo: "3",
                cuota: "5000",
                observaciones: "Cobrar la proxima quincena"
            };

            var OperacionAhorro1 = {
                id: "1",
                documento: "AHR000003",
                fecha: "01/01/2011",
                montoPrincipal: "400000",
                tipo: "1",
                cuota: "38000",
                observaciones: "Ahorro navideño"
            };

            var OperacionAhorro2 = {
                id: "2",
                documento: "AHR000001",
                fecha: "07/09/2011",
                montoPrincipal: "400000",
                tipo: "3",
                cuota: "38000",
                observaciones: "Ahorro para costear plan de vieje a san andrés"
            };

            

            var _Estado = {
                nombre: "Abel Ramírez H.",
                cedula: "113040765",
                salarioNeto: "3500000",
                salarioBruto: "380000",
                disponileAhorros: "120000",
                OperacionesCredito: [OperacionCredito1, OperacionCredito2, OperacionCredito3],
                OperacionesAhorro: [OperacionAhorro1, OperacionAhorro2]
            };


            Limpiar();
            DeshabilitarCampos();
            MostrarEstado(_Estado);

        });  


            function MostrarEstado(oEstado) {

                $("#TxtNombre").val(oEstado.nombre);
                $("#TxtCedula").val(oEstado.cedula);
                $("#TxtSalarioNeto").val(oEstado.salarioNeto);
                $("#TxtSalarioBruto").val(oEstado.salarioBruto);
                $("#TxtDisponible").val(oEstado.disponileAhorros);


                $('#gridOperacionesCredito').clearGridData();
                $('#gridOperacionesCredito').setGridParam({ data: oEstado.OperacionesCredito }).trigger('reloadGrid');

                $('#gridOperacionesAhorro').clearGridData();
                $('#gridOperacionesAhorro').setGridParam({ data: oEstado.OperacionesAhorro }).trigger('reloadGrid');
            }

            function Limpiar() {

                $("#frmTorneos").validate().resetForm();

                $("#TxtNombre").val("");
                $("#TxtCedula").val("");
                $("#TxtSalarioNeto").val("");
                $("#TxtSalarioBruto").val("");
                $("#TxtDisponible").val("");

                $('#gridOperacionesAhorro').clearGridData();
                $('#gridOperacionesCredito').clearGridData();
            }

            function ObtenerTorneo(idTorneo) {
                var oParametrosAjax = { cID: idTorneo };

                var funcionProcesamientoCliente = function (oRespuesta) {
                    MostrarTorneo(oRespuesta.oTorneo);
                }

                RealizarPeticionAjax("ObtenerTorneo", "/Torneos/ObtenerTorneoPorID", oParametrosAjax, true, true, "ventanaEditar", funcionProcesamientoCliente);
            }


            function DeshabilitarCampos() {
                $("#TxtNombre").attr("disabled", "disabled");
                $("#TxtCedula").attr("disabled", "disabled");
                $("#TxtSalarioNeto").attr("disabled", "disabled");
                $("#TxtSalarioBruto").attr("disabled", "disabled");
                $("#TxtDisponible").attr("disabled", "disabled");
            }
          
    </script>
   
    <form id="frmTorneos" action="">
    <fieldset class="Fieldset">
        <legend>Información General</legend>
        <div class="ContenidoOrdenado">
            <div class="fila">
                <div class="celdaLabel">
                    Nombre
                </div>
                <div class="celdaCampo">
                    <input id="TxtNombre" name="TxtNombre" class="required" type="text" />
                </div>
                <div class="celdaLabel">
                    Cédula
                </div>
                <div class="celdaCampo">
                    <input id="TxtCedula" name="TxtCedula" class="required" type="text" />
                </div>
            </div>
            <div class="fila">
                <div class="celdaLabel">
                    Salario neto
                </div>
                <div class="celdaCampo">
                    <input id="TxtSalarioNeto" name="TxtSalarioNeto" class="required" type="text" />
                </div>
                <div class="celdaLabel">
                    Salario Bruto
                </div>
                <div class="celdaCampo">
                    <input id="TxtSalarioBruto" name="TxtSalarioBruto" type="text" />
                </div>
                <div class="celdaLabel">
                    Disponible de crédito por ahorro personal
                </div>
                <div class="celdaCampo">
                    <input id="TxtDisponible" name="TxtDisponible" class="required number" type="text" />
                </div>
            </div>
        </div>
    </fieldset>
    </form>
    <br />
     <div id="tabs">
        <ul>
            <li><a href="#tabs-1">Créditos</a></li>
            <li><a href="#tabs-2">Ahorros</a></li>
        </ul>
        <div id="tabs-1">
            <table id="gridOperacionesCredito">
            </table>
            <div id="barragridOperacionesCredito">
            </div>
        </div>
        <div id="tabs-2">
            <table id="gridOperacionesAhorro">
            </table>
            <div id="barragridOperacionesAhorro">
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
    <h1>Estado de Cuentas</h1>
    <h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
