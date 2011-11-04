using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class AsignacionesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        public ActionResult Index()
        {
            return View("Asignaciones");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult ObtenerPartidos(int estado)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                int ProgramacionVerificada = (int)enumEstadoProgramaciones.Verificado;
                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    rows = (from oPartido in bdTorneos.Partidos join 
                                 oProgramacion in bdTorneos.Programaciones on oPartido.idProgramacion equals oProgramacion.id
                            where oPartido.idAsociacion == idAsociacion
                                && oProgramacion.estado == ProgramacionVerificada
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
                                oPartido.Programaciones.Torneos.nombre,
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
        [Autorizado]
        public JsonResult ObtenerPartidoPorID(int cID)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                Partidos oPartido = (from p in bdTorneos.Partidos
                                   where p.id == cID
                                   select p).Single();

                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    oPartido = new
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
                        oPartido.Programaciones.Torneos.nombre,
                        DetallePartidos = from d in oPartido.DetallePartidos
                                          select new
                                          {
                                              d.id,
                                              //d.idArbitro,
                                              idArbitro = (d.idArbitro != null ? d.idArbitro : -1),
                                              d.puesto
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
        [Autorizado]
        public JsonResult ValidarDetallePartido(DetallePartidos oDetallePartido)
        {
            JsonResult jsonData = null;
            try
            {
                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oDetallePartido, estadoValidacion = "exito" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult EditarPartidos(Torneos oPartido, DetallePartidos[] oDetallePartidos)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                    
                Partidos oPartidosEditado = (from t in bdTorneos.Partidos
                                            where t.id == oPartido.id
                                            select t).Single();
                oPartidosEditado.estado = (int)enumEstadoPartidos.Programado;

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oPartidosEditado);
                

                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oPartidosEditado, estadoValidacion = "exito" });
                        
                
                foreach (DetallePartidos oDetallePartido in oDetallePartidos)
                {
                    EditarDetallePartidos(oDetallePartido);
                }
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public void EditarDetallePartidos(DetallePartidos oDetallePartido)
        {
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

            DetallePartidos oDetallePartidoEditado = (from t in bdTorneos.DetallePartidos
                                                where t.id == oDetallePartido.id
                                                select t).Single();

            oDetallePartidoEditado.idArbitro = oDetallePartido.idArbitro;
            oDetallePartidoEditado.puesto = oDetallePartido.puesto;

            bdTorneos.SaveChanges();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult ObtenerSelectorArbitrosParaAsignaciones(String idSelector, DateTime dFecha)
        {
            JsonResult jsonData = null;
            try
            {
                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    selector = Utilidades.CrearSelectorArbitrosAsignaciones(idSelector, dFecha)
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
