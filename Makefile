
VERSION=2.0.33r3

# Command used to run Lua code
LUABIN=/usr/local/Cellar/openresty/1.19.3.1_1/luajit/bin/luajit

# Optimization for the brave of heart ;)
OMITFP=-fomit-frame-pointer


# ---------------------------------------------------------------------------
# Automatic configuration using pkgconfig. These lines should work on most
# Linux/Unix systems. If your system does not have these programs you must
# comment out these lines and uncomment and change the next ones.

# Name of .pc file. "lua5.1" on Debian/Ubuntu
LUAPKG=lua5.1
OUTFILE=gd.so

CFLAGS=-O3 -Wall -fPIC $(OMITFP)
CFLAGS+=-DVERSION=\"$(VERSION)\"

GDFEATURES=-DGD_XPM -DGD_JPEG -DGD_FONTCONFIG -DGD_FREETYPE -DGD_PNG -DGD_GIF
LFLAGS=-shared -I/usr/local/Cellar/openresty/1.19.3.1_1/luajit/include/luajit-2.1

INSTALL_PATH := `pkg-config $(LUAPKG) --variable=INSTALL_CMOD`


all:
	gcc -o luagd.so -c $(GDFEATURES) -shared -I/usr/local/Cellar/openresty/1.19.3.1_1/luajit/include/luajit-2.1 -lgd -dynamiclib -undefined dynamic_lookup luagd.c $(CFLAGS)


install: $(OUTFILE)
	install -D -s $(OUTFILE) $(DESTDIR)/$(INSTALL_PATH)/$(OUTFILE)


# Rules for making a distribution tarball

TDIR=lua-gd-$(VERSION)
DFILES=COPYING README luagd.c lua-gd.spec Makefile test_features.lua
dist: $(DISTFILES)
	rm -f $(TDIR).tar.gz
	mkdir $(TDIR)
	mkdir -p $(TDIR)/doc $(TDIR)/demos $(TDIR)/debian
	cp $(DFILES) $(TDIR)
	cp demos/* $(TDIR)/demos/
	cp doc/* $(TDIR)/doc/
	cp debian/* $(TDIR)/debian/
	tar czf $(TDIR).tar.gz $(TDIR)
	rm -rf $(TDIR)

clean:
	rm -f $(OUTFILE) gd.lo
	rm -rf $(TDIR) $(TDIR).tar.gz
	rm -f demos/out.png demos/out.gif demos/counter.txt

.PHONY: all test install clean dist
