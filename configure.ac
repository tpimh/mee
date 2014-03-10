dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(libmee, 1.0)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([check-news dist-bzip2 subdir-objects])

AM_SILENT_RULES([yes])

AC_PROG_CC

AM_PROG_AR

AM_PROG_VALAC

LT_INIT

AC_CHECK_HEADER(magic.h, ,[AC_MSG_ERROR(Could not find magic.h !)])

PKG_CHECK_MODULES(MEE, gee-0.8 [gio-2.0 glib-2.0 gobject-2.0 ])

AC_ARG_ENABLE(doc, AS_HELP_STRING([--enable-doc], [Enable documentation generation]), enable_doc=$enableval, enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test x$enable_doc = xyes)

AS_IF([test "x$enable_doc" != xno],
	[AC_PATH_PROG(VALADOC, valadoc, :)
	 AC_SUBST(VALADOC)
	 AS_IF([test "$VALADOC" = :],
		[AC_MSG_ERROR([valadoc not found])])])

GOBJECT_INTROSPECTION_CHECK([0.9.0])

AC_OUTPUT([
Makefile
doc/Makefile
src/mee-1.0.pc
src/Makefile])
