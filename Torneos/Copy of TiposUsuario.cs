using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos
{
    public enum TipoUsuario
    {
        SuperAdministrado = 0,
        EncargadoTorneo,
        EncargadoAsociacion,
        Tesorero,
        Arbitro,
        Administrador
    }
}
