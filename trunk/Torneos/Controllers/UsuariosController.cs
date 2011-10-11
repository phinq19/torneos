using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Torneos.Controllers
{
    public class UsuariosController : Controller
    {

        [AcceptVerbs(HttpVerbs.Get)]
        [Autorizado]
        public ActionResult Index()
        {
            return View("Usuarios");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Autorizado]
        public JsonResult ObtenerUsuarios()
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                jsonData = Json(new{ 
                    estado = "exito", 
                    mensaje = "",
                    rows = (
                        from u in bdTorneos.Usuarios
                        where u.tipo != 0 && u.idAsociacion == idAsociacion
                        select new
                        {
                            id =  u.id,
                            nombre =  u.nombre,
                            telefono1 =  u.telefono1,
                            correo =   u.correo,
                            observaciones =   u.observaciones,
                            codigo =   u.codigo,
                            contrasena =   u.contrasena,
                            cuenta =  u.cuenta,
                            tipo = u.tipo,
                            idTorneo = u.idTorneo
                        }
                    )
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
        public JsonResult EditarUsuarios(Usuarios oUsuario, String oper)
        {
            JsonResult jsonData = null;
            try
            {
                BaseDatosTorneos bdTorneos = new BaseDatosTorneos();
                int idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
                int nContador = (from u in bdTorneos.Usuarios
                                    where  u.codigo == oUsuario.codigo && 
                                        u.id != oUsuario.id &&
                                        u.idAsociacion == idAsociacion
                                    select u.id
                                ).Count();
                if (nContador > 0)
                {    
                    return jsonData = Json(new { estado = "exito", mensaje = "Ya existe un Usuario con el código: " + oUsuario.codigo, estadoValidacion = "falloLlave" });
                }
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
                        oUsuarioNuevo.tipo = oUsuario.tipo;
                        oUsuarioNuevo.idTorneo = oUsuario.idTorneo;
                        oUsuarioNuevo.idAsociacion = Utilidades.ObtenerValorSession("idAsociacion");
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
                        oUsuarioEditado.tipo = oUsuario.tipo;
                        oUsuarioEditado.idTorneo = oUsuario.idTorneo;

                        bdTorneos.SaveChanges();
                        bdTorneos.Detach(oUsuarioEditado);

                        jsonData = Json(new { estado = "exito", mensaje = "", ObjetoDetalle = oUsuarioEditado, estadoValidacion = "exito" });
                        break;
                }
            }
            catch {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }
    }
}
