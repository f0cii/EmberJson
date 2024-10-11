from mojo_json.array import Array
from mojo_json.value import Null
from testing import *

def test_array():
    var s = '[ 1, 2, "foo" ]'
    var arr = Array.from_string(s)
    assert_equal(len(arr), 3)
    assert_equal(arr[0].get[Int](), 1)
    assert_equal(arr[1].get[Int](), 2)
    assert_equal(arr[2].get[String](), "foo")

    s = '[1,2,"foo"]'
    arr = Array.from_string(s)
    assert_equal(len(arr), 3)
    assert_equal(arr[0].get[Int](), 1)
    assert_equal(arr[1].get[Int](), 2)
    assert_equal(arr[2].get[String](), "foo")

    s = '[false, null, [4.0], { "key": "bar" }]'
    arr = Array.from_string(s)
    assert_equal(len(arr), 4)
    assert_equal(arr[0].bool(), False)
    assert_equal(arr[1].null(), Null())
    var nested_arr = arr[2].array()
    assert_equal(len(nested_arr), 1)
    assert_equal(nested_arr[0].float(), 4.0)
    var ob = arr[3].object()
    assert_true("key" in ob)
    assert_equal(ob["key"].string(), "bar")
