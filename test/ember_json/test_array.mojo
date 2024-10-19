from emberjson.array import Array
from emberjson import Object
from emberjson.value import Null, Value
from testing import *

def test_array():
    var s = '[ 1, 2, "foo" ]'
    var arr = Array.from_string(s)
    assert_equal(len(arr), 3)
    assert_equal(arr[0].get[Int](), 1)
    assert_equal(arr[1].get[Int](), 2)
    assert_equal(arr[2].get[String](), "foo")
    assert_equal(str(arr), '[1, 2, "foo"]')

def test_array_no_space():
    var s = '[1,2,"foo"]'
    var arr = Array.from_string(s)
    assert_equal(len(arr), 3)
    assert_equal(arr[0].get[Int](), 1)
    assert_equal(arr[1].get[Int](), 2)
    assert_equal(arr[2].get[String](), "foo")

def test_nested_object():
    var s = '[false, null, [4.0], { "key": "bar" }]'
    var arr = Array.from_string(s)
    assert_equal(len(arr), 4)
    assert_equal(arr[0].bool(), False)
    assert_equal(arr[1].null(), Null())
    var nested_arr = arr[2].array()
    assert_equal(len(nested_arr), 1)
    assert_equal(nested_arr[0].float(), 4.0)
    var ob = arr[3].object()
    assert_true("key" in ob)
    assert_equal(ob["key"].string(), "bar")

def test_contains():
    var s = '[false, 123, "str"]'
    var arr = Array.from_string(s)
    assert_true(False in arr)
    assert_true(123 in arr)
    assert_true(String("str") in arr)
    assert_false(True in arr)
    assert_true(True not in arr)

def test_variadic_init():
    var arr = Array(123,
        "foo",
        Null()
    )
    var ob = Object()
    ob["key"] = "value"

    var arr2 = Array(
        Int(45),
        45.5,
        Float64(45.5),
        arr,
        ob
    )
    assert_equal(arr[0].int(), 123)
    assert_equal(arr[1].string(), "foo")
    assert_equal(arr[2].null(), Null())

    assert_equal(arr2[0], 45)
    assert_equal(arr2[1], 45.5)
    assert_equal(arr2[2], 45.5)
    assert_true(arr2[3].isa[Array]())
    assert_true(arr2[4].isa[Object]())

def test_equality():
    var arr1 = Array(123, 456)
    var arr2 = Array(123, 456)
    var arr3 = Array(123, "456")
    assert_equal(arr1, arr2)
    assert_not_equal(arr1, arr3)