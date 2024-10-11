from mojo_json.value import Value, Null
from testing import *

def test_bool():
    var s = "false"
    var v = Value.from_string(s)
    assert_true(v.isa[Bool]())
    assert_equal(v.get[Bool](), False)

    s = "true"
    v = Value.from_string(s)
    assert_true(v.isa[Bool]())
    assert_equal(v.get[Bool](), True)

def test_string():
    var s = '"Some String"'
    var v = Value.from_string(s)
    assert_true(v.isa[String]())
    assert_equal(v.get[String](), "Some String")

def test_null():
    var s = "null"
    var v = Value.from_string(s)
    assert_true(v.isa[Null]())
    assert_equal(v.get[Null](), Null())

def test_number():
    var v = Value.from_string("123")
    assert_true(v.isa[Int]())
    assert_equal(v.get[Int](), 123)

    v = Value.from_string("+123")
    assert_true(v.isa[Int]())
    assert_equal(v.get[Int](), 123)

    v = Value.from_string("-123")
    assert_true(v.isa[Int]())
    assert_equal(v.get[Int](), -123)

    v = Value.from_string("43.5")
    assert_true(v.isa[Float64]())
    assert_equal(v.get[Float64](), 43.5)

    v = Value.from_string("+43.5")
    assert_true(v.isa[Float64]())
    assert_equal(v.get[Float64](), 43.5)

    v = Value.from_string("-43.5")
    assert_true(v.isa[Float64]())
    assert_equal(v.get[Float64](), -43.5)

    v = Value.from_string("43.5e10")
    assert_true(v.isa[Float64]())
    assert_equal(v.get[Float64](), 43.5e10)

    v = Value.from_string("-43.5e10")
    assert_true(v.isa[Float64]())
    assert_equal(v.get[Float64](), -43.5e10)