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
	xml/xml.vala xml/xml.node.vala xml/xml.doc.vala
	
libmee_la_VALAFLAGS = --library mee -H mee.h --pkg gmodule-2.0 --pkg posix -X -lm --disable-warnings

libmee_la_SOURCES = mee.vala.stamp $(libmee_la_VALASOURCES:.vala=.c)

mee.vapi mee.vala.stamp: $(libmee_la_VALASOURCES)
	$(VALAC) $(libmee_la_VALASOURCES) -C $(libmee_la_VALAFLAGS)
	
EXTRA_DIST = $(libmee_la_VALASOURCES) mee.vapi mee.vala.stamp

CLEANFILES = *.h *.c feed/*.c xml/*.c collections/*.c json/*.c Makefile mee.vapi *.stamp Makefile.in
