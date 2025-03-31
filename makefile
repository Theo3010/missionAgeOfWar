program = test
srcFolder = src
outFolder = out

all: build run clean

build: $(outFolder)/$(program)

back: $(outFolder)/back

$(outFolder)/$(program): $(outFolder)/$(program).o
	@ld -m elf_x86_64 $(outFolder)/$(program).o -o $(outFolder)/$(program)

$(outFolder)/$(program).o: $(srcFolder)/$(program).asm
	@nasm -f elf64 -o $(outFolder)/$(program).o $(srcFolder)/$(program).asm

$(outFolder)/back: $(outFolder)/back.o
	@ld -m elf_x86_64 $(outFolder)/back.o -o $(outFolder)/back

$(outFolder)/back.o: $(srcFolder)/back.asm
	@nasm -f elf64 -o $(outFolder)/back.o $(srcFolder)/back.asm

run: $(outFolder)/$(program)
	@$(outFolder)/$(program)

clean:
	@rm -f $(outFolder)/$(program).o $(outFolder)/$(program)

.PHONY: all clean run back