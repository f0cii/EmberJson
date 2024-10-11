from utils import StringSlice

struct Reader:
    var _data: String
    var _index: Int

    fn __init__(inout self, owned data: String):
        self._data = data^
        self._index = 0

    fn peek(self) -> String:
        return self._data[self._index]
    
    fn next(inout self, chars: Int = 1) -> String:
        var start = self._index
        self.inc(chars)
        return self._data[start : start + chars]
    
    fn read_until(inout self, char: String) -> String:
        @parameter
        fn not_char(c: String) -> Bool:
            return c != char
        return self.read_while[not_char]()

    fn read_while[func: fn (char: String) capturing -> Bool](inout self) -> String:
        var start = self._index
        while self._index < len(self._data) and func(self.peek()):
            self.inc()
        return self._data[start : self._index]

    fn skip_whitespace(inout self):
        @parameter
        fn is_ws(char: String) -> Bool:
            return char == "\n" or char == "\r" or char == " "

        while self._index < len(self._data) and is_ws(self.peek()):
            self.inc()

    fn inc(inout self, amount: Int = 1):
        self._index += amount

    fn skip_if(inout self, char: String):
        if self.peek() == char:
            self.inc()