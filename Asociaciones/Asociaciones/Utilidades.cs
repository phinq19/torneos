﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Cryptography;
using System.Text;
using System.Globalization;
using Asociaciones;

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
                tipoUsuario == (int)enumTipoUsuario.Auditoria ||
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
                tipoUsuario == (int)enumTipoUsuario.Asociado)
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
                tipoUsuario == (int)enumTipoUsuario.Asociado)
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
            int tipoArbitro = (int)enumTipoUsuario.Asociado;
            
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


    }
}
