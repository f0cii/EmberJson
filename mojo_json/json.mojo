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

    @staticmethod
    fn from_string(owned input: String) raises -> JSON:
        var data: JSON.Type = JSON()
        var reader = Reader(input^)
        
        var next_char = reader.peek()
        if next_char == "{":
            data = Object._from_reader(reader)
        elif next_char == "[":
            data = Array._from_reader(reader)
        else:
            _scream()

        return JSON(data^)

@always_inline
fn _scream() raises:
    raise Error("Invalid json")