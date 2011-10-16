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
                                               where u.cedula == cCodigoUsuario && u.contrasena == cContrasenaMD5
                                               select u;
                if (usuarios.Count() == 1)
                {
                    Usuarios oUsuario = usuarios.Single<Usuarios>();
                    Utilidades.AsignarValorSession("tipoUsuario", oUsuario.tipo.ToString());
                    Utilidades.AsignarValorSession("idUsuario", oUsuario.id.ToString());
                    Utilidades.AsignarValorSession("idTorneo", oUsuario.idTorneo.ToString());
                    Utilidades.AsignarValorSession("idAsociacion", oUsuario.idAsociacion.ToString());
                    /*
                    HttpCookie cookieTipo = new HttpCookie("tipo", oUsuario.tipo.ToString());
                    cookieTipo.Expires = new DateTime(9999, 1, 1);
                    this.ControllerContext.HttpContext.Response.Cookies.Add(cookieTipo);
                    
                    HttpCookie cookieIdUsuario = new HttpCookie("idUsuario", oUsuario.id.ToString());
                    cookieIdUsuario.Expires = new DateTime(9999, 1, 1);
                    this.ControllerContext.HttpContext.Response.Cookies.Add(cookieIdUsuario);
                    
                    HttpCookie cookieIdTorneo = new HttpCookie("idTorneo", oUsuario.idTorneo.ToString());
                    cookieIdTorneo.Expires = new DateTime(9999, 1, 1);
                    this.ControllerContext.HttpContext.Response.Cookies.Add(cookieIdTorneo);

                    HttpCookie cookieIdAsoc = new HttpCookie("idAsociacion", oUsuario.idAsociacion.ToString());
                    cookieIdAsoc.Expires = new DateTime(9999, 1, 1);
                    this.ControllerContext.HttpContext.Response.Cookies.Add(cookieIdAsoc);
                    */
                    //Session.Add("tipo", oUsuario.tipo);
                    //Session.Add("idUsuario", oUsuario.id);
                    //Session.Add("idTorneo", oUsuario.idTorneo);
                    FormsAuthentication.SetAuthCookie(cCodigoUsuario, false);
                    jsonData = Json(new { mensaje = "", estadoAutenticacion = "autenticado", estado = "exito" });
                }
                else
                {
                    jsonData = Json(new { mensaje = "El usuario no existe o la contraseña es incorrecta", estadoAutenticacion = "falloAutenticacion", estado = "exito" });
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
                this.HttpContext.Request.Cookies.Clear();
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
