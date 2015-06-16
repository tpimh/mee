## Process this file with automake to produce Makefile.in

## Created by Anjuta


lib_LTLIBRARIES = libmee.la

libmee_la_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

libmee_la_CFLAGS = -w -lmagic $(MEE_CFLAGS)

libmee_la_SOURCES = mee.vala math.vala error.vala bitconverter.vala timespan.vala \
	value.vala date.vala date.vapi guid.vala contenttype.vala uri.vala \
	text/encoding.vala text/textreader.vala text/stringreader.vala text/streamreader.vala \
	text/textwriter.vala text/stringwriter.vala text/streamwriter.vala

libmee_la_LDFLAGS = -version-info 1:1:1
	
libmee_la_VALAFLAGS = --library mee-1.0 --vapi mee-1.0.vapi -H mee.h --gir Mee-1.0.gir \
	--pkg gio-2.0 --pkg libmagic --pkg posix --vapidir . --disable-warnings

libmee_la_LIBADD = $(MEE_LIBS)

meeincludedir = $(includedir)/mee-1.0
meeinclude_HEADERS = mee.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = mee-1.0.pc

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee-1.0.vapi mee-1.0.deps

EXTRA_DIST = \
	mee-1.0.pc.in
	
if HAVE_INTROSPECTION
girdir = $(datadir)/gir-1.0

gir_DATA = \
	Mee-1.0.gir \
	$(NULL)

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = \
	Mee-1.0.typelib \
	$(NULL)

Mee-1.0.typelib: Mee-1.0.gir
	@INTROSPECTION_COMPILER@ -l libmee.so.0 -o $@ $^
endif
	
CLEANFILES = *.c *.o  text/*.c text/*.o *.stamp mee-1.0.vapi mee.h *.gir *.typelib

DISTCLEANFILES = $(CLEANFILES) mee-1.0.pc Makefile
