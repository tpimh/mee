AM_CPPFLAGS = $(MEE_CFLAGS)

AM_CFLAGS = `pkg-config --cflags --libs glib-2.0 gmodule-2.0` \
	-w

BUILT_SOURCES = mee.vala.stamp

lib_LTLIBRARIES = libmee.la

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee.vapi

meeincludedir = $(includedir)
meeinclude_HEADERS = mee.h

libmee_la_VALASOURCES = math.vala mee.vala mee_internal.vapi object.vala string.vala \
	date.vala value.vala picture.vala query.vala \
	json/json.vala json/json.array.vala json/json.object.vala json/json.node.vala \
	collections/arraylist.vala collections/dictionary.vala \
	collections/interfaces.vala collections/set.vala \
	xml/xml.vala xml/xml.node.vala xml/xml.doc.vala xml/html.doc.vala xml/html.node.vala \
	io/contenttype.vala io/file.vala io/fileinfo.vala io/path.vala \
	net/host.vapi net/mee-net.vala
	
libmee_la_VALAFLAGS = --library mee -H mee.h --pkg gmodule-2.0 --pkg posix --disable-warnings --gir Mee-0.1.gir

libmee_la_SOURCES = mee.vala.stamp $(libmee_la_VALASOURCES:.vala=.c)

Mee-0.1.gir mee.vapi mee.vala.stamp: $(libmee_la_VALASOURCES)
	$(VALAC) $(libmee_la_VALASOURCES) -C $(libmee_la_VALAFLAGS)
	
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
	
EXTRA_DIST = $(libmee_la_VALASOURCES) Mee-0.1.gir mee.vapi mee.vala.stamp

CLEANFILES = *.h *.c feed/*.c xml/*.c collections/*.c json/*.c net/*.c io/*.c Makefile mee.vapi *.stamp Makefile.in
