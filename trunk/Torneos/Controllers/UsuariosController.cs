using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class UsuariosController : Controller
    {
        //
        // GET: /Usuarios/
        List<Usuarios> oUsuarios;
        public ActionResult Index()
        {
            /*
            TorneosEntities bdTorneos = new TorneosEntities();
            IQueryable<Usuarios> usuarios = from t in bdTorneos.Usuarios
                            where t.codigo == "usuario" && t.contrasena == "123456"
                            select t;
            oUsuarios= usuarios.ToList();

            Usuarios oUsuarioNuevo = Usuarios.CreateUsuarios(0, "arahi2", "Abel", Utilidades.CalcularMD5("123456"), "arahi2@hotmail.com", "123456", 1, 1);
            bdTorneos.AddToUsuarios(oUsuarioNuevo);
            bdTorneos.SaveChanges();
            */
            

            return View("Login");
        }

    }
}
