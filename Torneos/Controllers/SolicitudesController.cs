
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class SolicitudesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Authorize]
        public ActionResult Index()
        {
            return View("Solicitudes");
        }

    }
}
