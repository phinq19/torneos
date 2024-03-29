USE [master]
GO
/****** Object:  Database [Asociacion]    Script Date: 11/16/2011 10:37:16 ******/
CREATE DATABASE [Asociacion] ON  PRIMARY 
( NAME = N'Asociacion', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.PCABEL\MSSQL\DATA\Asociacion.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Asociacion_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.PCABEL\MSSQL\DATA\Asociacion_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Asociacion] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Asociacion].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Asociacion] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [Asociacion] SET ANSI_NULLS OFF
GO
ALTER DATABASE [Asociacion] SET ANSI_PADDING OFF
GO
ALTER DATABASE [Asociacion] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [Asociacion] SET ARITHABORT OFF
GO
ALTER DATABASE [Asociacion] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [Asociacion] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [Asociacion] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [Asociacion] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [Asociacion] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [Asociacion] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [Asociacion] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [Asociacion] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [Asociacion] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [Asociacion] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [Asociacion] SET  DISABLE_BROKER
GO
ALTER DATABASE [Asociacion] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [Asociacion] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [Asociacion] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [Asociacion] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [Asociacion] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [Asociacion] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [Asociacion] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Asociacion] SET  READ_WRITE
GO
ALTER DATABASE [Asociacion] SET RECOVERY SIMPLE
GO
ALTER DATABASE [Asociacion] SET  MULTI_USER
GO
ALTER DATABASE [Asociacion] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [Asociacion] SET DB_CHAINING OFF
GO
USE [Asociacion]
GO
/****** Object:  Table [dbo].[LineasCredito]    Script Date: 11/16/2011 10:37:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LineasCredito](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](128) NOT NULL,
	[plazo] [varchar](64) NOT NULL,
	[interes] [numeric](16, 6) NOT NULL,
 CONSTRAINT [PK_LineasCredito] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 11/16/2011 10:37:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuarios](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](256) NOT NULL,
	[cedula] [varchar](64) NOT NULL,
	[contrasena] [varchar](1024) NOT NULL,
	[correo] [varchar](256) NOT NULL,
	[tipo] [int] NOT NULL,
	[activo] [bit] NOT NULL,
	[activoContrasena] [bit] NOT NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Solicitudes]    Script Date: 11/16/2011 10:37:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Solicitudes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [int] NOT NULL,
	[idLinea] [int] NOT NULL,
	[fecha] [date] NOT NULL,
	[cuota] [numeric](16, 6) NOT NULL,
	[estado] [int] NOT NULL,
 CONSTRAINT [PK_Solicitudes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Operaciones]    Script Date: 11/16/2011 10:37:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Operaciones](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [int] NOT NULL,
	[documento] [varchar](256) NOT NULL,
	[fecharEmision] [date] NOT NULL,
	[montoPrincipal] [numeric](16, 6) NOT NULL,
	[saldoActual] [numeric](16, 6) NOT NULL,
	[tipo] [int] NOT NULL,
	[cuota] [numeric](16, 6) NOT NULL,
	[observaciones] [varchar](512) NOT NULL,
 CONSTRAINT [PK_Operaciones] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK_Solicitudes_Lineas]    Script Date: 11/16/2011 10:37:17 ******/
ALTER TABLE [dbo].[Solicitudes]  WITH CHECK ADD  CONSTRAINT [FK_Solicitudes_Lineas] FOREIGN KEY([idLinea])
REFERENCES [dbo].[LineasCredito] ([id])
GO
ALTER TABLE [dbo].[Solicitudes] CHECK CONSTRAINT [FK_Solicitudes_Lineas]
GO
/****** Object:  ForeignKey [FK_Solicitudes_Usuarios]    Script Date: 11/16/2011 10:37:17 ******/
ALTER TABLE [dbo].[Solicitudes]  WITH CHECK ADD  CONSTRAINT [FK_Solicitudes_Usuarios] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuarios] ([id])
GO
ALTER TABLE [dbo].[Solicitudes] CHECK CONSTRAINT [FK_Solicitudes_Usuarios]
GO
/****** Object:  ForeignKey [FK_Operaciones_Usuarios]    Script Date: 11/16/2011 10:37:17 ******/
ALTER TABLE [dbo].[Operaciones]  WITH CHECK ADD  CONSTRAINT [FK_Operaciones_Usuarios] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuarios] ([id])
GO
ALTER TABLE [dbo].[Operaciones] CHECK CONSTRAINT [FK_Operaciones_Usuarios]
GO
