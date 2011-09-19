<%@ Page Title="ACAF Inicio" Language="C#" MasterPageFile="~/Views/Shared/MarcoLogeado.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<asp:Content ID="Content4" ContentPlaceHolderID="ContenidoEncabezado" runat="server">

<h1>Inicio</h1>

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <%= Torneos.Utilidades.CrearOpcinesMenu() %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Encabezado" runat="server">

</asp:Content>
