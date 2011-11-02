﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class VerificacionesController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        public ActionResult Index()
        {
            return View("Verificaciones");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult ObtenerProgramaciones(int estado)
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
                    rows = (from oProgramaciones in bdTorneos.Programaciones
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