using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Torneos.Controllers
{
    public class UsuariosController : Controller
    {
        //
        // GET: /Usuarios/
        
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Index()
        {
            /*
            List<Usuarios> oUsuarios;
            TorneosEntities bdTorneos = new TorneosEntities();
            IQueryable<Usuarios> usuarios = from t in bdTorneos.Usuarios
                            where t.codigo == "usuario" && t.contrasena == "123456"
                            select t;
            oUsuarios= usuarios.ToList();

            Usuarios oUsuarioNuevo = Usuarios.CreateUsuarios(0, "arahi2", "Abel", Utilidades.CalcularMD5("123456"), "arahi2@hotmail.com", "123456", 1, 1);
            bdTorneos.AddToUsuarios(oUsuarioNuevo);
            bdTorneos.SaveChanges();
            */
            if (HttpContext.Request.IsAuthenticated)
            {
                return View("Inicio");
            }
            else {
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
                TorneosEntities bdTorneos = new TorneosEntities();
                IQueryable<Usuarios> usuarios = from u in bdTorneos.Usuarios
                                                where u.codigo == cCodigoUsuario && u.contrasena == cContrasenaMD5
                                                select u;
                if (usuarios.Count() == 1)
                {
                    FormsAuthentication.SetAuthCookie(cCodigoUsuario, false);
                    Session.Add("tipo", usuarios.First().tipo);
                    jsonData = Json(new { mensaje = "", estadoAutenticacion = "autenticado", estado = "exito" });
                }
                else{
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

        [AcceptVerbs(HttpVerbs.Get)]
        [Authorize]
        public ActionResult MantenimientoUsuarios()
        {
            return View("Usuarios");
        }
    }
}
