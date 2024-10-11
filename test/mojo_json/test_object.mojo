from mojo_json.object import Object
from mojo_json.array import Array
from mojo_json.value import Null
from testing import *

def test_object():
    var s = '{"thing": 123}'
    var ob = Object.from_string(s)
    assert_true("thing" in ob)
    assert_equal(ob["thing"].int(), 123)

    s = '{ "Key" : "some value" }'
    ob = Object.from_string(s)
    assert_true("Key" in ob)
    assert_equal(ob["Key"].string(), "some value")

    s = '{"nested": { "foo": null } }"'
    ob = Object.from_string(s)
    assert_true("nested" in ob)
    assert_true(ob["nested"].isa[Object]())
    assert_true(ob["nested"].object()["foo"].isa[Null]())

    assert_true(ob["DOES NOT EXIST"].isa[Null]())

    s = '{"arr": [null, 2, "foo"]}'
    ob = Object.from_string(s)
    assert_true("arr" in ob)
    assert_true(ob["arr"].isa[Array]())
    assert_equal(ob["arr"].array()[0].null(), Null())
    assert_equal(ob["arr"].array()[1].int(), 2)
    assert_equal(ob["arr"].array()[2].string(), "foo")