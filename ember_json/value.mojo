from .object import Object
from .array import Array
from .reader import Reader
from utils import Variant
from .constants import *


@value
struct Null(Stringable, EqualityComparableCollectionElement, Formattable, Representable):
    fn __eq__(self, n: Null) -> Bool:
        return True

    fn __ne__(self, n: Null) -> Bool:
        return False

    fn __str__(self) -> String:
        return "null"

    fn __repr__(self) -> String:
        return self.__str__()

    fn format_to(self, inout writer: Formatter):
        writer.write(self.__str__())


fn _read_string(inout reader: Reader) raises -> String:
    reader.inc()
    var res = reader.read_until(QUOTE)
    reader.inc()
    return res


@parameter
fn is_numerical_component(char: String) -> Bool:
    alias other_chars: String = ".eE+-"
    return isdigit(ord(char)) or char in other_chars


fn _read_number(inout reader: Reader) raises -> Variant[Int, Float64]:
    var num = reader.read_while[is_numerical_component]()
    var is_float = num.find(".") != -1

    if is_float:
        return atof(num)
    return atol(num)


@value
struct Value(EqualityComparableCollectionElement, Stringable, Formattable, Representable):
    alias Type = Variant[Int, Float64, String, Bool, Object, Array, Null]
    var _data: Self.Type

    fn __init__(inout self, v: Self.Type):
        self._data = v

    fn __init__(inout self, v: Int):
        self._data = v

    fn __init__(inout self, v: Float64):
        self._data = v

    fn __init__(inout self, v: Object):
        self._data = v

    fn __init__(inout self, v: Array):
        self._data = v

    fn __init__(inout self, v: StringLiteral):
        self._data = String(v)

    fn __init__(inout self, v: Null):
        self._data = v

    fn __init__(inout self, v: Bool):
        self._data = v

    fn __copyinit__(inout self, other: Self):
        self._data = other._data

    fn __moveinit__(inout self, owned other: Self):
        self._data = other._data^

    fn __eq__(self, other: Self) -> Bool:
        if self._data._get_discr() != other._data._get_discr():
            return False

        if self.isa[Int]() and other.isa[Int]():
            return self.int() == other.int()
        elif self.isa[Float64]() and other.isa[Float64]():
            return self.float() == other.float()
        elif self.isa[String]() and other.isa[String]():
            return self.string() == other.string()
        elif self.isa[Bool]() and other.isa[Bool]():
            return self.bool() == other.bool()
        elif self.isa[Object]() and other.isa[Object]():
            return self.object() == other.object()
        elif self.isa[Array]() and other.isa[Array]():
            return self.array() == other.array()
        return False

    fn __ne__(self, other: Self) -> Bool:
        return not self == other

    fn isa[T: CollectionElement](self) -> Bool:
        return self._data.isa[T]()

    fn get[T: CollectionElement](self) -> T:
        return self._data[T]

    fn int(self) -> Int:
        return self.get[Int]()

    fn null(self) -> Null:
        return self.get[Null]()

    fn string(self) -> String:
        return self.get[String]()

    fn float(self) -> Float64:
        return self.get[Float64]()

    fn bool(self) -> Bool:
        return self.get[Bool]()

    fn object(self) -> Object:
        return self.get[Object]()

    fn array(self) -> Array:
        return self.get[Array]()

    fn format_to(self, inout writer: Formatter):
        if self.isa[Int]():
            writer.write(self.int())
        elif self.isa[Float64]():
            writer.write(self.float())
        elif self.isa[String]():
            writer.write('"', self.string(), '"')
        elif self.isa[Bool]():
            var b = self.bool()
            writer.write("true" if b else "false")
        elif self.isa[Null]():
            writer.write(self.null())
        elif self.isa[Object]():
            writer.write(self.object())
        elif self.isa[Array]():
            writer.write(self.array())

    @always_inline
    fn __str__(self) -> String:
        return String.format_sequence(self)

    @always_inline
    fn __repr__(self) -> String:
        return String.format_sequence(self)

    @staticmethod
    fn _from_reader(inout reader: Reader) raises -> Value:
        reader.skip_whitespace()
        var v: Value
        var n = reader.peek()
        if n == QUOTE:
            return _read_string(reader)
        elif n == T:
            reader.inc(4)
            v = True
        elif n == F:
            reader.inc(5)
            v = False
        elif n == N:
            reader.inc(4)
            v = Null()
        elif n == LCURLY:
            v = Object._from_reader(reader)
        elif n == LBRACKET:
            v = Array._from_reader(reader)
        elif is_numerical_component(n):
            var num = _read_number(reader)
            if num.isa[Int]():
                v = num.unsafe_take[Int]()
            else:
                v = num.unsafe_take[Float64]()
        else:
            raise Error("Invalid json value")
        reader.skip_whitespace()
        return v

    @staticmethod
    fn from_string(owned input: String) raises -> Value:
        var r = Reader(input^)
        return Value._from_reader(r)
