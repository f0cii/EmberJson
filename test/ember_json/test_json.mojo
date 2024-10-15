from ember_json import JSON
from testing import *

def test_json_object():
    var s = '{"key": 123}'
    var json = JSON.from_string(s)
    assert_true(json.is_object())
    assert_equal(json.object()["key"].int(), 123)
    assert_equal(json["key"].int(), 123)

    assert_equal(str(json), '{"key": 123}')

    assert_equal(len(json), 1)

    with assert_raises():
        _ = json[2]

def test_json_array():
    var s = '[123, 345]'
    var json = JSON.from_string(s)
    assert_true(json.is_array())
    assert_equal(json.array()[0].int(), 123)
    assert_equal(json.array()[1].int(), 345)
    assert_equal(json[0].int(), 123)

    assert_equal(str(json), '[123, 345]')

    assert_equal(len(json), 2)

    with assert_raises():
        _ = json["key"]

def test_equality():

    var ob = JSON.from_string('{"key": 123}')
    var ob2 = JSON.from_string('{"key": 123}')
    var arr = JSON.from_string('[123, 345]')

    assert_equal(ob, ob2)
    ob["key"] = 456
    assert_not_equal(ob, ob2)
    assert_not_equal(ob, arr)