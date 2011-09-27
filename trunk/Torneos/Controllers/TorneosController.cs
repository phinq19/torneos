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
                    rows = (from oTorneo in bdTorneos.Torneos
                            select new
                            {
                                id = oTorneo.id,
                                nombre = oTorneo.nombre,
                                categoria = oTorneo.categoria,
                                telefono1 = oTorneo.telefono1,
                                ubicacion = oTorneo.ubicacion,
                                telefono2 = oTorneo.telefono2,
                                dieta = oTorneo.dieta,
                                observaciones = oTorneo.observaciones,
                                Torneos_Canchas = from c in oTorneo.Torneos_Canchas
                                                  select new
                                                  {
                                                      id = c.id,
                                                      idCancha = c.idCancha,
                                                      viaticos = c.viaticos,
                                                      observaciones = c.observaciones
                                                  }
                            })
                });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;   
        }


        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ObtenerTorneoPorID(int cID) {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                Torneos oTorneo = (from t in bdTorneos.Torneos
                              where t.id == cID
                              select t).Single();

                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    oTorneo = new {
                                id = oTorneo.id,
                                nombre = oTorneo.nombre,
                                categoria = oTorneo.categoria,
                                telefono1 = oTorneo.telefono1,
                                ubicacion = oTorneo.ubicacion,
                                telefono2 = oTorneo.telefono2,
                                dieta = oTorneo.dieta,
                                observaciones = oTorneo.observaciones,
                                Torneos_Canchas = from c in oTorneo.Torneos_Canchas
                                                  select new
                                                  {
                                                      id = c.id,
                                                      idCancha = c.idCancha,
                                                      viaticos = c.viaticos,
                                                      observaciones = c.observaciones
                                                  }
                            }
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
