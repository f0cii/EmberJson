from utils import StringSlice, Span
from memory import memcmp
from .constants import *
from sys.intrinsics import likely

alias Bytes = String._buffer_type
alias Byte = UInt8


@always_inline
fn to_byte(s: String) -> Byte:
    return Byte(ord(s))


@always_inline
fn is_space(char: Byte) -> Bool:
    return char == SPACE or char == NEWLINE or char == TAB or char == LINE_FEED


@always_inline
fn bytes_to_string[origin: MutableOrigin, //](b: Span[Byte, origin]) -> String:
    var s = String(b)
    s._buffer.append(0)
    return s

@always_inline
fn byte_to_string(b: Byte) -> String:
    return chr(int(b))


@always_inline
fn compare_bytes[o1: MutableOrigin, o2: MutableOrigin, //](l: Span[Byte, o1], r: Span[Byte, o2]) -> Bool:
    if len(l) != len(r):
        return False
    return memcmp(l.unsafe_ptr(), r.unsafe_ptr(), len(l)) == 0

@always_inline
fn compare_simd[origin: MutableOrigin, size: Int, //](s: Span[Byte, origin], r: SIMD[DType.uint8, size]) -> Bool:
    if len(s) != size:
        return False
    return (s.unsafe_ptr().load[width=size]() == r).reduce_and()


struct Reader:
    var _data: Bytes
    var _index: Int

    fn __init__(inout self, owned data: String):
        self._data = data._buffer^
        # remove the null termination
        _ = self._data.pop()
        data._buffer = Bytes()
        self._index = 0

    @always_inline
    fn peek(ref [_]self) -> ref [self._data] Byte:
        return self._data[self._index]

    @always_inline
    fn next(inout self, chars: Int = 1) -> Span[Byte, __origin_of(self._data)]:
        var start = self._index
        self.inc(chars)
        return Span(self._data)[start : self._index]

    @always_inline
    fn read_until(inout self, char: Byte) -> Span[Byte, __origin_of(self._data)]:
        @parameter
        fn not_char(c: Byte) -> Bool:
            return c != char

        return self.read_while[not_char]()

    @always_inline
    fn read_string(inout self) -> Span[Byte, __origin_of(self._data)]:
        var start = self._index
        while likely(self._index < len(self._data)):
            if self.peek() == QUOTE:
                break
            if self.peek() == RSOL:
                self.inc()
            self.inc()
        return Span(self._data)[start : self._index]

    @always_inline
    fn read_word(inout self) -> Span[Byte, __origin_of(self._data)]:
        @always_inline
        @parameter
        fn func(c: Byte) -> Bool:
            return not is_space(c) and c != COMMA and c != RCURLY and c != RBRACKET

        return self.read_while[func]()

    @always_inline
    fn read_while[func: fn (char: Byte) capturing -> Bool](inout self) -> Span[Byte, __origin_of(self._data)]:
        var start = self._index
        while likely(self._index < len(self._data)) and func(self.peek()):
            self.inc()
        return Span(self._data)[start : self._index]

    @always_inline
    fn skip_whitespace(inout self):
        while likely(self._index < len(self._data)) and is_space(self.peek()):
            self.inc()

    @always_inline
    fn inc(inout self, amount: Int = 1):
        self._index += amount

    @always_inline
    fn skip_if(inout self, char: Byte):
        if self.peek() == char:
            self.inc()

    @always_inline
    fn remaining(self) -> String:
        return String(self._data[self._index :] + Byte(0))

    @always_inline
    fn bytes_remaining(self) -> Int:
        return len(self._data) - self._index

    @always_inline
    fn has_more(self) -> Bool:
        return self.bytes_remaining() != 0
