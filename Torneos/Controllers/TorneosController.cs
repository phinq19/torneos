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
        [Autorizado]
        public ActionResult Index()
        {
            return View("Torneos");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult ObtenerTorneos()
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    rows = (from  oTorneo in bdTorneos.Torneos
                            where oTorneo.idAsociacion == idAsociacion
                            select new
                            {
                                id = oTorneo.id,
                                nombre = oTorneo.nombre,
                                categoria = oTorneo.categoria,
                                telefono1 = oTorneo.telefono1,
                                ubicacion = oTorneo.ubicacion,
                                telefono2 = oTorneo.telefono2,
                                dieta = oTorneo.dieta,
                                observaciones = oTorneo.observaciones/*,
                                Torneos_Canchas = from c in oTorneo.Torneos_Canchas
                                                  select new
                                                  {
                                                      id = c.id,
                                                      idCancha = c.idCancha,
                                                      viaticos = c.viaticos,
                                                      observaciones = c.observaciones
                                                  }*/
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
        [Autorizado]
        public JsonResult ValidarTorneoCanchas(Torneos_Canchas oCancha, String oper)
        {
            JsonResult jsonData = null;
            try
            {
                switch(oper){
                    case"edit": 
                        if(oCancha.accionregistro == 0){
                            oCancha.accionregistro = 2;
                        }
                        break;
                    case "add":
                        oCancha.accionregistro = 1;
                        oCancha.id = Math.Abs(Guid.NewGuid().GetHashCode());
                        break;
                    case "del":
                        if (oCancha.accionregistro == 1)
                        {
                            oCancha.accionregistro = 0;
                        }
                        else {
                            oCancha.accionregistro = 3;
                        }
                        break;
                }
                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oCancha, estadoValidacion = "exito" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult EditarTorneos(Torneos oTorneo, Torneos_Canchas[] oCanchas, String oper)
        {
            int nIDTorneos = 0;
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                int nContador = (from t in bdTorneos.Torneos
                                    where  t.nombre == oTorneo.nombre &&
                                        t.id != oTorneo.id &&
                                        t.idAsociacion == idAsociacion
                                    select t.id
                                ).Count();
                if (nContador > 0)
                {
                    return jsonData = Json(new { estado = "exito", mensaje = "Ya existe un Torneo con el nombre: " + oTorneo.nombre, estadoValidacion = "falloLlave" });
                }
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
                        oTorneosNuevo.idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                        oTorneosNuevo.id = 0;

                        bdTorneos.AddToTorneos(oTorneosNuevo);
                        bdTorneos.SaveChanges();
                        bdTorneos.Detach(oTorneosNuevo);
                        nIDTorneos = oTorneosNuevo.id;

                        jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosNuevo, estadoValidacion = "exito" });

                        break;
                    case "del":
                        Torneos oTorneosEliminado = (from t in bdTorneos.Torneos
                                                        where t.id == oTorneo.id
                                                        select t).Single();

                        jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosEliminado, estadoValidacion = "exito" });

                        bdTorneos.DeleteObject(oTorneosEliminado);
                        bdTorneos.SaveChanges();
                        nIDTorneos = oTorneosEliminado.id;
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
                        nIDTorneos = oTorneosEditado.id;

                        jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oTorneosEditado, estadoValidacion = "exito" });
                        break;
                }
                //foreach (Torneos_Canchas oCancha in oTorneo.Torneos_Canchas) {oCanchas
                foreach (Torneos_Canchas oCancha in oCanchas) {
                    EditarTorneosCanchas(oCancha, nIDTorneos);
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
        public void EditarTorneosCanchas(Torneos_Canchas oCancha, int nIDTorneo)
        {
            BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
            switch (oCancha.accionregistro)
            {
                case 1:
                    Torneos_Canchas oCanchaNuevo = new Torneos_Canchas();
                    oCanchaNuevo.viaticos = oCancha.viaticos;
                    oCanchaNuevo.idCancha = oCancha.idCancha;
                    oCanchaNuevo.observaciones = oCancha.observaciones;
                    oCanchaNuevo.idTorneo = nIDTorneo;
                    oCanchaNuevo.id = 0;


                    bdTorneos.AddToTorneos_Canchas(oCanchaNuevo);
                    bdTorneos.SaveChanges();

                    break;
                case 3:
                    Torneos_Canchas oCanchaEliminado = (from t in bdTorneos.Torneos_Canchas
                                                    where t.id == oCancha.id
                                                    select t).Single();

                    bdTorneos.DeleteObject(oCanchaEliminado);
                    bdTorneos.SaveChanges();
                    break;
                case 2:
                    Torneos_Canchas oCanchaEditado = (from t in bdTorneos.Torneos_Canchas
                                                where t.id == oCancha.id
                                                select t).Single();

                    oCanchaEditado.idCancha = oCancha.idCancha;
                    oCanchaEditado.viaticos = oCancha.viaticos;
                    oCanchaEditado.observaciones = oCancha.observaciones;

                    bdTorneos.SaveChanges();
                           
                    break;
            }
        }
    }
}
