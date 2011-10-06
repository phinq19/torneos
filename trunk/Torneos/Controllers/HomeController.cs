using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Torneos.Controllers
{
    public class HomeController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Index()
        {
            if (HttpContext.Request.IsAuthenticated)
            {
                return View("Inicio");
            }
            else
            {
                return View("Login");
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult Autenticar(string cCodigoUsuario, string cContrasena)
        {
            JsonResult jsonData = null;
            try
            {
                String cContrasenaMD5 = Utilidades.CalcularMD5(cContrasena);
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                IQueryable<Usuarios> usuarios = from u in bdTorneos.Usuarios
                                               where u.codigo == cCodigoUsuario && u.contrasena == cContrasenaMD5
                                               select u;
                if (usuarios.Count() == 1)
                {
                    Usuarios oUsuario = usuarios.Single<Usuarios>();
                    FormsAuthentication.SetAuthCookie(cCodigoUsuario, false);
                    Session.Add("tipo", oUsuario.tipo);
                    Session.Add("idTorneo", oUsuario.idTorneo);
                    jsonData = Json(new { mensaje = "", estadoAutenticacion = "autenticado", estado = "exito" });
                }
                else
                {
                    jsonData = Json(new { mensaje = "El usuario no existe, la contraseña no es correcta o el Dominio es incorrecto", estadoAutenticacion = "falloAutenticacion", estado = "exito" });
                }
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult CerrarSesion()
        {
            JsonResult jsonData = null;
            try
            {
                Session.Abandon();
                FormsAuthentication.SignOut();
                jsonData = Json(new { estado = "exito", mensaje = "" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cerrando" });
            }
            return jsonData;
        }

    }
}
