from mojo_json import *
from benchmark import *

# source https://opensource.adobe.com/Spry/samples/data_region/JSONDataSetSample.html
var small_data = """{
	"id": "0001",
	"type": "donut",
	"name": "Cake",
	"ppu": 0.55,
	"batters":
		{
			"batter":
				[
					{ "id": "1001", "type": "Regular" },
					{ "id": "1002", "type": "Chocolate" },
					{ "id": "1003", "type": "Blueberry" },
					{ "id": "1004", "type": "Devil's Food" }
				]
		},
	"topping":
		[
			{ "id": "5001", "type": "None" },
			{ "id": "5002", "type": "Glazed" },
			{ "id": "5005", "type": "Sugar" },
			{ "id": "5007", "type": "Powdered Sugar" },
			{ "id": "5006", "type": "Chocolate with Sprinkles" },
			{ "id": "5003", "type": "Chocolate" },
			{ "id": "5004", "type": "Maple" }
		]
}"""

fn main() raises:
    var config = BenchConfig()
    config.verbose_timing = True
    config.tabular_view = True
    var m = Bench(config)
    m.bench_function[benchmark_json_parse_small](BenchId("JsonParseSmall"))
    m.dump_report()

@parameter
fn benchmark_json_parse_small(inout b: Bencher) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = JSON.from_string(small_data)
    b.iter[do]()
    