using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ArconWeb.Filter;

namespace Torneos.Controllers
{
    public class DisponibilidadController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public ActionResult Index()
        {
            if ((enumTipoUsuario)Utilidades.ObtenerValorSession("tipoUsuario") != enumTipoUsuario.Arbitro)
            {
                ViewData.Add("Error", "No puede entrar a la página de Disponibilidad, necesita ser del tipo de usuario árbitro");
                return View("PaginaError");
            }
            else
            {
                return View("Disponibilidad");
            }
        }


        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        [CompressFilter(Order = 1)]
        [CacheFilter(Duration = 60, Order = 2)]
        public JsonResult ObtenerDisponibilidad()
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idUsuario = Utilidades.ObtenerValorSession("idUsuario");
                jsonData = Json(new
                {
                    estado = "exito",
                    mensaje = "",
                    oDisponibilidad = (
                        from d in bdTorneos.Disponibilidad
                        where d.idArbitro == idUsuario
                        select new
                        {
                            d.id,
                            d.idArbitro,
                            lunes = d.lunes == 1 ? true : false,
                            martes = d.martes == 2 ? true : false,
                            miercoles = d.miercoles == 3 ? true : false,
                            jueves = d.jueves == 4 ? true : false,
                            viernes = d.viernes == 5 ? true : false,
                            sabado = d.sabado == 6 ? true : false,
                            domingo = d.domingo == 7 ? true : false,
                            d.tiempoLunes,
                            d.tiempoMartes,
                            d.tiempoMiercoles,
                            d.tiempoJueves,
                            d.tiempoViernes,
                            d.tiempoSabado,
                            d.tiempoDomingo
                        }   
                    ).Single()
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
        public JsonResult EditarDisponibilidad(Disponibilidad oDisponibilidad)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();


                Disponibilidad oDisponibilidadEditado = (from t in bdTorneos.Disponibilidad
                                             where t.id == oDisponibilidad.id
                                             select t).Single();
                oDisponibilidadEditado.lunes = oDisponibilidad.lunes;
                oDisponibilidadEditado.martes = oDisponibilidad.martes;
                oDisponibilidadEditado.miercoles = oDisponibilidad.miercoles;
                oDisponibilidadEditado.jueves = oDisponibilidad.jueves;
                oDisponibilidadEditado.viernes = oDisponibilidad.viernes;
                oDisponibilidadEditado.sabado = oDisponibilidad.sabado;
                oDisponibilidadEditado.domingo = oDisponibilidad.domingo;
                oDisponibilidadEditado.tiempoLunes = oDisponibilidad.tiempoLunes;
                oDisponibilidadEditado.tiempoMartes = oDisponibilidad.tiempoMartes;
                oDisponibilidadEditado.tiempoMiercoles = oDisponibilidad.tiempoMiercoles;
                oDisponibilidadEditado.tiempoJueves = oDisponibilidad.tiempoJueves;
                oDisponibilidadEditado.tiempoViernes = oDisponibilidad.tiempoViernes;
                oDisponibilidadEditado.tiempoSabado = oDisponibilidad.tiempoSabado;
                oDisponibilidadEditado.tiempoDomingo = oDisponibilidad.tiempoDomingo;

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oDisponibilidadEditado);

                var oResultado = new
                {
                    oDisponibilidadEditado.id,
                    oDisponibilidadEditado.idArbitro,
                    lunes = oDisponibilidadEditado.lunes == 1 ? true : false,
                    martes = oDisponibilidadEditado.martes == 2 ? true : false,
                    miercoles = oDisponibilidadEditado.miercoles == 3 ? true : false,
                    jueves = oDisponibilidadEditado.jueves == 4 ? true : false,
                    viernes = oDisponibilidadEditado.viernes == 5 ? true : false,
                    sabado = oDisponibilidadEditado.sabado == 6 ? true : false,
                    domingo = oDisponibilidadEditado.domingo == 7 ? true : false,
                    oDisponibilidadEditado.tiempoLunes,
                    oDisponibilidadEditado.tiempoMartes,
                    oDisponibilidadEditado.tiempoMiercoles,
                    oDisponibilidadEditado.tiempoJueves,
                    oDisponibilidadEditado.tiempoViernes,
                    oDisponibilidadEditado.tiempoSabado,
                    oDisponibilidadEditado.tiempoDomingo
                };
                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oResultado, estadoValidacion = "exito" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }
    }
}
