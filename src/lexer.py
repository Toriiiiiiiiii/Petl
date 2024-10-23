from common import *

## Token Class - Used to store source code in
## a more computer-friendly format.
class Token:
    def __init__(self, toktype: str, line: int, col: int, val: str) -> None:
        self.type = toktype
        self.line = line
        self.col = col
        self.value = val

    def __repr__(self) -> str:
        return f"{self.type}[{self.line}:{self.col}, {self.value}]"
    

class Lexer:
    def __init__(self, source: str) -> None:
        self.line = 1
        self.col = 1
        self.source = source

        self.whitespace = " \n\t"
        self.keywordStart = "abcdefghijklmnopqrstuvwxyz"
        self.keywordStart += self.keywordStart.upper() + "_"

        self.numberStart = "0123456789"
        self.numberBody = self.numberStart

        self.keywordBody = self.keywordStart + self.numberStart + "."

        self.operators = "|&!+-*/%<>=.:"
        self.stringTerminators = "'\""
        
        self.tokens = []
        self.tokenise()

    ## Returns the next character in the source.
    def at(self) -> str:
        return self.source[0]

    ## Returns the next character in the source and advances.
    def consume(self) -> str:
        char = self.at()

        self.col += 1
        if char == '\n':
            self.col = 1
            self.line += 1

        self.source = self.source[1:]
        return char

    ## Simply returns true if source has been fully analysed.
    def empty(self) -> bool:
        return True if len(self.source) == 0 else False
    
    ## Creates a number token
    def buildNumber(self) -> Token:
        tok = Token("Number", self.line, self.col, "")

        while not self.empty() and self.at() in self.numberBody:
            tok.value += self.consume()

        return tok

    ## Creates a keyword token
    def buildKeyword(self) -> Token:
        tok = Token("Keyword", self.line, self.col, "")

        while not self.empty() and self.at() in self.keywordBody:
            tok.value += self.consume()

        return tok

    ## Creates an operator token
    def buildOperator(self) -> Token:
        ## If the operator is "-" and the next character is a
        ## digit, then treat it as a negative number.
        if self.at() == "-" and self.source[1] in self.numberStart:
            self.consume()

            tok = self.buildNumber()
            tok.col -= 1
            tok.value = "-" + tok.value

            return tok

        tok = Token("Operator", self.line, self.col, "")

        while not self.empty() and self.at() in self.operators:
            tok.value += self.consume()

        return tok

    ## Creates a string token
    def buildString(self) -> Token:
        tok = Token("String", self.line, self.col, "")
        terminator = self.consume()
        
        while not self.empty():            
            if self.at() == terminator:
                break
            
            tok.value += self.consume()

        if self.empty():
            petlError(f"Syntax error: Unterminated string at line {tok.line}, col {tok.col}")

        self.consume()
        return tok
    
    ## Converts source code into a list of tokens.
    def tokenise(self) -> None:
        while not self.empty():
            current = self.at()

            ## Skip comments
            if current == ";":
                while not self.empty() and self.at() != "\n":
                    self.consume()

                continue
            
            if current in self.whitespace:
                self.consume()
                continue
            
            if current in self.numberStart:
                self.tokens.append(self.buildNumber())
            elif current in self.keywordStart:
                self.tokens.append(self.buildKeyword())
            elif current in self.operators:
                self.tokens.append(self.buildOperator())
            elif current in "()[]{}":
                c = self.consume()
                self.tokens.append(Token("Parenthesis", self.line, self.col, c))
            elif current in self.stringTerminators:
                self.tokens.append(self.buildString())
                
            else:
                petlError(f"Unrecognised character '{current}' in lexer.")
