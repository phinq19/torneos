using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class CanchasController : Controller
    {
        [Authorize]
        public ActionResult Index()
        {
            return View("Canchas");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ObtenerCanchas(string sidx, string sord, int page, int rows)
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
                        from c in bdTorneos.Canchas
                        select new
                        {
                            id = c.id,
                            nombre = c.nombre,
                            observaciones = c.observaciones,
                            ubicacion = c.ubicacion
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

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult EditarCanchas(Canchas oCanchas, String oper)
        {
            JsonResult jsonData = null;
            if (HttpContext.Request.IsAuthenticated)
            {
                try
                {
                    BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                    switch (oper)
                    {
                        case "add":
                            Canchas oCanchasNuevo = new Canchas();
                            oCanchasNuevo.nombre = oCanchas.nombre;
                            oCanchasNuevo.observaciones = oCanchas.observaciones;
                            oCanchasNuevo.ubicacion = oCanchas.ubicacion;
                            oCanchasNuevo.idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                            oCanchasNuevo.id = 0;

                            bdTorneos.AddToCanchas(oCanchasNuevo);
                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oCanchasNuevo);

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oCanchasNuevo, estadoValidacion = "exito" });

                            break;
                        case "del":
                            Canchas oCanchasEliminado = (from u in bdTorneos.Canchas
                                                         where u.id == oCanchas.id
                                                         select u).Single();

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oCanchasEliminado, estadoValidacion = "exito" });

                            bdTorneos.DeleteObject(oCanchasEliminado);
                            bdTorneos.SaveChanges();
                            break;
                        case "edit":
                            Canchas oCanchasEditado = (from u in bdTorneos.Canchas
                                                       where u.id == oCanchas.id
                                                       select u).Single();

                            oCanchasEditado.nombre = oCanchas.nombre;
                            oCanchasEditado.ubicacion = oCanchas.ubicacion;
                            oCanchasEditado.observaciones = oCanchas.observaciones;

                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oCanchasEditado);

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oCanchasEditado, estadoValidacion = "exito" });
                            break;
                    }
                }
                catch
                {
                    jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
                }
            }
            else
            {
                jsonData = Json(new { estado = "exito", mensaje = "", estadoValidacion = "sinAutenticar" });
            }
            return jsonData;
        }
    }
}
