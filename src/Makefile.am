## Process this file with automake to produce Makefile.in

## Created by Anjuta

AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(MEE_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g -lmagic

lib_LTLIBRARIES = libmee.la


libmee_la_SOURCES = mee.vala math.vala error.vala array.vala bitconverter.vala encoding.vala string.vala \
	value.vala date.vala date.vapi query.vala \
	net/address.vala net/addressinfo.vala net/auth.vala net/host.vala net/message.vala net/server.vala \
	net/session.vala net/socket.vala net/uri.vala \
	checksum/checksum.vala checksum/hmac.vapi \
	io/contenttype.vala io/directoryinfo.vala io/drive.vala io/drive.vapi io/driveinfo.vala io/file.vala io/file.vapi \
	io/fileinfo.vala io/path.vala io/stream.vala

libmee_la_LDFLAGS = 
	
libmee_la_VALAFLAGS = --library mee-1.0 --vapi mee-1.0.vapi -H mee.h --gir Mee-1.0.gir\
	--pkg gio-2.0 --pkg gee-0.8 --pkg libmagic --pkg posix

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
girdir = @INTROSPECTION_GIRDIR@

gir_DATA = \
	Mee-1.0.gir \
	$(NULL)

typelibdir = @INTROSPECTION_TYPELIBDIR@
typelib_DATA = \
	Mee-1.0.typelib \
	$(NULL)

Mee-1.0.typelib: Mee-1.0.gir
	@INTROSPECTION_COMPILER@ -l libmee.so.0 -o $@ $^
endif
	
CLEANFILES = *.c *.o io/*.c io/*.o net/*.c net/*.o checksum/*.c checksum/*.o *.stamp mee-1.0.vapi mee.h *.gir *.typelib

DISTCLEANFILES = $(CLEANFILES) mee-1.0.pc Makefile
