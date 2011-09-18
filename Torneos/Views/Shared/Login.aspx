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
                <li class="slider1Image"><a href="">
                    <img src="/Imagenes/3.jpg" alt="3" /></a> <span class="left"><strong>Anuncio 3</strong><br />
                        Detalle del anuncio 3</span></li>
                <div class="clear slider1Image">
                </div>
            </ul>
        </div>
    </div>
    <div class="ContenidoOrdenado ContenidoCompleto">
        <div class="fila">
            <div class="columna">
                <div class="SeccionContenidoLogin EsquinasInferioresRedondas">
                    <div class="EncabezadoSeccionContenidoLogin">
                        <h1>HAZTE ÁRBITRO</h1>
                    </div>
                    <div class="ContenidoSeccionContenidoLogin">
                        <p> 
                            ¿Quién ve el Fútbol más cerca? ... ahora, puedes se TÚ.
                            &nbsp;</p><br />
                        <p>
                            Sobre la Roca Sogdiana se levantaba una fortaleza que se creía impenetrable y que
                            estaba aprovisionada para resistir un largo asedio.</p><br />
                        <p>
                            Cuando Alejandro preguntó a sus defensores si querían rendirse, rechazaron la oferta,
                            señalando que Alejandro necesitaría "hombres alados" para asaltar la fortaleza.
                            Ante esta respuesta, Alejandro buscó voluntarios entre su ejército que fueran capaces
                            de escalar los riscos sobre los que se elevaba la fortaleza. Se presentaron 300
                            hombres que habían conseguido experiencia escalando en asedios anteriores. Ayudándose
                            de cuerdas y clavijas, escalaron el acantilado durante la noche y, siguiendo órdenes
                            de Alejandro, indicaron que habían alcanzado el objetivo agitando pedazos de tela
                            de lino. Alejandro Magno envió a un emisario para que anunciara la noticia a sus
                            enemigos, indicando que debían rendirse sin demora pues sus "hombres alados" habían
                            tomado posiciones en la cima. Los defensores de la fortaleza, sorprendidos y desmoralizados,
                            decidieron rendirse.</p><br />
                        <p>
                            Si te gusta el fútbol y crees que estás llamado a realizar grandes gestas, da el
                            primer paso. Hazte árbitro, donde pondrás a prueba tus capacidades para formar parte
                            del un gran equipo</p><br />
                       
                        <p>
                            El señor Diego Obando Barquero, el mismo es un instructor de amplia carrera a nivel
                            nacional, tambien tendremos la colaboracion de los señores instructores Bernal Rodriguez
                            y Mauricio Navarro, mas el apoyo de la comision tecnica de ACAF</p><br />
                 
                        <p>
                            Como parte de la mision empezaremos con nuestro primer curso arbitral para el 2010,
                            que iniciara la primera semana de Febrero, con una duracion estimada de 4 meses.
                            para mas informacion puede contactarnos al 2223-7523 o al <a href="mailto:asocentral@hotmail.es"
                                shape="rect">asocentral@hotmail.es</a>&nbsp;</p><br />
                        <p>
                            Visite tambien la nueva pagina de acaf &nbsp;<a href="http://www.wix.com/t83023535/acaf"
                                shape="rect">http://www.wix.com/t83023535/acaf</a></p><br />
                        <p>
                            El objetivo primordial sera la formacion constante de los arbitros de este pais.</p><br />
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

