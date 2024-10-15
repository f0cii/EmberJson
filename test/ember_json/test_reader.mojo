from ember_json.reader import Reader
from testing import *

def test_peek():
    r = Reader("Some String")
    r.inc()
    assert_equal(r.peek(), "o")

def test_next():
    r = Reader("Some String")
    assert_equal(r.next(4), "Some")

def test_read_until():
    r = Reader("Some String")
    assert_equal(r.read_until("r"), "Some St")