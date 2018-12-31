#REPO_LIST=github.com/jwrr/carr/v0.1.0 www.lua.org/ftp/lua-5.2.4
CARR_PATH=github.com/jwrr/carr/master
LUA_PATH=www.lua.org/ftp/lua-5.2.4
REPO_LIST=$(CARR_PATH) $(LUA_PATH)

EXE=lued
LIBS=-Linstall/lib  -llued -lcarr -llua -lm -ldl
CC=gcc
INC=-Iinstall/include
CFLAGS=-std=gnu99 -Wall $(INC)
LFLAGS=
DEPS=$(wildcard *.h)
INSTALL_DIR=$(HOME)/.lued

exe: install/bin/$(EXE)

install: $(INSTALL_DIR)

$(INSTALL_DIR): exe
	cp install/bin/$(EXE) lued_root
	ln -sf $(PWD)/lued_root $(INSTALL_DIR)
	@echo "\nCopy 'lued' to your bin folder\n"

carr: install/lib/libcarr.a
install/lib/libcarr.a: $(CARR_PATH)
	make -C $(CARR_PATH)
	cp -rf $(CARR_PATH)/install .
$(CARR_PATH):
	git clone --branch $(shell basename $@) https://$(shell dirname $@).git $@

lua: install/lib/liblua.a
install/lib/liblua.a: $(LUA_PATH)
	make -C $(LUA_PATH) linux
	make -C $(LUA_PATH) local
	cp -rf $(LUA_PATH)/install .
$(LUA_PATH):
	mkdir -p $(shell dirname $@)
	wget $@.tar.gz
	tar zxvf $(shell basename $@).tar.gz -C $(shell dirname $@)

$(EXE).o: src/$(EXE).c $(DEPS) lua carr
	$(CC) -c -o $@ $< $(CFLAGS)

main.o: src/main.c $(EXE).o
	$(CC) -c -o $@ $< $(CFLAGS)

lib$(EXE).a: $(EXE).o
	ar cr $@ $(EXE).o

install/lib/lib$(EXE).a: lib$(EXE).a
	mkdir -p install/lib
	cp lib$(EXE).a  $@
	mkdir -p install/include
	cp src/lued.h install/include

$(EXE): install/lib/lib$(EXE).a main.o
	$(CC) main.o $(LFLAGS) -o $@ $(LIBS)
	mkdir -p install/bin

install/bin/$(EXE): $(REPO_LIST) $(EXE)
	mkdir -p install/bin
	cp $(EXE) $@

clean:
	rm -rf *.o *.a $(EXE) *tar.gz* install/lib/*

clean_all: clean
	rm -rf $(REPO_LIST) install

