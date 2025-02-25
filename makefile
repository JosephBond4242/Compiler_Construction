CC = gcc
CFLAGS = -I./src -std=gnu99
LDFLAGS = -L"/C/msys64/usr/lib" -lfl
LEX=flex

obj/scanner: obj/lex.yy.o obj/driver.o
	gcc $(CFLAGS) -o $@ $^ $(LDFLAGS)

obj/lex.yy.o: obj/lex.yy.c
	gcc $(CFLAGS) -c $< -o $@

obj:
	@mkdir -p obj

obj/lex.yy.c: scanner.l | obj
	$(LEX) -o $@ $<

obj/driver.o: driver.c
	@mkdir -p obj
	$(CC)  $(CFLAGS) -c $< -o $@

.PHONY: clean test

clean:
	rm -rf obj
	rm -f lex.yy.* *.o *~ scanner

test: obj/scanner
	@python ./test/testScanner.py
