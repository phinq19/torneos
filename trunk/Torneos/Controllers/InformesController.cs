using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ArconWeb.Filter;

namespace Torneos.Controllers
{
    public class InformesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public ActionResult Index()
        {
            return View("Informes");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult ObtenerPartidos(string sidx, string sord, int page, int rows, int estado)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                int idUsuario = Utilidades.ObtenerValorSession("idUsuario");
                int ProgramacionVerificada = (int)enumEstadoProgramaciones.Verificado;
                int puestoCentral = (int)enumPuestosArbitros.Central;
                int estadoProgramado = (int)enumEstadoPartidos.Pendiente_De_Informe;
                int estadoInforme = (int)enumEstadoPartidos.Con_Informe;

                var oResultado = (from oPartido in bdTorneos.Partidos
                                  join oProgramacion in bdTorneos.Programaciones on oPartido.idProgramacion equals oProgramacion.id
                                  join oDetallePartido in bdTorneos.DetallePartidos on idUsuario equals oDetallePartido.idArbitro
                                  where oPartido.idAsociacion == idAsociacion &&
                                        oProgramacion.estado == ProgramacionVerificada &&
                                        oDetallePartido.puesto == puestoCentral &&
                                        (oPartido.estado == estadoProgramado || oPartido.estado == estadoInforme)
                                        && oPartido.estado == estado
                                  select new
                                  {
                                      oPartido.id,
                                      oPartido.numero,
                                      oPartido.coordinador,
                                      oPartido.estado,
                                      oPartido.fecha,
                                      oPartido.hora,
                                      oPartido.tipo,
                                      oPartido.idCancha,
                                      oPartido.telefono_coordinador,
                                      oPartido.equipoLocal,
                                      oPartido.equipoVisita,
                                      oPartido.observaciones,
                                      oPartido.arbitros,
                                      oPartido.informe,
                                      oPartido.Programaciones.Torneos.nombre,
                                      numeroProgramacion = oPartido.Programaciones.numero
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
        public JsonResult EditarDisponibilidad(Partidos oPartido)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();


                Partidos oPartidoEditado = (from p in bdTorneos.Partidos
                                           where p.id == oPartido.id
                                                         select p).Single();
                oPartidoEditado.id = oPartido.id;
                oPartidoEditado.informe = oPartido.informe;
                oPartidoEditado.estado = (int)enumEstadoPartidos.Con_Informe;

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oPartidoEditado);


                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oPartidoEditado, estadoValidacion = "exito" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

    }
}
