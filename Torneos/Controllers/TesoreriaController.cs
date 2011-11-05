using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ArconWeb.Filter;

namespace Torneos.Controllers
{
    public class TesoreriaController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public ActionResult Index()
        {
            return View("Tesoreria");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult ObtenerDetallePartidos(string sidx, string sord, int page, int rows, int estado)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                int PartidoConInforme = (int)enumEstadoPartidos.Con_Informe;

                var oResultado = (from oDetallePartidos in bdTorneos.DetallePartidos
                                  join
                                  oPartido in bdTorneos.Partidos on oDetallePartidos.id equals oPartido.id
                                  where oPartido.idAsociacion == idAsociacion &&
                                        oPartido.estado == PartidoConInforme &&
                                        oDetallePartidos.estado == estado
                                  select new
                                  {
                                      oDetallePartidos.id,
                                      oDetallePartidos.idArbitro,
                                      oDetallePartidos.deposito,
                                      oDetallePartidos.total_pagar,
                                      oDetallePartidos.total_rebajos,
                                      oDetallePartidos.estado,
                                      oPartido.numero,//Partido
                                      oPartido.Programaciones.Torneos.nombre,//Torneo
                                      numeroProgramacion = oPartido.Programaciones.numero//Programacion
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
        public JsonResult ObtenerDetallePartidoPorID(int cID)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                DetallePartidos oDetallePartidos = (from d in bdTorneos.DetallePartidos
                                     where d.id == cID
                                     select d).Single();

                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    oPartido = new
                    {
                        oDetallePartidos.id,
                        oDetallePartidos.idArbitro,
                        oDetallePartidos.deposito,
                        oDetallePartidos.total_pagar,
                        oDetallePartidos.total_rebajos,
                        oDetallePartidos.estado,
                        oDetallePartidos.Partidos.numero,//Partido
                        oDetallePartidos.Partidos.Programaciones.Torneos.nombre,//Torneo
                        numeroProgramacion = oDetallePartidos.Partidos.Programaciones.numero,//Programacion
                        Deducciones = from d in oDetallePartidos.Deducciones
                                          select new
                                          {
                                              d.id,
                                              d.monto,
                                              d.observaciones,
                                              d.descripcion,
                                              d.idDetallePartido,
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
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult ValidarDeducciones(Deducciones oDeducciones, String oper)
        {
            JsonResult jsonData = null;
            try
            {
                switch (oper)
                {
                    case "edit":
                        if (oDeducciones.accionregistro == 0)
                        {
                            oDeducciones.accionregistro = 2;
                        }
                        break;
                    case "add":
                        oDeducciones.accionregistro = 1;
                        oDeducciones.id = Math.Abs(Guid.NewGuid().GetHashCode());
                        break;
                    case "del":
                        if (oDeducciones.accionregistro == 1)
                        {
                            oDeducciones.accionregistro = 0;
                        }
                        else
                        {
                            oDeducciones.accionregistro = 3;
                        }
                        break;
                }
                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oDeducciones, estadoValidacion = "exito" });
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
        public JsonResult EditarDetallePartidos(DetallePartidos oDetallePartido, Deducciones[] oDeducciones)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");

                DetallePartidos oDetallePartidoEditado = (from d in bdTorneos.DetallePartidos
                                             where d.id == oDetallePartido.id
                                             select d).Single();
                oDetallePartidoEditado.estado = (int)enumEstadoDetallePartidos.Pagado;
                oDetallePartidoEditado.total_pagar = oDetallePartido.total_pagar;
                oDetallePartidoEditado.total_rebajos = oDetallePartido.total_rebajos;
                oDetallePartidoEditado.deposito = oDetallePartido.deposito;

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oDetallePartidoEditado);


                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oDetallePartidoEditado, estadoValidacion = "exito" });


                foreach (Deducciones oDeduccion in oDeducciones)
                {
                    EditarDeducciones(oDeduccion, oDetallePartidoEditado.id);
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
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public void EditarDeducciones(Deducciones oDeducciones, int idDetallePartido)
        {
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
            switch (oDeducciones.accionregistro)
            {
                case 1:
                    Deducciones oDeduccionesNuevo = new Deducciones();
                    oDeduccionesNuevo.idDetallePartido = idDetallePartido;
                    oDeduccionesNuevo.descripcion = oDeducciones.descripcion;
                    oDeduccionesNuevo.monto = oDeducciones.monto;
                    oDeduccionesNuevo.observaciones = oDeducciones.observaciones;


                    bdTorneos.AddToDeducciones(oDeduccionesNuevo);
                    bdTorneos.SaveChanges();

                    break;
                case 3:
                    Deducciones oDeduccionesEliminado = (from t in bdTorneos.Deducciones
                                                    where t.id == oDeducciones.id
                                                    select t).Single();

                    bdTorneos.DeleteObject(oDeduccionesEliminado);
                    bdTorneos.SaveChanges();
                    break;
                case 2:
                    Deducciones oDeduccionesEditado = (from t in bdTorneos.Deducciones
                                                where t.id == oDeducciones.id
                                                select t).Single();

                    oDeduccionesEditado.descripcion = oDeducciones.descripcion;
                    oDeduccionesEditado.monto = oDeducciones.monto;
                    oDeduccionesEditado.observaciones = oDeducciones.observaciones;

                    bdTorneos.SaveChanges();
                           
                    break;
            }
        }
    }
}
