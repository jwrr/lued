#PRJ = cstr
#PRJ = carr
PRJ = lued
EXE = $(PRJ)
HTML_PATH = ../html/$(PRJ)
MAIN = $(EXE)_main.c
SRC = $(wildcard *.c) 
OBJ = $(patsubst %.c, %.o, $(SRC))
LUA=lua-5.2.4
LUA_URL=https://www.lua.org/ftp
LUA_PATH=./$(LUA)
#LUA_L=-llua5.2 
LUA_L=-L$(LUA_PATH)/install/lib -llua -lm -ldl
INC=-I$(LUA_PATH)/install/include
HEADERS = $(wildcard *.h)
CC = gcc
GDB_CFLAGS= -g
VALGRIND_CFLAGS= -g 
LCOV_CFLAGS= -g -O0 -fprofile-arcs -ftest-coverage
CFLAGS = -Wall $(INC) $(LCOV_CFLAGS)
LFLAGS = -lgcov -fprofile-arcs
LIBS =$(LUA_L)

.PRECIOUS: $(OBJ)
.PHONY: compile default all clean gdb dox push commit

$(EXE): $(LUA_PATH) $(OBJ)
	$(CC) $(OBJ) $(LFLAGS) -o $@ $(LIBS)

$(LUA_PATH): $(LUA).tar.gz	
	tar zxvf $(LUA).tar.gz
	cd $(LUA_PATH) && make linux && make local

$(LUA).tar.gz:
	wget $(LUA_URL)/$(LUA).tar.gz

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

$(EXE).log: $(EXE)
	./$(EXE) |tee $(EXE).log

all: $(EXE).log dox

compile: main.c $(EXE)
#main.c: main/$(MAIN)
#	cp main/$(MAIN) main.c

push:
	git push
	cd $(HTML_PATH) && git push

# git clone https://rbrown3@bitbucket.org/rbrown3/rbrown3.bitbucket.org.git html
commit: dox lcov
	git commit -m "$(m)"
	cd  $(HTML_PATH) && \
	git add . && \
	git commit -m "$(m)"

dox: compile Doxyfile
	doxygen Doxyfile

gdb: compile
	gdb $(EXE)

valgrind: compile
	valgrind --leak-check=yes --xml=yes --xml-file=$(HTML_PATH)/valgrind/valgrind.xml ./$(EXE)       

lcov: $(EXE).log
	lcov --capture --directory . --output-file coverage.info
	genhtml coverage.info --output-directory $(HTML_PATH)/lcov

$(PRJ)_wrap.c: $(PRJ).i
	swig -tcl $(PRJ).i

$(PRJ)_wrap.o: *.c *.h
	gcc -fpic -c *.c -I/usr/include/tcl8.6

$(PRJ).so: $(PRJ)_wrap.o
	gcc -shared *.o -o cstr.so

swig: $(PRJ).so

clean:
	rm -rf *.o *.so *.log $(EXE) *gcno *gcda coverage.info
	# rm -rf *.o *.so *.log $(EXE) main.c $(PRJ)_wrap.c *gcno *gcda coverage.info

clean_all: clean
	rm -rf $(LUA)*

