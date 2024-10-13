from .reader import Reader
from .value import Value, Null
from collections import Dict

@value
struct Object(CollectionElement):
    alias Type = Dict[String, Value]
    var _data: Self.Type

    fn __init__(inout self):
        self._data = Self.Type()

    fn __setitem__(inout self, key: String, owned item: Value):
        self._data[key] = item^

    fn __getitem__(self, key: String) -> Value:
        try:
            return self._data[key]
        except:
            return Null()

    fn __contains__(inout self, key: String) -> Bool:
        return key in self._data

    @staticmethod
    fn _from_reader(inout reader: Reader) raises -> Object:
        reader.inc()
        var out = Self()
        while reader.peek() != "}":
            reader.skip_whitespace()
            if reader.peek() != '"':
                raise Error("Invalid identifier")
            reader.inc()
            var ident = reader.read_until('"')
            reader.inc()
            reader.skip_whitespace()
            if reader.peek() != ':':
                raise Error("Invalid identifier")
            reader.inc()
            var val = Value._from_reader(reader)
            reader.skip_if(",")
            reader.skip_whitespace()
            out[ident] = val^
            print("pee:", reader.peek())
        reader.inc()
        return out

    @staticmethod
    fn from_string(owned s: String) raises -> Object:
        var r = Reader(s^)
        return Self._from_reader(r)