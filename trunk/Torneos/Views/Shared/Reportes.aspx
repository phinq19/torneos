<%@ Page Title="ACAF Reportes" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <div id="tabs">
        <ul>
            <li><a href="#tabs-1">Programaciones</a></li>
        </ul>
        <div id="tabs-1">
            <fieldset class="Fieldset">
                <form action="/ReportesGeneral/VerReportesPartido/Default.aspx" target="_blank" method="post">
                <div class="ContenidoOrdenado">
                    <div class="fila">
                        <div class="columna">
                            Semana
                        </div>
                        <div class="columna">
                        <%= Torneos.Utilidades.CrearSelectorSemanas("selSemanas")%>
                        </div>
                    </div>
                </div>
                <input id="btnFormPartidos" value="Generar Reporte" type="submit" />
                </form>
            </fieldset>
        </div>
    </div>
    <script type='text/javascript'>
        $(document).ready(function () {

            $(function () {
                $("#tabs").tabs();
            });

            $("#btnFormPartidos").button();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
<h1>Reportes</h1>
<h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
