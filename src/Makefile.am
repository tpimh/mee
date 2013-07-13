AM_CPPFLAGS = $(MEE_CFLAGS)

AM_CFLAGS = `pkg-config --cflags --libs glib-2.0 gee-0.8` \
	-Wall

BUILT_SOURCES = mee.vala.stamp

lib_LTLIBRARIES = libmee.la

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee.vapi

meeincludedir = $(includedir)
meeinclude_HEADERS = mee.h

libmee_la_VALASOURCES = math.vala mee.vala mee_internal.vapi object.vala string.vala \
	linq.vala \
	json/json.vala json/json.object.vala json/json.array.vala json/json.node.vala \
	xml/doc.vala xml/element.vala xml/node.vala xml/html.doc.vala xml/html.node.vala
	
libmee_la_VALAFLAGS = --library mee -H mee.h --pkg gee-0.8 -X -lm

libmee_la_SOURCES = mee.vala.stamp $(libmee_la_VALASOURCES:.vala=.c)

mee.vapi mee.vala.stamp: $(libmee_la_VALASOURCES)
	$(VALAC) $(libmee_la_VALASOURCES) -C $(libmee_la_VALAFLAGS)
	
EXTRA_DIST = $(libmee_la_VALASOURCES) mee.vapi mee.vala.stamp

CLEANFILES = *.h *.c xml/*.c json/*.c mee.vapi *.stamp Makefile.in
