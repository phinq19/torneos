using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class DisponibilidadController : Controller
    {
        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
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

                bdTorneos.SaveChanges();
                bdTorneos.Detach(oDisponibilidadEditado);


                jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oDisponibilidadEditado, estadoValidacion = "exito" });
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }
    }
}
