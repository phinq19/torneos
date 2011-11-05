using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ArconWeb.Filter;

namespace Torneos.Controllers
{
    public class CanchasController : Controller
    {
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public ActionResult Index()
        {
            return View("Canchas");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult ObtenerCanchas(string sidx, string sord, int page, int rows)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

                var oResultado = (from c in bdTorneos.Canchas
                                  where c.idAsociacion == idAsociacion
                                  select new
                                  {
                                      c.id,
                                      c.nombre,
                                      c.telefonos,
                                      c.observaciones,
                                      c.ubicacion
                                  }).AsEnumerable();

                int pageIndex = Convert.ToInt32(page) - 1;
                int pageSize = rows;
                int totalRecords = oResultado.Count();
                var totalPages = (int)Math.Ceiling(totalRecords / (float)pageSize);
                int pagina = (page - 1) * rows;

                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    total = totalPages,
                    page,
                    records = totalRecords,
                    rows = oResultado.Skip(pagina).Take(rows)
                });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult EditarCanchas(Canchas oCanchas, String oper)
        {
            JsonResult jsonData = null;
            if (HttpContext.Request.IsAuthenticated)
            {
                try
                {
                    BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                    int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                    int nContador = (from c in bdTorneos.Canchas
                                     where c.nombre == oCanchas.nombre &&
                                            c.id != oCanchas.id &&
                                            c.idAsociacion == idAsociacion
                                     select c.id
                                    ).Count();
                    if (nContador > 0)
                    {
                        return jsonData = Json(new { estado = "exito", mensaje = "Ya existe una Cancha con el nombre: " + oCanchas.nombre, estadoValidacion = "falloLlave" });
                    }
                    switch (oper)
                    {
                        case "add":
                            Canchas oCanchasNuevo = new Canchas();
                            oCanchasNuevo.nombre = oCanchas.nombre;
                            oCanchasNuevo.observaciones = oCanchas.observaciones;
                            oCanchasNuevo.ubicacion = oCanchas.ubicacion;
                            oCanchasNuevo.telefonos = oCanchas.telefonos;
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
                            oCanchasEditado.telefonos = oCanchas.telefonos;

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
