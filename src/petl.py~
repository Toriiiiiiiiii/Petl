#!/bin/python3
import sys
import os

from lexer import *
from parser import *
from common import *
from interpreter import *
from compiler import *

preserveAsm = True
preserveObj = False

def usage():
    print(f"Usage: {sys.argv[0]} <source> <destination>")

## Main logic
if __name__ == "__main__":
    if len(sys.argv) < 2:
        usage()
        petlError(f"No source file was provided.")

    if len(sys.argv) < 3:
        usage()
        petlError(f"No destination file was provided.")
        
    fileContents = readFile(sys.argv[1])
    lex = Lexer(fileContents)
    parse = Parser(lex.tokens)

    compiler = Compiler(parse.ast)

    with open("petl.out.asm", "w") as f:
        f.write( compiler.getAssemblyCode() )

    os.system(f"nasm -g -felf64 petl.out.asm -o petl.out.o")
    os.system(f"gcc -o {sys.argv[2]} petl.out.o")
    
    if not preserveAsm:
        os.system(f"rm petl.out.asm")

    if not preserveObj:
        os.system(f"rm petl.out.o")
