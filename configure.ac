AC_INIT([mee], [0.1], [inizan.yannick@gmail.com], [libmee])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([check-news dist-bzip2 subdir-objects])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
AC_CONFIG_FILES([Makefile
		doc/Makefile
		src/Makefile
		mee.pc])

AM_PROG_AR
LT_INIT
AC_PROG_CC
AM_PROG_VALAC

pkg_modules="glib-2.0 >= 2.24.1
             gobject-2.0 >= 2.24.1
             gee-0.8"
PKG_CHECK_MODULES(GEE, [$pkg_modules])
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

AC_SUBST(MEE_CFLAGS)
AC_SUBST(MEE_LIBS)

AC_ARG_ENABLE(doc, AS_HELP_STRING([--enable-doc], [Enable documentation generation]), enable_doc=$enableval, enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test x$enable_doc = xyes)

AS_IF([test "x$enable_doc" != xno],
	[AC_PATH_PROG(VALADOC, valadoc, :)
	 AC_SUBST(VALADOC)
	 AS_IF([test "$VALADOC" = :],
		[AC_MSG_ERROR([valadoc not found])])])

GOBJECT_INTROSPECTION_CHECK([0.9.0])

AC_OUTPUT
