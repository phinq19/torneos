using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class VerificacionesController : Controller
    {

        public ActionResult Index()
        {
            return View("Verificaciones");
        }

    }
}
