#!/bin/bash
gcc -c -masm=intel -fPIE main.c -o main.o
nasm -f elf64 func_cpy.s -o func_cpy.o
gcc -fPIE -z noexecstack main.o func_cpy.o -o app.exe
./app.exe
