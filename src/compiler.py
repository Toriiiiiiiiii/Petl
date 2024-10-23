from parser import *
import os

class Compiler:
    def __init__(self, ast: list) -> None:
        self.ast = ast
        self.asmCode = ""

        self.strings = []
        self.functions = {}
        self.externs = {}
        self.globs = {}
        self.buffers = []

        self.types = {"void": 0, "int": 8, "ptr": 8}
        self.structs = {}
        
        self.ifIndex = 0
        self.whileIndex = 0
        self.operationIndex = 0

        self.getFunctions(self.ast)        
        self.compile(self.ast)

    def getStructSize(self, struct) -> int:
        size = 0
        for field in self.structs[struct]:
            t = field[1]
            if t in self.structs:
                size += self.getStructSize(t)
            elif t in self.types:
                size += self.types[t]
            else:
                petlError(f"Undefined reference to type {t}.")

        return size

    def getStructMemberVars(self, struct, prefix) -> list:
        result = []
        offset = 0
        for field in self.structs[struct]:
            result.append([prefix + "." + field[0], offset, field[1]])

            if field[1] in self.structs:
                fieldMembers = self.getStructMemberVars(self, field[1], prefix + "." + field[0])

                for f in fieldMembers:
                    result.append([f[0], offset + f[1]])

                offset += self.getStructSize(field[1])
                continue

            offset += self.types[ field[1] ]

        return result
    
    def getFunctions(self, ast) -> None:
        for i in range(len(ast) - 1, -1, -1):
            node = ast[i]
            if node.type == "defn":
                fnName = node.value

                fnParams = [[n.value, n.children[0]] for n in node.children[0].children]
                fnBody = node.children[1].children
                fnType = node.children[2]

                self.functions[fnName] = [fnParams, fnBody, fnType]
                ast.pop(i)

#                print(fnParams)

            if node.type == "extfn":
                fnName = node.value
                fnParams = [n.value for n in node.children[0].children]

                self.externs[fnName] = [fnParams, node.children[1]]
                ast.pop(i)

            if node.type == "type":
                typename = node.value
                typefields = [[n.value, n.children[0]] for n in node.children[0].children]

                self.structs[typename] = typefields
                
    def compile(self, code, scope = {}, isGlobalScope = True) -> None:
        for node in code:
            if node.type == "Number":
                self.asmCode += f"    mov rax, {node.value}\n"
                self.asmCode += f"    call __stk_push\n"

            if node.type == "String":
                self.asmCode += f"    mov rax, STR_{len(self.strings)}\n"
                self.asmCode += f"    call __stk_push\n"
                self.strings.append(node.value)

            if node.type == "identifier":
                if node.value in scope:
                    t = scope[node.value][1]
                    if t not in self.structs:
                        self.asmCode += f"    mov rax, [{scope[node.value][0]}]\n"
                        self.asmCode += f"    call __stk_push\n"

                    else:
                        for mem in self.getStructMemberVars(t, node.value):
                            self.asmCode += f"    mov rax, [{scope[mem[0]][0]}]\n"
                            self.asmCode += f"    call __stk_push\n"
                elif node.value in self.globs:
                    self.asmCode += f"    mov rax, [{self.globs[node.value][0]}]\n"
                    self.asmCode += f"    call __stk_push\n"
                else:
                    petlError(f"Undefined reference to '{node.value}' at line {node.line}, column {node.col}") 
                    
            if node.type == "Operation":
                self.compile(node.children, scope = scope, isGlobalScope = isGlobalScope)
                self.asmCode += f"OPR_{self.operationIndex}:\n"
                
                self.asmCode += f"    call __stk_pop\n"
                self.asmCode += f"    mov rdi, rax\n"
                self.asmCode += f"    call __stk_pop\n"
                self.asmCode += f"    mov rdx, 0\n"

                match node.value:
                    case "+":
                        self.asmCode += f"    add rax, rdi\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "-":
                        self.asmCode += f"    sub rax, rdi\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "*":
                        self.asmCode += f"    mul rdi\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "/":
                        self.asmCode += f"    div rdi\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "%":
                        self.asmCode += f"    div rdi\n"
                        self.asmCode += f"    mov rax, rdx\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "<":
                        self.asmCode += f"    cmp rax, rdi\n"
                        self.asmCode += f"    jl OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case ">":
                        self.asmCode += f"    cmp rax, rdi\n"
                        self.asmCode += f"    jg OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "<=":
                        self.asmCode += f"    cmp rax, rdi\n"
                        self.asmCode += f"    jle OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case ">=":
                        self.asmCode += f"    cmp rax, rdi\n"
                        self.asmCode += f"    jge OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "==":
                        self.asmCode += f"    cmp rax, rdi\n"
                        self.asmCode += f"    je OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "!=":
                        self.asmCode += f"    cmp rax, rdi\n"
                        self.asmCode += f"    jne OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "||":
                        self.asmCode += f"    or rax, rdi\n"
                        self.asmCode += f"    cmp rax, 0\n"
                        self.asmCode += f"    jne OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                    case "&&":
                        self.asmCode += f"    and rax, rdi\n"
                        self.asmCode += f"    cmp rax, 0\n"
                        self.asmCode += f"    jne OPR_{self.operationIndex}_OTHR\n"
                        self.asmCode += f"    mov rax, 0\n"
                        self.asmCode += f"    jmp OPR_{self.operationIndex}_DONE\n"
                        self.asmCode += f"OPR_{self.operationIndex}_OTHR:\n"
                        self.asmCode += f"    mov rax, 1\n"
                        self.asmCode += f"OPR_{self.operationIndex}_DONE:\n"
                        self.asmCode += f"    call __stk_push\n"
                        
                self.operationIndex += 1

            if node.type == "Block":
                self.compile(node.children, scope = scope, isGlobalScope = isGlobalScope)
                
            if node.type == "while":
                condition = node.children[0]
                code = node.children[1]

                self.asmCode += f"WHILE_{self.whileIndex}:\n"
                self.compile(condition, scope = scope, isGlobalScope = isGlobalScope)
                self.asmCode += f"    call __stk_pop\n"
                self.asmCode += f"    cmp rax, 0\n"
                self.asmCode += f"    je WHILE_{self.whileIndex}_DONE\n"
                self.compile(code, scope = scope, isGlobalScope = isGlobalScope)
                self.asmCode += f"    jmp WHILE_{self.whileIndex}\n"
                self.asmCode += f"WHILE_{self.whileIndex}_DONE:\n"

                self.whileIndex += 1

            if node.type == "if":
                condition = node.children[0]
                code = node.children[1]

                nElses = 0
                if len(node.children[2:]) >= 2:
                    nElses = len(node.children[2:])

                elseCounter = 0

                self.asmCode += f"IF_{self.ifIndex}:\n"

                self.compile(condition, scope = scope, isGlobalScope = isGlobalScope)
                self.asmCode += f"    call __stk_pop\n"
                self.asmCode += f"    cmp rax, 0\n"

                if nElses == 0:
                    self.asmCode += f"    je IF_{self.ifIndex}_DONE\n"
                else:
                    self.asmCode += f"    je IF_{self.ifIndex}_ELSE_{elseCounter}\n"

                self.compile(code, scope = scope, isGlobalScope = isGlobalScope)
                self.asmCode += f"    jmp IF_{self.ifIndex}_DONE\n"
                
                for elseStmt in node.children[2:]:
                    self.asmCode += f"IF_{self.ifIndex}_ELSE_{elseCounter}:\n"
                    elseCounter += 1
                    ## ELSE statement
                    if len(elseStmt) == 1:
                        self.compile(elseStmt[0], scope = scope, isGlobalScope = isGlobalScope)
                        self.asmCode += f"    jmp IF_{self.ifIndex}_DONE\n"
                    ## ELIF statement
                    else:
                        self.compile(elseStmt[0], scope = scope, isGlobalScope = isGlobalScope)
                        self.asmCode += f"    call __stk_pop\n"
                        self.asmCode += f"    cmp rax, 0\n"

                        ## No more elses
                        if elseCounter >= nElses:
                            self.asmCode += f"    je IF_{self.ifIndex}_DONE\n"
                        else:
                            self.asmCode += f"    je IF_{self.ifIndex}_ELSE_{elseCounter}\n"

                        self.compile(elseStmt[1], scope = scope, isGlobalScope = isGlobalScope)
                        self.asmCode += f"    jmp IF_{self.ifIndex}_DONE\n"
                        
                self.asmCode += f"IF_{self.ifIndex}_DONE:\n"
                
                self.ifIndex += 1
                
            if node.type == "assign":
                if len(node.children) > 1:
                    if node.children[1] not in self.types and node.children[1] not in self.structs:
                        petlError(f"Unknown type '{node.children[1]}' at line {node.line}, column {node.col}")
                
                self.compile([node.children[0]], scope = scope, isGlobalScope = isGlobalScope)
                isGlobal = False
                added = False
                if isGlobalScope and node.value not in self.globs:
                    isGlobal = True
                    added = True
                    self.asmCode += f"    call __stk_pop\n"
                    self.asmCode += f"    mov [GLOB_{node.value}], rax\n"
                    self.globs[node.value] = [f"GLOB_{node.value}", node.children[1]]
                elif isGlobalScope or node.value in self.globs:
                    self.asmCode += f"    call __stk_pop\n"
                    self.asmCode += f"    mov [GLOB_{node.value[0]}], rax\n"
                elif node.value not in scope:
                    added = True

                    scope[node.value] = [f"rsp+{8*len(scope)}", node.children[1]]
                    self.asmCode += f"    call __stk_pop\n"
                    self.asmCode += f"    mov [{scope[node.value][0]}], rax\n"
                else:
                    self.asmCode += f"    call __stk_pop\n"
                    self.asmCode += f"    mov [{scope[node.value][0]}], rax\n"

                if added and node.children[1] in self.structs:
                    
                    members = self.getStructMemberVars(node.children[1], node.value)
                    if isGlobal:
                        for mem in members:
                            self.globs[mem[0]] = [f"GLOB_{mem[0]}", mem[2]]

                    else:
                        baseOffset = 8 * (len(scope) - 1)
                        for mem in members:
                            scope[mem[0]] = [f"rsp+{baseOffset + mem[1]}", mem[2]]
                    
            if node.type == "fncall":
                args = node.children[0].children
                args.reverse()
                
                if node.value == "require":
                    if len(args) != 1:
                        petlError(f"Incorrect number of arguments in call to function 'require' at line {node.line}, column {node.col}")

                    fileName = args[0].value.rstrip('"').lstrip('"')
                        
                    fileContents = ""
                    try:
                        with open(fileName, "r") as f:
                            fileContents = f.read()
                    except:
                        try:
                            with open(os.path.dirname(os.path.abspath(__file__)) + "/" + fileName, "r") as f:
                                fileContents = f.read()
                        except:
                            petlError(f"Could not read file '{fileName}'.")

                    lex = Lexer(fileContents)
                    parse = Parser(lex.tokens)
                    
                    self.getFunctions(parse.ast)
                    self.compile(parse.ast, scope = {}, isGlobalScope = True)

                elif node.value == "addr":
                    if len(args) != 1:
                        petlError(f"Incorrect number of arguments in call to function 'addr' at line {node.line}, column {node.col}")

                    v = args[0].value
                    if v not in self.globs and v not in scope:
                        petlError(f"Can not get address of '{v}'")

                    if v in self.globs:
                        self.asmCode += f"    mov rax, GLOB_{v}\n"
                    elif v in scope:
                        self.asmCode += f"    lea rax, [{scope[v][0]}]\n"

                    self.asmCode += f"    call __stk_push\n"
                        
                elif node.value == "new":
                    if len(args) != 1:
                        petlError(f"Incorrect number of arguments in call to function 'new' at line {node.line}, column {node.col}")

                    t = args[0].value
                    if t not in self.structs:
                        petlError(f"Cannot use 'new' on type '{t}' (Line {node.line}, column {node.col}")

                    size = self.getStructSize(t)
                    self.asmCode += f"    mov rax, BUF_{len(self.buffers)}\n"
                    self.asmCode += f"    call __stk_push\n"
                    self.buffers.append(size)
                    
                elif node.value == "buffer":
                    if len(args) != 1:
                        petlError(f"Incorrect number of arguments in call to function 'buffer' at line {node.line}, column {node.col}")

                    size = args[0].value
                    self.asmCode += f"    mov rax, BUF_{len(self.buffers)}\n"
                    self.asmCode += f"    call __stk_push\n"
                    self.buffers.append(size)
                    
                elif node.value == "setptr":
                    if len(args) < 2 or len(args) > 3:
                        petlError(f"Incorrect number of arguments in call to function 'setptr' at line {node.line}, column {node.col}")

                    nBytes = 8
                    if len(args) == 3:
                        nBytes = int(args[0].value)
                        args = args[1:]

                    self.compile(args, scope = scope, isGlobalScope = isGlobalScope)
                    self.asmCode += "    call __stk_pop\n"
                    self.asmCode += "    mov rdi, rax\n"

                    self.asmCode += "    call __stk_pop\n"
                    if nBytes == 8:
                        self.asmCode += "    mov [rdi], rax\n"
                    elif nBytes == 4:
                        self.asmCode += "    mov [rdi], eax\n"
                    elif nBytes == 2:
                        self.asmCode += "    mov [rdi], ax\n"
                    elif nBytes == 1:
                        self.asmCode += "    mov [rdi], al\n"
                    
                elif node.value == "getptr":
                    if len(args) < 1 or len(args) > 2:
                        petlError(f"Incorrect number of arguments in call to function 'getptr' at line {node.line}, column {node.col}")

                    nBytes = 8
                    if len(args) == 2:
                        nBytes = int(args[0].value)
                        args = args[1:]

                    self.compile(args, scope = scope, isGlobalScope = isGlobalScope)
                    self.asmCode += "    call __stk_pop\n"
                    self.asmCode += "    mov rsi, rax\n"

                    self.asmCode += "    mov rax, 0\n"
                    if nBytes == 8:
                        self.asmCode += "    mov rax, [rsi]\n"
                    elif nBytes == 4:
                        self.asmCode += "    mov eax, [rsi]\n"
                    elif nBytes == 2:
                        self.asmCode += "    mov ax, [rsi]\n"
                    elif nBytes == 1:
                        self.asmCode += "    mov al, [rsi]\n"

                    self.asmCode += "    call __stk_push\n"
                        
                elif node.value == "return":                    
                    self.compile(args, scope = scope, isGlobalScope = isGlobalScope)
                    if isGlobalScope:
                        petlError(f"Attempting to return from non-function at line {node.line}, column {node.col}")

                    self.asmCode += "    jmp FN_END\n"
                    
                elif node.value == "setreg":
                    if len(args) < 2:
                        petlError(f"Incorrect number of arguments in call to function 'setreg' at line {node.line}, column {node.col}")
                        
                    register = args[len(args)-1].value

                    if register not in ["rax", "rdx", "rcx", "rbx", "rsi", "rdi", "rsp", "rbp", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"]:
                        petlError(f"{register} is not a register.")
                        
                    self.compile(args[:len(args)-1], scope = scope, isGlobalScope = isGlobalScope)

                    self.asmCode +=  "    call __stk_pop\n"
                    self.asmCode += f"    mov {register}, rax\n"

                elif node.value == "syscall":
                    if len(args) != 0:
                        petlError(f"Incorrect number of arguments on call to function 'syscall' at line {node.line}, column {node.col}")

                    self.asmCode += f"    syscall\n"
                    self.asmCode += f"    call __stk_push\n"
                    
                elif node.value == "exit":
                    if len(args) != 1:
                        petlError(f"Incorrect number of arguments in call to function 'exit' at line {node.line}, column {node.col}")

                    self.compile(args, scope = scope, isGlobalScope = isGlobalScope)
                    self.asmCode += f"    call __stk_pop\n"
                    self.asmCode += f"    mov rdi, rax\n"
                    self.asmCode += f"    jmp _exit\n"
                    
                elif node.value in self.functions:
                    if len(args) != len(self.functions[node.value][0]):
                        petlError(f"Incorrect number of arguments in call to function '{node.value}' at line {node.line}, column {node.col}")

                    self.compile(args, scope = scope, isGlobalScope = isGlobalScope)
                    self.asmCode += f"    call FN_{node.value}\n"

                elif node.value in self.externs:
                    nRequiredArgs = 0
                    hasVarArgs = False
                    for arg in self.externs[node.value][0]:
                        if arg == "...":
                            hasVarArgs = True
                            break

                        nRequiredArgs += 1
                    
                    if len(args) < nRequiredArgs:
                        petlError(f"Incorrect number of arguments in call to function '{node.value}' at line {node.line}, column {node.col}")
                    if not hasVarArgs and len(args) != nRequiredArgs:
                        petlError(f"Incorrect number of arguments in call to function '{node.value}' at line {node.line}, column {node.col}")
                        
                    self.compile(args, scope = scope, isGlobalScope = isGlobalScope)

                    registers = [
                        "rdi", "rsi", "rdx", "rcx", "r8", "r9"
                    ]
                    
                    for index, param in enumerate(node.children[0].children):
                        if index >= len(registers):
                            self.asmCode += f"    call __stk_pop\n"
                            self.asmCode += f"    push rax\n"
                        else:
                            self.asmCode += f"    call __stk_pop\n"
                            self.asmCode += f"    mov {registers[index]}, rax\n"

                    self.asmCode += f"    mov rax, 0\n"   
                    self.asmCode += f"    call {node.value}\n"
#                    self.asmCode += f"    add rsp, {8*len(self.externs[node.value][0])}\n"

                    if self.externs[node.value][1] not in self.types:
                        petlError(f"Unknown type {self.externs[node.value][1]}.")
                    if self.externs[node.value][1] != "void":
                        self.asmCode += f"    call __stk_push\n"

                else:
                    petlError(f"Attempting to call undefined function '{node.value}' at line {node.line}, column {node.col}")
                    
        return scope
                    
    def getAssemblyCode(self) -> str:
        result = ""

        result += "    section .text\n"
        result += "    global main\n"

        for extern in self.externs:
            result += f"    extern {extern}\n"
        
        result += "main:\n"
        result += self.asmCode
        result += "_done:\n"
        result += "    mov rdi, 0\n"
        result += "_exit:\n"
        result += "    mov rax, 60\n"
        result += "    syscall\n"
        result += "    ret\n\n\n"

        for fn in self.functions:
            self.asmCode = ""
            fnScope = {"__ARG_NULL":""}
            params = self.functions[fn][0]
            for param in self.functions[fn][0]:
                if param[1] in self.structs:
                    members = self.getStructMemberVars(param[1], param[0])
                    members.reverse()
                    params += [[m[0], m[2]] for m in members]

            code = self.functions[fn][1]
            fnname = f"FN_{fn}"

            result += f"{fnname}:\n"
            
            ## Retrieve arguments from stack
            index = 0
            for param in params:
                fnScope[param[0]] = [f"rsp+{8*(index+1)}", param[1]]

                if param[1] not in self.structs:
                    index += 1
                
                #if param[1] in self.structs:
                #    members = self.getStructMemberVars(param[1], param[0])
                #    baseIndex = 8 * (index)
                #    for mem in members:
                #        fnScope[mem[0]] = [f"rsp+{baseIndex + mem[1]}", mem[2]]

                #    index += len(members)
                
            scope = self.compile(code, scope=fnScope, isGlobalScope = False)
            result += f"    push rbp\n"
            result += f"    mov rbp, rsp\n"
            result += f"    sub rsp, {8 * len(scope)}\n"

            for index, param in enumerate(params):
                if param[1] not in self.structs:
                    result += f"    call __stk_pop\n"
                    result += f"    mov [{scope[param[0]][0]}], rax\n"

            result += self.asmCode
            result += "    jmp FN_END\n"
            
        result += f"FN_END:\n"
        result += f"    mov rsp, rbp\n"
        result += f"    pop rbp\n"
        result += f"    ret\n"
        
        result += "__stk_dup:\n"
        result += "    call __stk_pop\n"
        result += "    call __stk_push\n"
        result += "    call __stk_push\n"
        result += "    ret\n\n"
        
        result += "__stk_push:\n"
        result += "    push rax\n"
        result += "    push rdi\n"
        result += "    mov rdi, [__stk_ptr]\n"
        result += "    mov [__stk+rdi], rax\n"
        result += "    add rdi, 8\n"
        result += "    mov [__stk_ptr], rdi\n"
        result += "    pop rdi\n"
        result += "    pop rax\n"
        result += "    ret\n\n"

        result += "__stk_pop:\n"
        result += "    push rdi\n"
        result += "    mov rdi, [__stk_ptr]\n"
        result += "    sub rdi, 8\n"
        result += "    mov rax, [__stk+rdi]\n"
        result += "    mov [__stk_ptr], rdi\n"
        result += "    pop rdi\n"
        result += "    ret\n\n\n"

        result += "    section .data\n"
        result += "__stk_ptr: dq 0\n"
        
        for index, string in enumerate(self.strings):
            result += f"STR_{index}: db `{string}`, 0\n"
    
        result += "    section .bss\n"
        result += "__stk: resb 2048\n"

        for index, size in enumerate(self.buffers):
            result += f"BUF_{index}: resb {size}\n"
                                 
        for glob in self.globs:
            result += f"{self.globs[glob][0]}: resb 8\n"
        
        return result
            
