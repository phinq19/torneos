using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Torneos;
using System.Globalization;

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
                int idTorneo = Utilidades.ObtenerValorSession("idTorneo");
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    rows = (from  oProgramaciones in bdTorneos.Programaciones
                            where oProgramaciones.idTorneo == idTorneo && 
                                  oProgramaciones.idAsociacion == idAsociacion
                            select new
                            {
                                oProgramaciones.id,
                                oProgramaciones.numero,
                                oProgramaciones.deposito,
                                oProgramaciones.estado,
                                oProgramaciones.idTorneo,
                                oProgramaciones.idUsuario,
                                oProgramaciones.monto,
                                oProgramaciones.observaciones
                            })
                });
            }
            catch (System.Data.UpdateException exc)
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
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
                                oProgramacion.numero,
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
                                                      oPartidos.numero,
                                                      oPartidos.coordinador,
                                                      oPartidos.estado,
                                                      oPartidos.fecha_hora,
                                                      oPartidos.idCancha,
                                                      oPartidos.telefono_coordinador,
                                                      oPartidos.equipos,
                                                      oPartidos.observaciones,
                                                      arbitros = 1,
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
        //[Authorize]
        public JsonResult ValidarCalcular(String oper, int idCancha = 0, int cantidad = 0, int id=0)
        {
            JsonResult jsonData = null;
            if (HttpContext.Request.IsAuthenticated)
            {
                try
                {
                    Decimal monto = 0;
                    Decimal viaticos = 0;
                    Decimal dieta = 0;
                    
                    if(oper == "edit" || oper == "add"){
                        BaseDatosTorneos bdTorneos = new BaseDatosTorneos();

                        int idTorneo = Utilidades.ObtenerValorSession("idTorneo");
                        Torneos oTorneo = (from t in bdTorneos.Torneos
                                           where t.id == idTorneo
                                           select t).Single<Torneos>();
                        Torneos_Canchas oCancha = (from t in bdTorneos.Torneos_Canchas
                                                   where t.idCancha == idCancha && t.idTorneo == idTorneo
                                                   select t).Single<Torneos_Canchas>();
                        viaticos = oCancha.viaticos;
                        dieta = oTorneo.dieta;
                        monto = (viaticos + dieta) * cantidad;
                    }
                    if(oper == "add")
                    {
                        id = Math.Abs(Guid.NewGuid().GetHashCode());
                        
                    }
                    jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = new {id, idCancha, viaticos, dieta, cantidad, monto }, estadoValidacion = "exito" });
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
        //[Authorize]
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
                            break;
                        case "add":
                            oPartido.numero = Utilidades.ObtenerConsecutivoPartido(DateTime.Now);
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
                            oProgramacionNuevo.deposito = oProgramacion.deposito;
                            oProgramacionNuevo.numero = Utilidades.ObtenerConsecutivoProgramacion();
                            oProgramacionNuevo.monto = oProgramacion.monto;
                            oProgramacionNuevo.observaciones = oProgramacion.observaciones;
                            oProgramacionNuevo.idTorneo = Utilidades.ObtenerValorSession("idTorneo");
                            oProgramacionNuevo.idUsuario = Utilidades.ObtenerValorSession("idUsuario");
                            oProgramacionNuevo.idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
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
                            oProgramacionEditado.deposito = oProgramacion.deposito;
                            oProgramacionEditado.monto = oProgramacion.monto;

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

                    oPartido.fecha_hora = DateTime.Now;

                    oPartidoNuevo.coordinador = oPartido.coordinador;
                    oPartidoNuevo.equipos = oPartido.equipos;
                    oPartidoNuevo.observaciones = oPartido.observaciones;
                    oPartidoNuevo.fecha_hora = oPartido.fecha_hora;
                    oPartidoNuevo.telefono_coordinador = oPartido.telefono_coordinador;
                    oPartidoNuevo.idCancha = oPartido.idCancha;
                    oPartidoNuevo.numero = Utilidades.ObtenerConsecutivoPartido(oPartido.fecha_hora);
                    oPartidoNuevo.idProgramacion = nIDProgramacion;
                    oPartidoNuevo.idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");;
                    oPartidoNuevo.id = 0;
                    oPartidoNuevo.estado = 0;

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

                    oPartidoEditado.coordinador = oPartido.coordinador;
                    oPartidoEditado.equipos = oPartido.equipos;
                    oPartidoEditado.observaciones = oPartido.observaciones;
                    //oPartidoEditado.fecha_hora = oPartido.fecha_hora;
                    oPartidoEditado.fecha_hora = DateTime.Now;
                    oPartidoEditado.telefono_coordinador = oPartido.telefono_coordinador;
                    oPartidoEditado.idCancha = oPartido.idCancha;
                    
                    bdTorneos.SaveChanges();
                           
                    break;
            }
        }

    }
}
