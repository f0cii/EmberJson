from .object import Object
from .value import Value
from .reader import Reader

@value
struct Array(CollectionElement, Sized):
    alias Type = List[Value]
    var _data: Self.Type

    fn __init__(inout self):
        self._data = Self.Type()

    fn __getitem__(self, ind: Int) -> Value:
        return self._data[ind]

    fn __setitem(inout self, ind: Int, owned item: Value):
        self._data[ind] = item^

    fn __len__(self) -> Int:
        return len(self._data)

    fn append(inout self, owned item: Value):
        self._data.append(item^)

    @staticmethod
    fn _from_reader(inout reader: Reader) raises -> Array:
        var out = Self()
        reader.inc()
        while reader.peek() != "]":
            reader.skip_whitespace()
            var v = Value._from_reader(reader)
            out.append(v)
            reader.skip_if(",")
            reader.skip_whitespace()
        reader.inc()
        return out

    @staticmethod
    fn from_string(owned input: String) raises -> Array:
        var r = Reader(input^)
        return Self._from_reader(r)