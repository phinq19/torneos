﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Torneos
{
    public enum EstadoPartidos
    {
        Pendiente_Programacion,
        Programado,
        No_Jugado,
        Jugado,
        Con_Informe
    }
}
