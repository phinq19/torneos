using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Torneos;

namespace Torneos.Controllers
{
    public class ProgramacionesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Authorize]
        public ActionResult Index()
        {
            return View("Programaciones");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ObtenerProgramaciones()
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    rows = (from oProgramaciones in bdTorneos.Programaciones
                            select new
                            {
                                oProgramaciones.id,
                                oProgramaciones.deposito,
                                oProgramaciones.estado,
                                oProgramaciones.idTorneo,
                                oProgramaciones.idUsuario,
                                oProgramaciones.monto,
                                oProgramaciones.observaciones
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
        public JsonResult ObtenerProgramacionPorID(int cID) {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                Programaciones oProgramacion = (from p in bdTorneos.Programaciones
                              where p.id == cID
                              select p).Single();

                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    oProgramacion = new {
                                oProgramacion.id,
                                oProgramacion.monto,
                                oProgramacion.idUsuario,
                                oProgramacion.idTorneo,
                                oProgramacion.estado,
                                oProgramacion.deposito,
                                oProgramacion.observaciones,
                                Partidos = from oPartidos in oProgramacion.Partidos
                                                  select new
                                                  {
                                                      oPartidos.id,
                                                      oPartidos.coordinador,
                                                      oPartidos.estado,
                                                      oPartidos.fecha_hora,
                                                      oPartidos.idCancha,
                                                      oPartidos.telefono_coordinador,
                                                      oPartidos.equipos,
                                                      oPartidos.observaciones,
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
        public JsonResult ValidarPartidos(Partidos oPartido, String oper)
        {
            JsonResult jsonData = null;
            if (HttpContext.Request.IsAuthenticated)
            {
                try
                {
                    switch(oper){
                        case"edit": 
                            if(oPartido.accionregistro == 0){
                                oPartido.accionregistro = 2;
                            }
                            /*
                            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                            Partidos oPartidoEditado = (from p in bdTorneos.Partidos
                                                where p.id == oPartido.id
                                                select p).Single();

                            oPartidoEditado.idPartido = oPartido.idPartido;
                            oPartidoEditado.viaticos = oPartido.viaticos;
                            oPartidoEditado.observaciones = oPartido.observaciones;
                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oPartidoEditado);
                            */
                            break;
                        case "add":
                            oPartido.accionregistro = 1;
                            oPartido.id = Math.Abs(Guid.NewGuid().GetHashCode());
                            break;
                        case "del":
                            if (oPartido.accionregistro == 1)
                            {
                                oPartido.accionregistro = 0;
                            }
                            else {
                                oPartido.accionregistro = 3;
                            }
                            break;
                    }
                    jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oPartido, estadoValidacion = "exito" });
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

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult EditarProgramaciones(Programaciones oProgramacion, Partidos[] oPartidos, String oper)
        {
            int nIDProgramacion = 0;
            JsonResult jsonData = null;
            if (HttpContext.Request.IsAuthenticated)
            {
                try
                {
                    BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                    switch (oper)
                    {
                        case "add":
                            Programaciones oProgramacionNuevo = new Programaciones();
                            oProgramacionNuevo.observaciones = oProgramacion.observaciones;
                            oProgramacionNuevo.idAsociacion = 1;
                            oProgramacionNuevo.id = 0;

                            bdTorneos.AddToProgramaciones(oProgramacionNuevo);
                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oProgramacionNuevo);
                            nIDProgramacion = oProgramacionNuevo.id;

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oProgramacionNuevo, estadoValidacion = "exito" });

                            break;
                        case "del":
                            Programaciones oTorneosEliminado = (from p in bdTorneos.Programaciones
                                                         where p.id == oProgramacion.id
                                                         select p).Single();

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosEliminado, estadoValidacion = "exito" });

                            bdTorneos.DeleteObject(oTorneosEliminado);
                            bdTorneos.SaveChanges();
                            nIDProgramacion = oTorneosEliminado.id;
                            break;
                        case "edit":
                            Programaciones oProgramacionEditado = (from p in bdTorneos.Programaciones
                                                       where p.id == oProgramacion.id
                                                       select p).Single();

                            oProgramacionEditado.observaciones = oProgramacion.observaciones;
                            

                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oProgramacionEditado);
                            nIDProgramacion = oProgramacionEditado.id;

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oProgramacionEditado, estadoValidacion = "exito" });
                            break;
                    }
                    foreach (Partidos oPartido in oPartidos) {
                        EditarPartidos(oPartido, nIDProgramacion);
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

        //[AcceptVerbs(HttpVerbs.Post)]
        //[Authorize]
        public void EditarPartidos(Partidos oPartido, int nIDProgramacion)
        {
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
            switch (oPartido.accionregistro)
            {
                case 1:
                    Partidos oPartidoNuevo = new Partidos();
                    
                    oPartidoNuevo.observaciones = oPartido.observaciones;
                    oPartidoNuevo.idProgramacion = nIDProgramacion;
                    oPartidoNuevo.id = 0;


                    bdTorneos.AddToPartidos(oPartidoNuevo);
                    bdTorneos.SaveChanges();

                    break;
                case 3:
                    Partidos oPartidoEliminado = (from p in bdTorneos.Partidos
                                                    where p.id == oPartido.id
                                                    select p).Single();

                    bdTorneos.DeleteObject(oPartidoEliminado);
                    bdTorneos.SaveChanges();
                    break;
                case 2:
                    Partidos oPartidoEditado = (from p in bdTorneos.Partidos
                                                where p.id == oPartido.id
                                                select p).Single();

                    
                    oPartidoEditado.observaciones = oPartido.observaciones;

                    bdTorneos.SaveChanges();
                           
                    break;
            }
        }
    }
}
