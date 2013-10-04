ACLOCAL_AMFLAGS = -I m4

if ENABLE_DOC
DOC_SUBDIR = \
	doc \
	$(NULL)
endif

SUBDIRS = src $(DOC_SUBDIR)
    
AM_DISTCHECK_CONFIGURE_FLAGS = --enable-introspection=no

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = mee.pc

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee.deps
