ACLOCAL_AMFLAGS = -I m4
    SUBDIRS = src
    EXTRA_DIST = autogen.sh
    
AM_DISTCHECK_CONFIGURE_FLAGS = --enable-introspection=no

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = mee.pc

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee.deps
