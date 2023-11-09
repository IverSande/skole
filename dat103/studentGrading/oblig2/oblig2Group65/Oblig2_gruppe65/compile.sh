nasm -f elf -F dwarf -g oblig2.asm
ld -m elf_i386 -o oblig2 oblig2.o
./oblig2_task2

