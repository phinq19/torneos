using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Cryptography;
using System.Text;
using System.Globalization;

namespace Torneos
{
    public class Utilidades
    {
        public static int ObtenerValorSession(String cNombreVariable) {
            return Convert.ToInt32(Encriptador.Desencriptar(HttpContext.Current.Request.Cookies[cNombreVariable].Value));    
        }

        public static void AsignarValorSession(String cNombreVariable, String Valor) {
            if(String.IsNullOrEmpty(Valor)){
                Valor = "0";
            }
            HttpCookie cookie = new HttpCookie(cNombreVariable, Encriptador.Encriptar(Valor));
            cookie.Expires = new DateTime(9999, 1, 1);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static String CalcularMD5(string input)
        {
            // step 1, calculate MD5 hash from input
            MD5 md5 = System.Security.Cryptography.MD5.Create();
            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
            byte[] hash = md5.ComputeHash(inputBytes);

            // step 2, convert byte array to hex string
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }

        public static String CrearOpcionesMenu()
        {
            int tipoUsuario = ObtenerValorSession("tipoUsuario");

            StringBuilder oMenu = new StringBuilder();
            oMenu.AppendLine("<table>");
            oMenu.AppendLine("  <tr>");
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Usuarios/\" class=\"itemMenu itemMenuImagen\">Usuarios<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Canchas/\" class=\"itemMenu itemMenuImagen\">Canchas<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Torneos/\" class=\"itemMenu itemMenuImagen\">Torneos<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoTorneo ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion
                )
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Programaciones/\" class=\"itemMenu itemMenuProgramacionesImagen\">Programaciones<a>");
                oMenu.AppendLine("      </td>");
            }
            oMenu.AppendLine("  </tr>");
            oMenu.AppendLine("  <tr>");
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Verificaciones/\" class=\"itemMenu itemMenuImagen\">Verificaciones<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Asignaciones/\" class=\"itemMenu itemMenuImagen\">Asignaciones<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.Arbitro)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Informes/\" class=\"itemMenu itemMenuImagen\">Informes<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.Tesorero)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Tesoreria/\" class=\"itemMenu itemMenuImagen\">Tesorería<a>");
                oMenu.AppendLine("      </td>");
            }
            oMenu.AppendLine("  </tr>");
            oMenu.AppendLine("  <tr>");
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.Arbitro)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Disponibilidad/\" class=\"itemMenu itemMenuImagen\">Disponibilidad<a>");
                oMenu.AppendLine("      </td>");
            }
            if (tipoUsuario == (int)enumTipoUsuario.Administrador ||
                tipoUsuario == (int)enumTipoUsuario.SuperAdministrado ||
                tipoUsuario == (int)enumTipoUsuario.EncargadoAsociacion)
            {
                oMenu.AppendLine("      <td>");
                oMenu.AppendLine("          <a href=\"/Reportes/\" class=\"itemMenu itemMenuImagen\">Reportes<a>");
                oMenu.AppendLine("      </td>");
            }
            oMenu.AppendLine("  </tr>");
            oMenu.AppendLine("</table>");
            return oMenu.ToString();
        }

        public static String ObtenerConsecutivoPartido(DateTime fecha)
        {
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
            int nConsecutivo = bdTorneos.Partidos.Max(u => u.id) + 1;
            CultureInfo ciCurr = CultureInfo.CurrentCulture;
            int nNumSemana = ciCurr.Calendar.GetWeekOfYear(fecha, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
            String consecutivo = "PRT" + nNumSemana.ToString().PadLeft(2, '0') + "-" + nConsecutivo.ToString().PadLeft(6, '0');
            return consecutivo;
        }

        public static String ObtenerConsecutivoProgramacion()
        {
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
            int nConsecutivo = bdTorneos.Programaciones.Max(u => u.id) + 1;
            String consecutivo = "PGR" + nConsecutivo.ToString().PadLeft(6, '0');
            return consecutivo;

        }

        #region Grid

        public static String CrearSelectorTorneosParaGrid()
        {
            StringBuilder selTorneos = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

            List<Torneos> oListaTorneos = (from t in bdTorneos.Torneos
                                           where t.idAsociacion == idAsociacion
                                           select t).ToList<Torneos>();

            selTorneos.Append("null:**Ninguno**");

            for (int indice = 0; indice < oListaTorneos.Count; indice++)
            {
                selTorneos.Append(";" + oListaTorneos[indice].id + ":" + oListaTorneos[indice].nombre);
            }

            return selTorneos.ToString();

        }

        public static String CrearSelectorTorneosUsuariosParaGrid()
        {
            StringBuilder selTorneos = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
            int idUsuario = Utilidades.ObtenerValorSession("idUsuario");

            List<Torneos> oListaTorneos = (from t in bdTorneos.Torneos
                                           join u in bdTorneos.Usuarios on t.id equals u.idTorneo
                                           where t.idAsociacion == idAsociacion &&
                                           u.id == idUsuario
                                           select t).ToList<Torneos>();

            selTorneos.Append("null:**Ninguno**");

            for (int indice = 0; indice < oListaTorneos.Count; indice++)
            {
                selTorneos.Append(";" + oListaTorneos[indice].id + ":" + oListaTorneos[indice].nombre);
            }

            return selTorneos.ToString();

        }

        public static String CrearSelectorCanchasParaGrid()
        {
            StringBuilder selCanchas = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

            List<Canchas> oListaCanchas = (from c in bdTorneos.Canchas
                                           where c.idAsociacion == idAsociacion
                                           select c).ToList<Canchas>();

            //selCanchas.Append("null:**Ninguno**");

            for (int indice = 0; indice < oListaCanchas.Count; indice++)
            {
                if (!String.IsNullOrEmpty(selCanchas.ToString()))
                {
                    selCanchas.Append(";");
                }
                selCanchas.Append(oListaCanchas[indice].id + ":" + oListaCanchas[indice].nombre);
            }

            return selCanchas.ToString();

        }

        public static String CrearSelectorTorneosCanchasParaGrid()
        {
            StringBuilder selCanchas = new StringBuilder();
            int idTorneo = Utilidades.ObtenerValorSession("idTorneo");
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();


            List<Canchas> oListaCanchas = (
                                            from tc in bdTorneos.Torneos_Canchas
                                            join t in bdTorneos.Torneos on tc.idTorneo equals t.id
                                            join c in bdTorneos.Canchas on tc.idCancha equals c.id
                                            where t.id == idTorneo
                                            select c).ToList<Canchas>();

            for (int indice = 0; indice < oListaCanchas.Count; indice++)
            {
                if (!String.IsNullOrEmpty(selCanchas.ToString()))
                {
                    selCanchas.Append(";");
                }
                selCanchas.Append(oListaCanchas[indice].id + ":" + oListaCanchas[indice].nombre);
            }

            return selCanchas.ToString();

        }

        public static String CrearSelectorCategoriasParaGrid()
        {
            StringBuilder selCategoria = new StringBuilder();
            String[] oNombresCategoria = Enum.GetNames(typeof(enumCategorias));

            for (int indice = 0; indice < oNombresCategoria.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selCategoria.ToString()))
                {
                    selCategoria.Append(";");
                }
                selCategoria.Append(indice + ":" + oNombresCategoria[indice]);
            }

            return selCategoria.ToString();
        }

        public static String CrearSelectorEstadoProgramacionesParaGrid()
        {
            StringBuilder selEstado = new StringBuilder();
            String[] oNombresEstados = Enum.GetNames(typeof(enumEstadoProgramaciones));

            for (int indice = 0; indice < oNombresEstados.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selEstado.ToString()))
                {
                    selEstado.Append(";");
                }
                selEstado.Append(indice + ":" + oNombresEstados[indice]);
            }

            return selEstado.ToString();
        }

        public static String CrearSelectorEstadoPartidosParaGrid()
        {
            StringBuilder selEstado = new StringBuilder();
            String[] oNombresEstados = Enum.GetNames(typeof(enumEstadoPartidos));

            for (int indice = 0; indice < oNombresEstados.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selEstado.ToString()))
                {
                    selEstado.Append(";");
                }
                selEstado.Append(indice + ":" + oNombresEstados[indice]);
            }

            return selEstado.ToString();
        }

        public static String CrearSelectorCantidadArbitrosParaGrid()
        {
            StringBuilder selArbitros = new StringBuilder();
            String[] oNombresCantidadArbitros = Enum.GetNames(typeof(enumCantidadArbitros));

            for (int indice = 0; indice < oNombresCantidadArbitros.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selArbitros.ToString()))
                {
                    selArbitros.Append(";");
                }
                selArbitros.Append((indice + 1) + ":" + oNombresCantidadArbitros[indice]);
            }

            return selArbitros.ToString();
        }

        public static String CrearSelectorTiposUsuarioParaGrid()
        {
            StringBuilder selTiposUsuario = new StringBuilder();
            String[] oNombresTiposUsuarios = Enum.GetNames(typeof(enumTipoUsuario));

            for (int indice = 1; indice < oNombresTiposUsuarios.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selTiposUsuario.ToString()))
                {
                    selTiposUsuario.Append(";");
                }
                selTiposUsuario.Append(indice + ":" + oNombresTiposUsuarios[indice]);
            }

            return selTiposUsuario.ToString();
        }

        public static String CrearSelectorTiposPartidoParaGrid() {
            StringBuilder selTiposPartido = new StringBuilder();
            String[] oNombresTipos = Enum.GetNames(typeof(enumTipoPartido));

            for (int indice = 0; indice < oNombresTipos.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selTiposPartido.ToString()))
                {
                    selTiposPartido.Append(";");
                }
                selTiposPartido.Append(indice + ":" + oNombresTipos[indice]);
            }

            return selTiposPartido.ToString();
        }
       
        public static String CrearSelectorTiposDeduccionesParaGrid()
        {
            StringBuilder selTipos = new StringBuilder();
            String[] oNombresTiposPartidos = Enum.GetNames(typeof(enumTipoDeducciones));

            for (int indice = 0; indice < oNombresTiposPartidos.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selTipos.ToString()))
                {
                    selTipos.Append(";");
                }
                selTipos.Append(indice + ":" + oNombresTiposPartidos[indice]);
            }

            return selTipos.ToString();
        }

        public static String CrearSelectorTiposArbitroParaGrid()
        {
            StringBuilder selTiposArbitro = new StringBuilder();
            String[] oNombresTiposArbitro = Enum.GetNames(typeof(enumTipoArbitro));

            for (int indice = 0; indice < oNombresTiposArbitro.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selTiposArbitro.ToString()))
                {
                    selTiposArbitro.Append(";");
                }
                selTiposArbitro.Append(indice + ":" + oNombresTiposArbitro[indice]);
            }

            return selTiposArbitro.ToString();
        }

        public static String CrearSelectorArbitrosParaGrid()
        {
            StringBuilder selArbitros = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
            int tipoArbitro = (int)enumTipoUsuario.Arbitro;
            
            List<Usuarios> oListaUsuarios = (from u in bdTorneos.Usuarios 
                                            where u.idAsociacion == idAsociacion && u.tipo == tipoArbitro 
                                            select u).ToList<Usuarios>();

            selArbitros.Append("-1:**Sin Asignar**");
            for (int indice = 0; indice < oListaUsuarios.Count; indice++)
            {
                if (!String.IsNullOrEmpty(selArbitros.ToString()))
                {
                    selArbitros.Append(";");
                }
                selArbitros.Append(oListaUsuarios[indice].id + ":" + oListaUsuarios[indice].nombre);
            }

            return selArbitros.ToString();

        }

        public static String CrearSelectorEstadosDetallePartidosParaGrid()
        {
            StringBuilder selEstado = new StringBuilder();
            String[] oNombresEstados = Enum.GetNames(typeof(enumEstadoDetallePartidos));

            for (int indice = 0; indice < oNombresEstados.Length; indice++)
            {
                if (!String.IsNullOrEmpty(selEstado.ToString()))
                {
                    selEstado.Append(";");
                }
                selEstado.Append(indice + ":" + oNombresEstados[indice]);
            }

            return selEstado.ToString();
        }

        #endregion

        #region General

        public static String CrearSelectorTiposArbitro(String idSelector)
        {
            StringBuilder selTipo = new StringBuilder();
            String[] oNombresArbitro = Enum.GetNames(typeof(enumTipoArbitro));

            selTipo.Append("<select id=\"" + idSelector + "\" name=\"" + idSelector + "\" >");
            for (int indice = 0; indice < oNombresArbitro.Length; indice++)
            {
                selTipo.AppendLine("   <option value=\"" + indice + "\">" + oNombresArbitro[indice] + "</option>");
            }
            selTipo.AppendLine("</select>");

            return selTipo.ToString();
        }

        public static String CrearSelectorTiposPartido(String idSelector)
        {
            StringBuilder selTipo = new StringBuilder();
            String[] oNombresTipo = Enum.GetNames(typeof(enumTipoPartido));

            selTipo.Append("<select id=\"" + idSelector + "\" name=\"" + idSelector + "\" >");
            for (int indice = 0; indice < oNombresTipo.Length; indice++)
            {
                selTipo.AppendLine("   <option value=\"" + indice + "\">" + oNombresTipo[indice] + "</option>");
            }
            selTipo.AppendLine("</select>");

            return selTipo.ToString();
        }

        public static String CrearSelectorCategorias(String idSelector)
        {
            StringBuilder selCategoria = new StringBuilder();
            String[] oNombresCategoria = Enum.GetNames(typeof(enumCategorias));

            selCategoria.Append("<select id=\"" + idSelector + "\" name=\"" + idSelector + "\" >");
            for (int indice = 0; indice < oNombresCategoria.Length; indice++ )
            {
                selCategoria.AppendLine("   <option value=\"" + indice + "\">" + oNombresCategoria[indice] + "</option>");
            }
            selCategoria.AppendLine("</select>");

            return selCategoria.ToString();
        }

        public static String CrearSelectorCanchas(String idSelector) {
            StringBuilder selCanchas = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
            
            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

            List<Canchas> oListaCanchas = (from c in bdTorneos.Canchas
                                           where c.idAsociacion == idAsociacion
                                           select c).ToList<Canchas>();
            selCanchas.AppendLine("<select id=\"" + idSelector + "\">");
            for (int indice = 0; indice < oListaCanchas.Count; indice++)
            {
                selCanchas.AppendLine("   <option value=\"" + oListaCanchas[indice].id + "\">" + oListaCanchas[indice].nombre + "</option>");
            }
            selCanchas.AppendLine("</select>");

            return selCanchas.ToString();
            
        }

        public static String CrearSelectorTorneos(String idSelector)
        {
            StringBuilder selTorneos = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

            List<Torneos> oListaTorneos = (from t in bdTorneos.Torneos
                                           where t.idAsociacion == idAsociacion
                                           select t).ToList<Torneos>();

            selTorneos.AppendLine("<select id=\"" + idSelector + "\">");
            selTorneos.AppendLine("   <option value=\"0\">Ninguno</option>");
            for (int indice = 0; indice < oListaTorneos.Count; indice++)
            {
                selTorneos.AppendLine("   <option value=\"" + oListaTorneos[indice].id + "\">" + oListaTorneos[indice].nombre + "</option>");
            }
            selTorneos.AppendLine("</select>");

            return selTorneos.ToString();

        }

        public static String CrearSelectorTorneosUsuarios(String idSelector)
        {
            StringBuilder selTorneos = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
            int idUsuario = Utilidades.ObtenerValorSession("idUsuario");
            List<Torneos> oListaTorneos = (from t in bdTorneos.Torneos
                                           join u in bdTorneos.Usuarios on t.id equals u.idTorneo
                                           where t.idAsociacion == idAsociacion &&
                                                 u.id == idUsuario
                                           select t).ToList<Torneos>();

            selTorneos.AppendLine("<select id=\"" + idSelector + "\">");
            selTorneos.AppendLine("   <option value=\"0\">Ninguno</option>");
            for (int indice = 0; indice < oListaTorneos.Count; indice++)
            {
                selTorneos.AppendLine("   <option value=\"" + oListaTorneos[indice].id + "\">" + oListaTorneos[indice].nombre + "</option>");
            }
            selTorneos.AppendLine("</select>");

            return selTorneos.ToString();

        }

        public static String CrearSelectorEstadosProgramaciones(String idSelector)
        {
            StringBuilder selEstados = new StringBuilder();
            String[] oNombresEstados = Enum.GetNames(typeof(enumEstadoProgramaciones));

            selEstados.Append("<select id=\"" + idSelector + "\" name=\"" + idSelector + "\" >");
            for (int indice = 0; indice < oNombresEstados.Length; indice++)
            {
                selEstados.AppendLine("   <option value=\"" + indice + "\">" + oNombresEstados[indice] + "</option>");
            }
            selEstados.AppendLine("</select>");

            return selEstados.ToString();
        }

        public static String CrearSelectorEstadosPartidos(String idSelector)
        {
            StringBuilder selEstados = new StringBuilder();
            String[] oNombresEstados = Enum.GetNames(typeof(enumEstadoPartidos));

            selEstados.Append("<select id=\"" + idSelector + "\" name=\"" + idSelector + "\" >");
            for (int indice = 0; indice < oNombresEstados.Length; indice++)
            {
                selEstados.AppendLine("   <option value=\"" + indice + "\">" + oNombresEstados[indice] + "</option>");
            }
            selEstados.AppendLine("</select>");

            return selEstados.ToString();
        }

        public static String CrearSelectorEstadosDetallePartidos(String idSelector)
        {
            StringBuilder selEstados = new StringBuilder();
            String[] oNombresEstados = Enum.GetNames(typeof(enumEstadoDetallePartidos));

            selEstados.Append("<select id=\"" + idSelector + "\" name=\"" + idSelector + "\" >");
            for (int indice = 0; indice < oNombresEstados.Length; indice++)
            {
                selEstados.AppendLine("   <option value=\"" + indice + "\">" + oNombresEstados[indice] + "</option>");
            }
            selEstados.AppendLine("</select>");

            return selEstados.ToString();
        }

        public static String CrearSelectorArbitrosAsignaciones(String idSelector, DateTime dFecha, String dHorario)
        {
           
            StringBuilder selArbitros = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
            int tipoArbitro = (int)enumTipoUsuario.Arbitro;
            int diaSemana = (int)dFecha.DayOfWeek;

            List<Usuarios> oListaUsuarios = (from u in bdTorneos.Usuarios
                                             join d in bdTorneos.Disponibilidad on u.id equals d.idArbitro
                                             where (u.idAsociacion == idAsociacion && u.tipo == tipoArbitro) &&
                                                   ((d.lunes == diaSemana && d.tiempoLunes.Contains(dHorario)) ||
                                                   (d.martes == diaSemana && d.tiempoMartes.Contains(dHorario)) ||
                                                   (d.miercoles == diaSemana && d.tiempoMiercoles.Contains(dHorario)) ||
                                                   (d.jueves == diaSemana && d.tiempoJueves.Contains(dHorario)) ||
                                                   (d.viernes == diaSemana && d.tiempoViernes.Contains(dHorario)) ||
                                                   (d.sabado == diaSemana && d.tiempoSabado.Contains(dHorario)) ||
                                                   (d.domingo == diaSemana && d.tiempoDomingo.Contains(dHorario)))
                                                   
                                             select u).ToList<Usuarios>();

            selArbitros.AppendLine("<select id=\"" + idSelector + "\">");
            selArbitros.AppendLine("   <option value=\"-1\">**Sin Asignar**</option>");
            for (int indiceSel = 0; indiceSel < oListaUsuarios.Count; indiceSel++)
            {
                selArbitros.AppendLine("   <option value=\"" + oListaUsuarios[indiceSel].id + "\">" + oListaUsuarios[indiceSel].nombre + "</option>");
            }
            selArbitros.AppendLine("</select>");

            return selArbitros.ToString();

        }

        public static String CrearSelectorArbitros(String idSelector)
        {

            StringBuilder selArbitros = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
            int tipoArbitro = (int)enumTipoUsuario.Arbitro;
            

            List<Usuarios> oListaUsuarios = (from u in bdTorneos.Usuarios
                                             join d in bdTorneos.Disponibilidad on u.id equals d.idArbitro
                                             where (u.idAsociacion == idAsociacion && u.tipo == tipoArbitro) 
                                             select u).ToList<Usuarios>();

            selArbitros.AppendLine("<select id=\"" + idSelector + "\">");
            for (int indice = 0; indice < oListaUsuarios.Count; indice++)
            {
                selArbitros.AppendLine("   <option value=\"" + oListaUsuarios[indice].id + "\">" + oListaUsuarios[indice].nombre + "</option>");
            }
            selArbitros.AppendLine("</select>");

            return selArbitros.ToString();

        }

        public static String CrearSelectorSemanas(String idSelector)
        {

            StringBuilder selSemanas = new StringBuilder();

            selSemanas.AppendLine("<select id=\"" + idSelector + "\">");
            for (int indice = 1; indice < 53; indice++)
            {
                selSemanas.AppendLine("   <option value=\"" + indice + "\">Semana " + indice + "</option>");
            }
            selSemanas.AppendLine("</select>");

            return selSemanas.ToString();

        }

        public static String ObtenerNombreTorneoUsuario()
        {
            int idTorneo = ObtenerValorSession("idTorneo");
            String cNombreTorneo = "No tiene asignado";
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            IQueryable<Torneos> Torneo = from t in bdTorneos.Torneos
                                         where t.id == idTorneo
                                         select t;
            if (Torneo.Count() == 1)
            {
                Torneos oTorneo = Torneo.Single<Torneos>();
                cNombreTorneo = oTorneo.nombre;
            }
            return cNombreTorneo;
        } 
        #endregion

    }
}
