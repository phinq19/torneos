using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class CanchasController : Controller
    {
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
                List<Canchas> oCanchas;
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                IQueryable<Canchas> canchas = from t in bdTorneos.Canchas
                                               select t;
                oCanchas = canchas.ToList();

                string orderBytext = "";
                orderBytext = string.Format("it.{0} {1}", sidx, sord);
                var pageIndex = Convert.ToInt32(page) - 1;
                var filas = rows;
                var totalFilas = oCanchas.Count();
                var totalPaginas = (int)Math.Ceiling((float)totalFilas / (float)filas);
                jsonData = Json(new
                {
                    total = totalPaginas,
                    page = page,
                    records = totalFilas,
                    rows = (
                        from u in oCanchas
                        select new
                        {
                            id = u.id,
                            nombre = u.nombre,
                            observaciones = u.observaciones,
                            ubicacion = u.ubicacion
                        }
                        ).ToList().Skip((page - 1) * filas).Take(filas)
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
                            oCanchasNuevo.idAsociacion = 1;
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

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oCanchas, estadoValidacion = "exito" });
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
