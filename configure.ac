AC_INIT([mee], [0.1], [inizan.yannick@gmail.com], [libmee])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([check-news dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
AC_CONFIG_FILES([Makefile
		src/Makefile
		mee.pc])


LT_INIT
AC_PROG_CC
AM_PROG_VALAC

PKG_CHECK_MODULES(GEE, ["gee-0.8"])
AC_SUBST(GEE_CFLAGS)
AC_SUBST(GEE_LIBS)
pkg_modules="glib-2.0 >= 2.24.1
             gobject-2.0 >= 2.24.1
             gio-2.0 >= 2.24.1"
PKG_CHECK_MODULES(GLIB, [$pkg_modules])
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

AC_SUBST(MEE_CFLAGS)
AC_SUBST(MEE_LIBS)

AC_OUTPUT
