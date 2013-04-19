AC_PREREQ([2.65])
AC_INIT([my],[1.0],[inizan.yannick@gmail.com])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE
AC_CONFIG_FILES([Makefile
		src/Makefile])

AM_PROG_VALAC
AM_PROG_AR
LT_INIT
AC_PROG_CC

pkg_modules="glib-2.0 >= 2.24.1
             gobject-2.0 >= 2.24.1"
PKG_CHECK_MODULES(GLIB, [$pkg_modules])

AC_SUBST(MY_CFLAGS)
AC_SUBST(MY_LIBS)

AC_OUTPUT
