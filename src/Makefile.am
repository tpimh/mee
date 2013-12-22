AM_CPPFLAGS = $(GLIB_CFLAGS)
	
lib_LTLIBRARIES = libmee.la

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = mee.vapi

meeincludedir = $(includedir)
meeinclude_HEADERS = mee.h

libmee_la_LIBADD = $(GLIB_LIBS) -lmagic

libmee_la_SOURCES = math.vala mee.vala encoding.vala string.vala date.vala date.vapi value.vala array.vala bitconverter.vala \
					io/directoryinfo.vala io/file.vala io/file.vapi io/fileinfo.vala io/path.vala io/stream.vala \
					io/drive.vala io/drive.vapi io/driveinfo.vala io/contenttype.vala checksum/checksum.vala \
					net/address.vala net/addressinfo.vala net/auth.vala net/error.vala net/host.vala net/socket.vala \
					net/uri.vala net/message.vala net/session.vala net/server.vala unicode.vapi
	
libmee_la_VALAFLAGS = --library mee -H mee.h --pkg gmodule-2.0 --pkg posix --pkg gee-0.8 --pkg libmagic \
					   --disable-warnings --gir Mee-0.1.gir -X -lmagic --vapidir ../vapi

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
	@INTROSPECTION_COMPILER@ -l libmee.so.0 -o $@ $^
endif
	
EXTRA_DIST = $(libmee_la_SOURCES) Mee-0.1.gir mee.vapi

CLEANFILES = *.h *.c io/*.c checksum/*.c net/*.c mee.vapi *.stamp* *.gir *.typelib
