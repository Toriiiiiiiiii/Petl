from parser import *

class RuntimeValue:
    def __init__(self, type, value) -> None:
        self.type = type
        self.value = value

    def __repr__(self) -> str:
        try:
            if int(self.value) == float(self.value):
                return str(int(self.value))
        except:
            pass
        
        return str(self.value)

VOID = RuntimeValue("void", "void")
    
class RuntimeEnvironment:
    def __init__(self, ast: list) -> None:
        self.ast = ast

        self.functions = {}
        self.globs = {}
        
        self.getFunctions()

        self.stack = []
        
        self.run(self.ast, {}, isGlobalScope = True)
        if len(self.stack) != 0:
            val = self.pop()
            if val.type == "Number": exit( int(val.value) ) 
        
    def push(self, value: RuntimeValue) -> None:
        self.stack.append(value)

    def pop(self) -> RuntimeValue:
        if len(self.stack) == 0:
            petlError("Stack Underflow Error")

        return self.stack.pop()
        
    ## Load all functions from the AST.
    def getFunctions(self) -> None:
        for i in range(len(self.ast) - 1, -1, -1):
            node = self.ast[i]
            if node.type == "defn":
                fnName = node.value
                fnParams = [n.value for n in node.children[0].children]
                fnBody = node.children[1].children

                self.functions[fnName] = [fnParams, fnBody]

                self.ast.pop(i)

    ## Run a function.
    def run(self, code: list, scope: dict, isGlobalScope = False) -> None:
        for node in code:
            if node.type == "Number":
                self.push(RuntimeValue("Number", float(node.value)))

            if node.type == "String":
                self.push(RuntimeValue("String", node.value))

            if node.type == "identifier":
                if node.value in scope:
                    self.push(scope[node.value])
                elif node.value in self.globs:
                    self.push(self.globs[node.value])
                else:
                    petlError(f"Undefined reference to '{node.value}' at line {node.line}, column {node.col}")

            if node.type == "assign":
                self.run(node.children, scope, isGlobalScope = isGlobalScope)
                if isGlobalScope:
                    self.globs[node.value] = self.pop()
                elif node.value in self.globs:
                    self.globs[node.value] = self.pop()
                else:
                    scope[node.value] = self.pop()
                    
            if node.type == "Operation":
                self.run(node.children, scope, isGlobalScope = isGlobalScope)
                b = self.pop()
                a = self.pop()
                
                if a.type != b.type:
                    petlError(f"Type mismatch in operation at line {node.line}, column {node.col}")

                match node.value:
                    case "+":
                        self.push( RuntimeValue(a.type, a.value + b.value) )
                    case "-":
                        self.push( RuntimeValue(a.type, a.value - b.value) )
                    case "*":
                        self.push( RuntimeValue(a.type, a.value * b.value) )
                    case "/":
                        self.push( RuntimeValue(a.type, a.value / b.value) )
                    case "<":
                        self.push( RuntimeValue("bool", 1 if a.value < b.value else 0) )
                    case ">":
                        self.push( RuntimeValue("bool", 1 if a.value > b.value else 0) )
                    case "<=":
                        self.push( RuntimeValue("bool", 1 if a.value <= b.value else 0) )
                    case ">=":
                        self.push( RuntimeValue("bool", 1 if a.value >= b.value else 0) )
                    case "==":
                        self.push( RuntimeValue("bool", 1 if a.value == b.value else 0) )

            if node.type == "while":
                condition = node.children[0]
                code = node.children[1]

                self.run(condition, scope, isGlobalScope = isGlobalScope)
                while self.pop().value:
                    self.run(code, scope, isGlobalScope = isGlobalScope)
                    self.run(condition, scope, isGlobalScope = isGlobalScope)

            if node.type == "if":
                condition = node.children[0]
                code = node.children[1]

                self.run(condition, scope, isGlobalScope = isGlobalScope)
                if self.pop().value:
                    self.run(code, scope, isGlobalScope = isGlobalScope)
                else:
                    ## Handle elifs/else
                    for i in range(2, len(node.children)):
                        n = node.children[i]

                        ## else
                        if len(n) == 1:
                            self.run(n[0], scope, isGlobalScope = isGlobalScope)
                            break

                        condition = n[0]
                        code = n[1]

                        self.run(condition, scope, isGlobalScope = isGlobalScope)
                        if self.pop().value:
                            self.run(code, scope, isGlobalScope = isGlobalScope)
                            break
                    
            if node.type == "fncall":
                args = node.children[0].children
                args.reverse()
                
                if node.value == "outp":
                    self.run(args, scope, isGlobalScope = isGlobalScope)
                    print(self.pop())

                elif node.value == "inp":
                    self.run(args, scope, isGlobalScope = isGlobalScope)
                    self.push( RuntimeValue("String", input( self.pop().value )) )

                elif node.value == "tonum":
                    self.run(args, scope, isGlobalScope = isGlobalScope)
                    val = self.pop()
                    try: float(val.value)
                    except: petlError(f"Could not convert '{val.value}' to a number.")

                    self.push( RuntimeValue("Number", float(val.value) ) )
                    
                elif node.value in self.functions:
                    self.run(args, scope, isGlobalScope = isGlobalScope)

                    fnArgs = {}
                    for param in self.functions[node.value][0]:
                        fnArgs[param] = self.pop()

                    self.run( self.functions[node.value][1], fnArgs )

                else:
                    petlError(f"Undefined function '{node.value}' called at line {node.line}, column {node.col}")
