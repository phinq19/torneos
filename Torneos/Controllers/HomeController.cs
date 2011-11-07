using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using ArconWeb.Filter;

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
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult Autenticar(string cCodigoUsuario, string cContrasena)
        {
            JsonResult jsonData = null;
            try
            {
                String cContrasenaMD5 = Utilidades.CalcularMD5(cContrasena);
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                List<Usuarios> usuarios = (from u in bdTorneos.Usuarios
                                               where u.cedula == cCodigoUsuario && u.contrasena == cContrasenaMD5
                                               select u).ToList<Usuarios>();
                if (usuarios.Count() == 1)
                {
                    Usuarios oUsuario = usuarios.Single<Usuarios>();
                    Utilidades.AsignarValorSession("idUsuario", oUsuario.id.ToString());
                    if (usuarios[0].activoContrasena == true)
                    {
                        Utilidades.AsignarValorSession("tipoUsuario", oUsuario.tipo.ToString());
                        Utilidades.AsignarValorSession("idTorneo", oUsuario.idTorneo.ToString());
                        Utilidades.AsignarValorSession("idAsociacion", oUsuario.idAsociacion.ToString());

                        FormsAuthentication.SetAuthCookie(oUsuario.nombre, false);
                        jsonData = Json(new { mensaje = "", estadoAutenticacion = "autenticado", estado = "exito" });
                    }
                    else {
                        
                        jsonData = Json(new { mensaje = "", estadoAutenticacion = "Inactivo", estado = "exito" });
                    }
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
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult CambiarContrasena(string cContrasena)
        {
            JsonResult jsonData = null;
            try
            {
                int idUsuario = Utilidades.ObtenerValorSession("idUsuario");
                String cContrasenaMD5 = Utilidades.CalcularMD5(cContrasena);
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                Usuarios oUsuarioEditado = (from u in bdTorneos.Usuarios
                                           where u.id == idUsuario
                                           select u).Single();
                oUsuarioEditado.contrasena = cContrasenaMD5;
                oUsuarioEditado.activoContrasena = true;

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oUsuarioEditado);

                Utilidades.AsignarValorSession("tipoUsuario", oUsuarioEditado.tipo.ToString());
                Utilidades.AsignarValorSession("idTorneo", oUsuarioEditado.idTorneo.ToString());
                Utilidades.AsignarValorSession("idAsociacion", oUsuarioEditado.idAsociacion.ToString());

                FormsAuthentication.SetAuthCookie(oUsuarioEditado.nombre, false);

                jsonData = Json(new { mensaje = "", estado = "exito" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
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
