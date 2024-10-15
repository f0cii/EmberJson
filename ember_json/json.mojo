from collections import Dict
from utils import Variant
from .reader import Reader
from .object import Object
from .array import Array


@value
struct JSON:
    alias Type = Variant[Object, Array]
    var _data: Self.Type

    fn __init__(inout self):
        self._data = Object()

    fn isa[T: CollectionElement](self) -> Bool:
        return self._data.isa[T]()

    fn is_object(self) -> Bool:
        return self.isa[Object]()

    fn is_array(self) -> Bool:
        return self.isa[Array]()

    fn get[T: CollectionElement](self) -> T:
        return self._data[T]

    fn object(self) -> Object:
        return self.get[Object]()

    fn array(self) -> Array:
        return self.get[Array]()

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
