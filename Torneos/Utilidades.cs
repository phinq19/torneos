using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Cryptography;
using System.Text;

namespace Torneos
{
    public class Utilidades 
    {
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
            StringBuilder oMenu = new StringBuilder();
            oMenu.AppendLine("<table>");
            oMenu.AppendLine("  <tr>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Usuarios/\" class=\"itemMenu\">Usuarios<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Canchas/\" class=\"itemMenu\">Canchas<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Torneos/\" class=\"itemMenu\">Torneos<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Programaciones/\" class=\"itemMenu\">Programaciones<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("  </tr>");
            oMenu.AppendLine("  <tr>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Verificaciones/\" class=\"itemMenu\">Verificaciones<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Asignaciones/\" class=\"itemMenu\">Asignaciones<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Informes/\" class=\"itemMenu\">Informes<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("      <td>");
            oMenu.AppendLine("          <a href=\"/Tesoreria/\" class=\"itemMenu\">Tesoreria<a>");
            oMenu.AppendLine("      </td>");
            oMenu.AppendLine("  </tr>");
            oMenu.AppendLine("</table>");
            return oMenu.ToString();
        }

        public static String CrearSelectorCategorias(String idSelector)
        {
            StringBuilder selCategoria = new StringBuilder();
            String[] oNombresCategoria = Enum.GetNames(typeof(Categorias));

            selCategoria.Append("<select id=\"" + idSelector + "\">");
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

            List<Canchas> oListaCanchas = (from c in bdTorneos.Canchas
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

            List<Torneos> oListaTorneos = (from t in bdTorneos.Torneos
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

        public static String CrearSelectorTorneosParaGrid()
        {
            StringBuilder selTorneos = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            List<Torneos> oListaTorneos = (from t in bdTorneos.Torneos
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

            List<Canchas> oListaCanchas = (from c in bdTorneos.Canchas
                                           select c).ToList<Canchas>();

            //selCanchas.Append("null:**Ninguno**");

            for (int indice = 0; indice < oListaCanchas.Count; indice++)
            {
                if (!String.IsNullOrEmpty(selCanchas.ToString()))
                {
                    selCanchas.Append(";");
                }
                selCanchas.Append( oListaCanchas[indice].id + ":" + oListaCanchas[indice].nombre);
            }

            return selCanchas.ToString();

        }

        public static String CrearSelectorTorneosCanchasParaGrid(int idTorneo)
        {
            StringBuilder selCanchas = new StringBuilder();
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

           
            List<Canchas> oListaCanchas  = (from tc in bdTorneos.Torneos_Canchas
                                            join t in bdTorneos.Torneos on idTorneo equals t.id
                                            join c in bdTorneos.Canchas on tc.idCancha equals c.id
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
            String[] oNombresCategoria = Enum.GetNames(typeof(Categorias));

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
            String[] oNombresEstados = Enum.GetNames(typeof(EstadoProgramaciones));

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

        public static String CrearSelectorTiposUsuarioParaGrid()
        {
            StringBuilder selTiposUsuario = new StringBuilder();
            String[] oNombresTiposUsuarios = Enum.GetNames(typeof(TipoUsuario));

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

        public static String ObtenerNombreTorneoUsuario(int idTorneo){
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
    }
}
