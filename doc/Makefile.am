SRC_DIR = $(top_srcdir)/src

docdir=$(datadir)/devhelp/references/mee-0.1
innerdocdir=$(datadir)/devhelp/references/mee-0.1/mee-0.1
imgdir=$(datadir)/devhelp/references/mee-0.1/mee-0.1/img

doc_data = \
	mee-0.1/*.css \
	mee-0.1/*.png \
	$(NULL)

doc_DATA = \
	mee-0.1/index.html \
	$(doc_data) \
	$(NULL)

innerdoc_DATA = \
	mee-0.1/mee-0.1/index.htm \
	mee-0.1/mee-0.1/*.html \
	$(NULL)

img_DATA = \
	mee-0.1/mee-0.1/img/*.png \
	$(NULL)

$(doc_data) $(innerdoc_DATA) $(img_DATA): mee-0.1/index.html

mee-0.1/index.html:
	$(VALADOC) -o mee-0.1/ --wiki ./ --force -b $(top_srcdir) $(SRC_DIR)/*.vala $(SRC_DIR)/io/*.vala \
	$(SRC_DIR)/io/drive.vapi $(SRC_DIR)/io/file.vapi $(SRC_DIR)/io/host.vapi $(SRC_DIR)/date.vapi --pkg gee-0.8 --pkg posix

EXTRA_DIST = \
	index.wiki \
	$(NULL)
	
clean-local:
	rm -rf mee-0.1
