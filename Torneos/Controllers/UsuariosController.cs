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

        public ActionResult Index()
        {
            TorneosEntities bdTorneos = new TorneosEntities();
            var torneos = from t in bdTorneos.Torneos
                            where t.nombre == "Santa Ana"
                            select t;
            return View("Login");
        }

    }
}
