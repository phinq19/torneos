<%@ Page Title="Acaf Error" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contenido" runat="server">
<div class="MensajeError">
<%=  ViewData["Error"].ToString() %>
</div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">
    <h1>Página de Error</h1>
    <h1><a href="/">Volver al menú principal</a></h1>
</asp:Content>
