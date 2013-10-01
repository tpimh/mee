AM_CPPFLAGS = $(GEE_CFLAGS)
	
lib_LTLIBRARIES = libmee.la

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee.vapi

meeincludedir = $(includedir)
meeinclude_HEADERS = mee.h

libmee_la_LIBADD = $(GEE_LIBS)

libmee_la_SOURCES = math.vala mee.vala encoding.vala string.vala date.vala value.vala
	
libmee_la_VALAFLAGS = --library mee -H mee.h --pkg gmodule-2.0 --pkg posix --pkg gee-0.8 --disable-warnings --gir Mee-0.1.gir

Mee-0.1.gir mee.vapi: libmee.la
	
if HAVE_INTROSPECTION
girdir = @INTROSPECTION_GIRDIR@

gir_DATA = \
	Mee-0.1.gir \
	$(NULL)

typelibdir = @INTROSPECTION_TYPELIBDIR@
typelib_DATA = \
	Mee-0.1.typelib \
	$(NULL)

Mee-0.1.typelib: Mee-0.1.gir
	@INTROSPECTION_COMPILER@ -o $@ $^
endif
	
EXTRA_DIST = $(libmee_la_SOURCES) Mee-0.1.gir mee.vapi

CLEANFILES = *.h *.c mee.vapi *.stamp *.gir *.typelib
