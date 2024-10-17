from .object import Object
from .value import Value
from .reader import Reader
from .constants import *
from sys.intrinsics import unlikely


@value
struct Array(EqualityComparableCollectionElement, Sized, Formattable, Stringable, Representable):
    alias Type = List[Value]
    var _data: Self.Type

    fn __init__(inout self):
        self._data = Self.Type()

    fn __init__(inout self, owned *values: Value):
        self._data = Self.Type(variadic_list=values^)

    fn __getitem__(ref [_]self, ind: Int) -> ref [self._data] Value:
        return self._data[ind]

    fn __setitem(inout self, ind: Int, owned item: Value):
        self._data[ind] = item^

    fn __len__(self) -> Int:
        return len(self._data)

    fn __contains__[T: EqualityComparableCollectionElement, //](self, item: T) -> Bool:
        for v in self._data:
            if v[].isa[T]() and v[].get[T]() == item:
                return True
        return False

    @always_inline
    fn __contains__(self, v: Value) -> Bool:
        return v in self._data

    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        return self._data == other._data

    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        return self._data != other._data

    fn format_to(self, inout writer: Formatter):
        writer.write("[")
        for i in range(len(self._data)):
            writer.write(self._data[i])
            if i != len(self._data) - 1:
                writer.write(", ")
        writer.write("]")

    fn __str__(self) -> String:
        return String.format_sequence(self)

    fn __repr__(self) -> String:
        return self.__str__()

    fn append(inout self, owned item: Value):
        self._data.append(item^)

    @staticmethod
    fn _from_reader(inout reader: Reader) raises -> Array:
        var out = Self()
        reader.inc()
        reader.skip_whitespace()
        while reader.peek() != RBRACKET:
            var v = Value._from_reader(reader)
            out.append(v^)
            var has_comma = False 
            if reader.peek() == COMMA:
                has_comma = True
                reader.inc()
            reader.skip_whitespace()
            if reader.peek() == RBRACKET and has_comma:
                raise Error("Illegal trailing comma")
        reader.inc()
        return out^

    @staticmethod
    fn from_string(owned input: String) raises -> Array:
        var r = Reader(input^)
        return Self._from_reader(r)
