CC=gcc
CFLAGS=-Wall -shared -fPIC -Werror -DNDEBUG -O2
LUA_FLAGS=-I/usr/local/Cellar/openresty/1.19.3.1_1/luajit/include/luajit-2.1
LUA_LIB_DIR=/usr/local/Cellar/openresty/1.19.3.1_1/lualib
LINK_LIB=-I/usr/local/opt/openssl@1.1/include -lgd -lm
OUTFILE=gd.so
SHARED=

APPLE=$(shell uname -a | grep -c Darwin)
ifeq ($(APPLE),1)
	SHARED=-dynamiclib -undefined dynamic_lookup
endif

all:
	$(CC) $(CFLAGS) luagd.c -o $(OUTFILE) $(LUA_FLAGS) $(LINK_LIB) $(SHARED)
clean:
	rm  *.so

install:
	cp $(OUTFILE) $(LUA_LIB_DIR)/$(OUTFILE)