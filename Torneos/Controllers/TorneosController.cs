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
                                                      observaciones = c.observaciones,
                                                      accionregistro = 0
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

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ValidarTorneoCanchas(Torneos_Canchas oCancha, String oper)
        {
            return new JsonResult();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult EditarTorneos(Torneos oTorneo, String oper)
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
                            Torneos oTorneosNuevo = new Torneos();
                            oTorneosNuevo.nombre = oTorneo.nombre;
                            oTorneosNuevo.categoria = oTorneo.categoria;
                            oTorneosNuevo.dieta = oTorneo.dieta;
                            oTorneosNuevo.telefono1 = oTorneo.telefono1;
                            oTorneosNuevo.telefono2 = oTorneo.telefono2;
                            oTorneosNuevo.observaciones = oTorneo.observaciones;
                            oTorneosNuevo.ubicacion = oTorneo.ubicacion;
                            oTorneosNuevo.idAsociacion = 1;
                            oTorneosNuevo.id = 0;

                            bdTorneos.AddToTorneos(oTorneosNuevo);
                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oTorneosNuevo);

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosNuevo, estadoValidacion = "exito" });

                            break;
                        case "del":
                            Torneos oTorneosEliminado = (from t in bdTorneos.Torneos
                                                         where t.id == oTorneo.id
                                                         select t).Single();

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosEliminado, estadoValidacion = "exito" });

                            bdTorneos.DeleteObject(oTorneosEliminado);
                            bdTorneos.SaveChanges();
                            break;
                        case "edit":
                            Torneos oTorneosEditado = (from t in bdTorneos.Torneos
                                                       where t.id == oTorneo.id
                                                       select t).Single();

                            oTorneosEditado.nombre = oTorneo.nombre;
                            oTorneosEditado.categoria = oTorneo.categoria;
                            oTorneosEditado.dieta = oTorneo.dieta;
                            oTorneosEditado.telefono1 = oTorneo.telefono1;
                            oTorneosEditado.telefono2 = oTorneo.telefono2;
                            oTorneosEditado.observaciones = oTorneo.observaciones;
                            oTorneosEditado.ubicacion = oTorneo.ubicacion;

                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oTorneosEditado);

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosEditado, estadoValidacion = "exito" });
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
