SRC_DIR = $(top_srcdir)/src

docdir=$(datadir)/devhelp/references/mee-1.0
innerdocdir=$(datadir)/devhelp/references/mee-1.0/mee-1.0
imgdir=$(datadir)/devhelp/references/mee-1.0/mee-1.0/img

doc_data = \
	mee-1.0/*.css \
	mee-1.0/*.png \
	$(NULL)

doc_DATA = \
	mee-1.0/index.html \
	$(doc_data) \
	$(NULL)

innerdoc_DATA = \
	mee-1.0/mee-1.0/index.htm \
	mee-1.0/mee-1.0/*.html \
	$(NULL)

img_DATA = \
	mee-1.0/mee-1.0/img/*.png \
	$(NULL)

$(doc_data) $(innerdoc_DATA) $(img_DATA): mee-1.0/index.html

mee-1.0/index.html:
	$(VALADOC) -o mee-1.0/ --wiki ./ --force -b $(top_srcdir) $(SRC_DIR)/*.vala $(SRC_DIR)/io/*.vala $(SRC_DIR)/net/*.vala \
	$(SRC_DIR)/checksum/*.vala $(SRC_DIR)/io/drive.vapi $(SRC_DIR)/io/file.vapi $(SRC_DIR)/date.vapi --pkg gee-0.8 --pkg posix \
	 --pkg libmagic --deps=gee-0.8

EXTRA_DIST = \
	index.wiki \
	$(NULL)
	
clean-local:
	rm -rf mee-1.0
