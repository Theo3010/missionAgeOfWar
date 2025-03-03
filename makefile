program = test

all: $(program) run clean

build: $(program)

back: program = back

back: $(program)

$(program): $(program).o
	@ld -m elf_x86_64 $(program).o -o $(program)

$(program).o: $(program).asm
	@nasm -f elf64 -o $(program).o $(program).asm

run: $(program)
	@./$(program)

clean:
	@rm -f $(program).o $(program)

.PHONY: all clean run back