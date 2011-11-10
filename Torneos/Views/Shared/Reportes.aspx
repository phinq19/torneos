<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <div id="tabs">
        <ul>
            <li><a href="#tabs-1">Partidos</a></li>
            <li><a href="#tabs-2">Pagos</a></li>
        </ul>
        <div id="tabs-1">
            <fieldset class="Fieldset">
                <form action="/ReportesGeneral/VerReportesPartido/Index.aspx" target="_blank" method="post">
                <div class="ContenidoOrdenado">
                    <div class="fila">
                        <div class="columna">
                            Por Partido
                        </div>
                        <div class="columna">
                            <input id="rbPorPartido" name="rbTipo" type="radio" />
                        </div>
                        <div class="columna">
                        
                        </div>
                    </div>
                    <div class="fila">
                        <div class="columna">
                            Por Árbitro
                        </div>
                        <div class="columna">
                            <input id="rbArbitro" name="rbTipo" type="radio" />
                        </div>
                        <div class="columna">
                        <%= Torneos.Utilidades.CrearSelectorArbitros("selArbitro") %>
                        </div>
                    </div>
                    <div class="fila">
                        <div class="columna">
                            Todos
                        </div>
                        <div class="columna">
                            <input id="rbTodos" name="rbTipo" type="radio" />
                        </div>
                    </div>
                </div>
                <input id="btnFormPartidos" value="Generar Reporte" type="submit" />
                </form>
            </fieldset>
        </div>
        <div id="tabs-2">
            <fieldset class="Fieldset">
            
            
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
