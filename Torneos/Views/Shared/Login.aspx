<%@ Page Title="ACAF Login" Language="C#" MasterPageFile="~/Views/Shared/MarcoPrincipal.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Contenido" runat="server">
    <div id="sliderInicio">
        <div id="slider1">
            <ul id="slider1Content">
                <li class="slider1Image"><a href="">
                    <img src="/Imagenes/1.jpg" alt="1" /></a> <span class="left"><strong>Anuncio 1</strong><br />
                        Detalle del anuncio 1</span></li>
                <li class="slider1Image"><a href="">
                    <img src="/Imagenes/2.jpg" alt="2" /></a> <span class="right"><strong>Anuncio 2</strong><br />
                        Detalle del anuncio 2</span></li>
                <li class="slider1Image">
                    <img src="/Imagenes/3.jpg" alt="3" />
                    <span class="left"><strong>Anuncio 3</strong><br />
                        NDetalle del anuncio 3</span></li>
            </ul>
        </div>
    </div>
    <div class="ContenidoOrdenado ContenidoCompleto">
        <div class="fila">
            <div class="columna">
                <div class="SeccionContenidoLogin EsquinasInferioresRedondas">
                    <div class="EncabezadoSeccionContenidoLogin">
                        <h1>Información General</h1>
                    </div>
                    <div class="ContenidoSeccionContenidoLogin">
                    
                    </div>
                </div>
            </div>
            <div class="columna FormularioLogin">
                <div class="SeccionContenidoLogin EsquinasInferioresRedondas">
                    <div class="EncabezadoSeccionContenidoLogin">
                        <h1>
                            Inicio de Sesión</h1>
                    </div>
                    <div class="ContenidoSeccionContenidoLogin">
                        <form id="frmLogin" action="">
                        <div class="ContenidoOrdenado">
                            <div class="fila">
                                <div class="celdaLabel">
                                    <label>Código Usuario:</label>
                                </div>
                                <div class="">
                                    <input id="TxtCodigo" type="text" />
                                </div>
                            </div>
                            <div class="fila">
                                <div class="celdaLabel">
                                    <label>Contraseña:</label>
                                </div>
                                <div class="celdaCampo">
                                    <input id="TxtContrasena" type="password" />
                                </div>
                            </div>
                            <div class="fila">
                                <div class="celdaLabel">
                                </div>
                                <div class="celdaCampo">
                                    <input id="BtnIngresar" type="button" value="Ingresar" />
                                </div>
                            </div>
                            <div class="fila">
                                <div class="celdaLabel">
                                </div>
                                <div class="celdaCampo">
                                    <a id="LkRecuperar" href="">Recuperar contraseña</a>
                                </div>
                            </div>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Encabezado" runat="server">
</asp:Content>

