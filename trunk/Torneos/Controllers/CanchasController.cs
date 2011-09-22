﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos.Controllers
{
    public class CanchasController : Controller
    {
        public ActionResult Index()
        {
            return View("Canchas");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ObtenerCanchas(string sidx, string sord, int page, int rows)
        {
            JsonResult jsonData = null;
            try
            {
                List<Canchas> oCanchas;
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                IQueryable<Canchas> canchas = from t in bdTorneos.Canchas
                                               select t;
                oCanchas = canchas.ToList();

                string orderBytext = "";
                orderBytext = string.Format("it.{0} {1}", sidx, sord);
                var pageIndex = Convert.ToInt32(page) - 1;
                var filas = rows;
                var totalFilas = oCanchas.Count();
                var totalPaginas = (int)Math.Ceiling((float)totalFilas / (float)filas);
                jsonData = Json(new
                {
                    total = totalPaginas,
                    page = page,
                    records = totalFilas,
                    rows = (
                        from u in oCanchas
                        select new
                        {
                            id = u.id,
                            nombre = u.nombre,
                            observaciones = u.observaciones,
                            correo = u.ubicacion
                        }
                        ).ToList().Skip((page - 1) * filas).Take(filas)
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
        public JsonResult EditarCanchas(Usuarios oUsuario, String oper)
        {
            JsonResult jsonData = null;
            if (HttpContext.Request.IsAuthenticated)
            {
                try
                {
                    BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                    switch (oper)
                    {
                        case "add":
                            Usuarios oUsuarioNuevo = new Usuarios();
                            oUsuarioNuevo.codigo = oUsuario.codigo;
                            oUsuarioNuevo.contrasena = Utilidades.CalcularMD5("123456");
                            oUsuarioNuevo.correo = oUsuario.correo;
                            oUsuarioNuevo.cuenta = oUsuario.cuenta;
                            oUsuarioNuevo.nombre = oUsuario.nombre;
                            oUsuarioNuevo.observaciones = oUsuario.observaciones;
                            oUsuarioNuevo.telefono1 = oUsuario.telefono1;
                            oUsuarioNuevo.telefono2 = oUsuario.telefono2;
                            oUsuarioNuevo.tipo = 1;
                            oUsuarioNuevo.idAsociacion = 1;
                            oUsuarioNuevo.id = 0;

                            bdTorneos.AddToUsuarios(oUsuarioNuevo);
                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oUsuarioNuevo);

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oUsuarioNuevo, estadoValidacion = "exito" });

                            break;
                        case "del":
                            Usuarios oUsuarioEliminado = (from u in bdTorneos.Usuarios
                                                         where u.id == oUsuario.id
                                                         select u).Single();

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oUsuarioEliminado, estadoValidacion = "exito" });

                            bdTorneos.DeleteObject(oUsuarioEliminado);
                            bdTorneos.SaveChanges();
                            break;
                        case "edit":
                            Usuarios oUsuarioEditado = (from u in bdTorneos.Usuarios
                                                       where u.id == oUsuario.id
                                                       select u).Single();

                            oUsuarioEditado.codigo = oUsuario.codigo;
                            oUsuarioEditado.correo = oUsuario.correo;
                            oUsuarioEditado.cuenta = oUsuario.cuenta;
                            oUsuarioEditado.nombre = oUsuario.nombre;
                            oUsuarioEditado.observaciones = oUsuario.observaciones;
                            oUsuarioEditado.telefono1 = oUsuario.telefono1;
                            oUsuarioEditado.telefono2 = oUsuario.telefono2;
                            oUsuarioEditado.tipo = 1;

                            bdTorneos.SaveChanges();
                            bdTorneos.Detach(oUsuarioEditado);

                            jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oUsuario, estadoValidacion = "exito" });
                            break;
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
    }
}
