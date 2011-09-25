using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class TorneosController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Authorize]
        public ActionResult Index()
        {
            return View("Torneos");
        }


        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ObtenerTorneos()
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    rows = (
                        from t in bdTorneos.Torneos
                        select new
                        {
                            id = t.id,
                            nombre = t.nombre,
                            categoria = t.categoria,
                            telefono1 = t.telefono1,
                            ubicacion = t.ubicacion,
                            telefono2 = t.telefono2,
                            dieta = t.dieta,
                            observaciones = t.observaciones,
                            
                        }
                    )
                });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }
    }
}
