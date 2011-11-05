using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ArconWeb.Filter;

namespace Torneos.Controllers
{
    public class VerificacionesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public ActionResult Index()
        {
            return View("Verificaciones");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult ObtenerProgramaciones(string sidx, string sord, int page, int rows, int estado)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idTorneo = Utilidades.ObtenerValorSession("idTorneo");
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

                var oResultado = (from oProgramaciones in bdTorneos.Programaciones
                                  where oProgramaciones.idTorneo == idTorneo &&
                                        oProgramaciones.idAsociacion == idAsociacion &&
                                        oProgramaciones.estado == estado
                                  select new
                                  {
                                      oProgramaciones.id,
                                      oProgramaciones.numero,
                                      oProgramaciones.deposito,
                                      oProgramaciones.estado,
                                      oProgramaciones.idTorneo,
                                      oProgramaciones.idUsuario,
                                      oProgramaciones.monto,
                                      oProgramaciones.montoCalculado,
                                      oProgramaciones.observaciones,
                                      oProgramaciones.observacionesAsoc
                                  }).AsEnumerable(); ;

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
        public JsonResult EditarProgramaciones(Programaciones oProgramacion)
        {
            int nIDProgramacion = 0;
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                Programaciones oProgramacionEditado = (from p in bdTorneos.Programaciones
                                                               where p.id == oProgramacion.id
                                                               select p).Single();
                
                oProgramacionEditado.estado = oProgramacion.estado;
                oProgramacionEditado.observacionesAsoc = oProgramacion.observacionesAsoc;

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oProgramacionEditado);
                nIDProgramacion = oProgramacionEditado.id;

                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oProgramacionEditado, estadoValidacion = "exito" });
                  
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

    }
}
