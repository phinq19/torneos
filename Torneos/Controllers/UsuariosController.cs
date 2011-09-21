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
        [Authorize]
        public ActionResult Index()
        {
            return View("Usuarios");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize]
        public JsonResult ObtenerUsuarios(string sidx, string sord, int page, int rows)
        {
            JsonResult jsonData = null;
            try
            {
                List<Usuario> oUsuarios;
                dbTorneos bdTorneos = new dbTorneos();
                IQueryable<Usuario> usuarios = from t in bdTorneos.Usuarios
                                                select t;
                oUsuarios = usuarios.ToList();
                
                string orderBytext = "";
                orderBytext = string.Format("it.{0} {1}", sidx, sord);
                var pageIndex = Convert.ToInt32(page) - 1;
                var filas = rows;
                var totalFilas = oUsuarios.Count();
                var totalPaginas = (int)Math.Ceiling((float)totalFilas / (float)filas);
                jsonData = Json(new{ 
                    total = totalPaginas,
                    page = page,
                    records = totalFilas,
                    rows = (
                        from u in oUsuarios
                        select new
                        {
                            //id = u.id,
                            //cell = new []{
                            id =  u.id,
                            nombre =  u.nombre,
                            telefono1 =  u.telefono1,
                            correo =   u.correo,
                            observaciones =   u.observaciones,
                            codigo =   u.codigo,
                            contrasena =   u.contrasena,
                            cuenta =  u.cuenta
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
        public JsonResult EditarUsuarios(Usuario oUsuario, String oper)
        {
            JsonResult jsonData = null;
            try
            {
                dbTorneos bdTorneos = new dbTorneos();
                switch (oper)
                {
                    case "add":
                        //Usuario oUsuarioNuevo = Usuario.CreateUsuario(0, 1, oUsuario.codigo, oUsuario.nombre, Utilidades.CalcularMD5("123456"), oUsuario.correo, oUsuario.telefono1, 1);
                        Usuario oUsuarioNuevo = new Usuario();
                        oUsuarioNuevo.codigo = oUsuario.codigo;
                        oUsuarioNuevo.contrasena = Utilidades.CalcularMD5("123456");
                        oUsuarioNuevo.correo = oUsuario.correo;
                        oUsuarioNuevo.cuenta  = oUsuario.cuenta;
                        oUsuarioNuevo.nombre = oUsuario.nombre;
                        oUsuarioNuevo.observaciones = oUsuario.observaciones;
                        oUsuarioNuevo.telefono1 = oUsuario.telefono1;
                        oUsuarioNuevo.telefono2 = oUsuario.telefono2;
                        oUsuarioNuevo.tipo = 1; 
                        oUsuarioNuevo.idAsociacion = 1;
                        oUsuarioNuevo.id = 0;

                        bdTorneos.AddToUsuarios(oUsuarioNuevo);
                        bdTorneos.SaveChanges();
                        break;
                    case "delete":
                        break;
                    case "edit":
                        var oUsuarioEditado = (from u in bdTorneos.Usuarios
                                                      where u.id == oUsuario.id 
                                                      select u).Single();
                        
                        //Usuario oUsuarioEditado = new Usuario();
                        oUsuarioEditado.codigo = oUsuario.codigo;
                        //oUsuarioEditado.contrasena = Utilidades.CalcularMD5("123456");
                        oUsuarioEditado.correo = oUsuario.correo;
                        oUsuarioEditado.cuenta  = oUsuario.cuenta;
                        oUsuarioEditado.nombre = oUsuario.nombre;
                        oUsuarioEditado.observaciones = oUsuario.observaciones;
                        oUsuarioEditado.telefono1 = oUsuario.telefono1;
                        oUsuarioEditado.telefono2 = oUsuario.telefono2;
                        oUsuarioEditado.tipo = 1; 
                        //oUsuarioEditado.idAsociacion = 1;
                        //oUsuarioEditado.id = oUsuario.id;

                        bdTorneos.Usuarios.Attach(oUsuarioEditado);
                        bdTorneos.SaveChanges();
                        
                        
                        break;
                }
            }
            catch
            {
                jsonData = Json(new { estado = "error", mensaje = "Error cargando datos" });
            }
            return jsonData;
        }
    }
}
