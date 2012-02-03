using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Principal;

namespace Torneos
{
    public class Autorizado : AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (httpContext == null)
            {
                throw new ArgumentNullException("httpContext");
            }
            IPrincipal user = httpContext.User;
            if (!user.Identity.IsAuthenticated)
            {
                return false;
            }

            if (httpContext.Session == null)
            {
                return false;
            }

            if (Utilidades.ObtenerValorSession("idUsuario") == 0 ||
                Utilidades.ObtenerValorSession("idAsociacion") == 0
                //Utilidades.ObtenerValorSession("tipoUsuario") == 0 ||
                //Utilidades.ObtenerValorSession("idTorneo") == 0||
                
            )
            {
                return false;
            }

            return true;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            if (filterContext.RequestContext.HttpContext.Request.IsAjaxRequest())
            {
                var oResultado = new
                {
                    //estado = "sesioninactiva",
                    estado = "exito", 
                    mensaje = "", 
                    estadoValidacion = "sinAutenticar" 
                };

                JsonResult UnauthorizedResult = new JsonResult();
                UnauthorizedResult.Data = oResultado;
                UnauthorizedResult.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
                filterContext.Result = UnauthorizedResult;
            }
            else
            {
                base.HandleUnauthorizedRequest(filterContext);
            }
        }
    }
}