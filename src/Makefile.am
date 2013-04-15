AM_CPPFLAGS = $(MY_CFLAGS)

AM_CFLAGS = `pkg-config --cflags --libs glib-2.0 libsoup-2.4 json-glib-1.0` \
	-Wall

BUILT_SOURCES = my.vala.stamp

lib_LTLIBRARIES = libmy.la

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = my.vapi

myincludedir = $(includedir)
myinclude_HEADERS = my.h

libmy_la_VALASOURCES = my.bytevector.vala \
	my.dictionary.vala \
	my.convert.vala \
	my.entry.vala \
	my.functions.vala \
	my.idictionary.vala \
	my.iequatable.vala \
	my.ilist.vala \
	my.iterable.vala \
	my.list.vala \
	my.ptrlist.vala \
	io/my.io.vala \
	media/my.video.vala
	
libmy_la_VALAFLAGS = --library my -H my.h --pkg libsoup-2.4 --pkg json-glib-1.0

libmy_la_SOURCES = my.vala.stamp $(libmy_la_VALASOURCES:.vala=.c)

my.vapi my.vala.stamp: $(libmy_la_VALASOURCES)
	$(VALAC) $(libmy_la_VALASOURCES) -C $(libmy_la_VALAFLAGS)
	
EXTRA_DIST = $(libmy_la_VALASOURCES) my.vapi my.vala.stamp

CLEANFILES = *.h *.c media/*.c io/*.c *.vapi *.stamp Makefile.in
