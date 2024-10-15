from collections import Dict
from utils import Variant
from .reader import Reader
from .object import Object
from .array import Array
from os import abort


@value
struct JSON(CollectionElement, Stringable, Formattable, Representable):
    alias Type = Variant[Object, Array]
    var _data: Self.Type

    fn __init__(inout self):
        self._data = Object()

    @always_inline
    fn get[T: CollectionElement](ref [_]self: Self) -> ref [self._data] T:
        return self._data.__getitem__[T]()

    fn object(ref [_]self) -> ref[self._data] Object:
        return self.get[Object]()

    fn array(ref [_]self) -> ref[self._data] Array:
        return self.get[Array]()

    fn __getitem__(ref [_]self, key: String) raises -> ref[self.object()._data._entries[0].value().value] Value:
        if not self.is_object():
            raise Error("Array index must be an int")
        return  self.object().__getitem__(key)

    fn __getitem__(ref [_]self, ind: Int) raises -> ref[self.array()._data] Value:
        if not self.is_array():
            raise Error("Object key expected to be string")
        return self.array()[ind]

    fn format_to(self, inout writer: Formatter):
        if self.is_object():
            self.object().format_to(writer)
        elif self.is_array():
            self.array().format_to(writer)

    fn __str__(self) -> String:
        return String.format_sequence(self)

    fn __repr__(self) -> String:
        return self.__str__()

    fn isa[T: CollectionElement](self) -> Bool:
        return self._data.isa[T]()

    fn is_object(self) -> Bool:
        return self.isa[Object]()

    fn is_array(self) -> Bool:
        return self.isa[Array]()

    @staticmethod
    fn from_string(owned input: String) raises -> JSON:
        var data = Self()
        var reader = Reader(input^)
        reader.skip_whitespace()
        var next_char = reader.peek()
        if next_char == "{":
            data = Object._from_reader(reader)
        elif next_char == "[":
            data = Array._from_reader(reader)
        else:
            raise Error("Invalid json")

        return data
