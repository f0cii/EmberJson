from utils import StringSlice


struct Reader:
    var _data: String
    var _index: Int

    fn __init__(inout self, owned data: String):
        self._data = data^
        self._index = 0

    @always_inline
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

    @always_inline
    fn skip_whitespace(inout self):
        while self._index < len(self._data) and self.peek().isspace():
            self.inc()

    @always_inline
    fn inc(inout self, amount: Int = 1):
        self._index += amount

    @always_inline
    fn skip_if(inout self, char: String):
        if self.peek() == char:
            self.inc()

    @always_inline
    fn remaining(self) -> String:
        return self._data[self._index :]
