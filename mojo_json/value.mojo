from .object import Object
from .array import Array
from .reader import Reader

@value
struct Null(Stringable, EqualityComparableCollectionElement):
    fn __eq__(self, n: Null) -> Bool:
        return True
    
    fn __ne__(self, n: Null) -> Bool:
        return False
    
    fn __str__(self) -> String:
        return "null"


fn _read_string(inout reader: Reader) raises -> String:
    reader.inc()
    var res = reader.read_until('"')
    reader.inc()
    return res

@parameter
fn is_numerical_component(char: String) -> Bool:
    return isdigit(ord(char))
        or char == "."
        or char == "e"
        or char == "E"
        or char == "+"
        or char == "-"

fn _read_number(inout reader: Reader) raises -> Variant[Int, Float64]:

    var num = reader.read_while[is_numerical_component]()
    var is_float = num.find(".") != -1

    if is_float:
        return atof(num)
    return atol(num)
    

@value
struct Value(CollectionElement, Stringable):
    alias Type = Variant[Int, Float64, String, Bool, Object, Array, Null]
    var _data: Self.Type

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

    fn __str__(self) -> String:
        return "fart"

    @staticmethod
    fn _from_reader(inout reader: Reader) raises -> Value:
        reader.skip_whitespace()
        var v: Value
        var n = reader.peek()
        if n == '"':
            return _read_string(reader)
        elif n == 't':
            reader.inc(4)
            v = True
        elif n == "f":
            reader.inc(5)
            v = False
        elif n == "n":
            reader.inc(4)
            v =  Null()    
        elif n == "{":
            v = Object._from_reader(reader)
        elif n == "[":
            v = Array._from_reader(reader)
        elif is_numerical_component(n):
            var num = _read_number(reader)
            if num.isa[Int]():
                v = num.unsafe_take[Int]()
            else:
                v = num.unsafe_take[Float64]()
        else:
            print(reader.peek())
            raise Error("Invalid json value")
        reader.skip_whitespace()
        return v
    
    @staticmethod
    fn from_string(owned input: String) raises -> Value:
        print(input)
        var r = Reader(input^)
        return Value._from_reader(r)