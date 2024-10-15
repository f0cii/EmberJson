from ember_json import JSON
from testing import *

def test_json_object():
    var s = '{"key": 123}'
    var json = JSON.from_string(s)
    assert_true(json.is_object())
    assert_equal(json.object()["key"].int(), 123)
    assert_equal(json["key"].int(), 123)

    with assert_raises():
        _ = json[2]

def test_json_array():
    var s = '[123, 345]'
    var json = JSON.from_string(s)
    assert_true(json.is_array())
    assert_equal(json.array()[0].int(), 123)
    assert_equal(json.array()[1].int(), 345)
    assert_equal(json[0].int(), 123)

    with assert_raises():
        _ = json["key"]