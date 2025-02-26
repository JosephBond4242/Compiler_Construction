CC = gcc
CFLAGS = -I./src -std=gnu99
LDFLAGS = -L"/C/msys64/usr/lib" -lfl
LEX=flex

scanner: obj/lex.yy.o obj/driver.o
	gcc $(CFLAGS) -o $@ $^ $(LDFLAGS)

obj/lex.yy.o: lex.yy.c
	gcc $(CFLAGS) -c $< -o $@

obj:
	@mkdir -p obj

lex.yy.c: scanner.l
	$(LEX) $<

obj/driver.o: driver.c
	@mkdir -p obj
	$(CC)  $(CFLAGS) -c $< -o $@

.PHONY: clean test

clean:
	rm -f lex.yy.* *.o *~ scanner

test: scanner test/input.txt
	./scanner < test/input.txt