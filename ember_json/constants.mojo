from .reader import Byte

alias QUOTE = Byte(ord('"'))
alias T = Byte(ord("t"))
alias F = Byte(ord("f"))
alias N = Byte(ord("n"))
alias LCURLY = Byte(ord("{"))
alias RCURLY = Byte(ord("}"))
alias LBRACKET = Byte(ord("["))
alias RBRACKET = Byte(ord("]"))
alias COLON = Byte(ord(":"))
alias COMMA = Byte(ord(","))

alias NEWLINE = Byte(ord("\n"))
alias TAB = Byte(ord("\t"))
alias SPACE = Byte(ord(" "))
alias LINE_FEED = Byte(ord("\r"))
