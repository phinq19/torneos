<%@ Page Title="ACAF Inicio" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">

<h1>Inicio</h1>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <div id="opcionesMenu">
        <%--= Torneos.Utilidades.CrearOpcionesMenu() --%>
        <table>
            <tr>
                <td>
                    <a href="/Usuarios/" class="itemMenu itemMenuImagenUsuarios">Usuarios<a>
                </td>
                <td>
                    <a href="/Estado/" class="itemMenu itemMenuImagenConsultas">Estado<a>
                </td>
                <td>
                    <a href="/Solicitudes/" class="itemMenu itemMenuImagenSolicitudes">Solicitudes<a>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">

</asp:Content>
