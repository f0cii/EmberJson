# EmberJson

A lightweight JSON parsing library for Mojo.

## Usage

```mojo
from ember_json import *

# parse string
var s = '{"key": 123}'
var json = JSON.from_string(s)

print(json.is_object()) # prints true

# fetch inner value
var ob = json.object()
print(ob["key"].int()) # prints 123

# json array
s = '[123, 456]'
json = JSON.from_string(s)
var arr = json.array()
```
