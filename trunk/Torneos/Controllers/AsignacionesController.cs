using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class AsignacionesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        public ActionResult Index()
        {
            return View("Asignaciones");
        }
    }
}
