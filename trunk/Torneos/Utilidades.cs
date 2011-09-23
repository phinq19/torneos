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
        public static string CalcularMD5(string input)
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
            oMenu.AppendLine("          <a href=\"/Solicitudes/\" class=\"itemMenu\">Programaciones<a>");
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

    }
}
