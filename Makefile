#REPO_LIST=github.com/jwrr/carr/v0.1.0 www.lua.org/ftp/lua-5.2.4
REPO_LIST=github.com/jwrr/carr/master www.lua.org/ftp/lua-5.2.4

EXE=lued
DOTA=liblued.a
LIBS=-Linstall/lib  -llued -lcarr -llua -lm -ldl
OBJ=lued.o
CC=gcc
INC=-Iinstall/include
CFLAGS=-std=gnu99 -Wall $(INC)
LFLAGS=
DEPS = $(wildcard *.h)

exe: install/bin/$(EXE)

recompile: install/bin/$(EXE)
	make -C github.com/jwrr/carr/v0.1.0
	cp -rf github.com/jwrr/carr/v0.1.0/install .

www.lua.org/ftp/lua-5.2.4:
	mkdir -p $(shell dirname $@)
	wget $@.tar.gz
	tar zxvf $(shell basename $@).tar.gz -C $(shell dirname $@)
	cd $@ && make linux && make local
	cp -rf $@/install .

github.com/jwrr/carr/v0.1.0:
	git clone --branch $(shell basename $@) https://$(shell dirname $@).git $@
	make -C $@
	cp -rf $@/install .

%.o: src/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(DOTA): $(OBJ)
	ar cr $@ $(OBJ)

install/lib/$(DOTA): $(DOTA)
	mkdir -p install/lib
	cp $(DOTA)  $@
	mkdir -p install/include
	cp src/lued.h install/include

$(EXE): install/lib/$(DOTA) main.o
	$(CC) main.o $(LFLAGS) -o $@ $(LIBS)
	mkdir -p install/bin

install/bin/$(EXE): $(REPO_LIST) install/lib/libcarr.a $(EXE)
	mkdir -p install/bin
	cp $(EXE) $@

clean:
	rm -rf *.o *.a $(EXE) *tar.gz*

clean_all: clean
	rm -rf $(REPO_LIST) install

