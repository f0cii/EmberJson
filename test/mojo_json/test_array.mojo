from mojo_json.array import Array
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