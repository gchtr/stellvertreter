var n = 40;
var data = d3.range(n).map(function() {
  return 0;
});

console.log(data);

var margin = {top: 20, right: 20, bottom: 20, left: 40},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var x = d3.scale.linear()
    .domain([1, n - 2])
    .range([0, width]);

var y = d3.scale.linear()
    .domain([0, 1])
    .range([height, 0]);

var line = d3.svg.line()
    .interpolate("basis")
    .x(function(d, i) { return x(i); })
    .y(function(d, i) { return y(d); });

var svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg.append("defs").append("clipPath")
    .attr("id", "clip")
  .append("rect")
    .attr("width", width)
    .attr("height", height);

svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + y(0) + ")")
    .call(d3.svg.axis().scale(x).orient("bottom"));

svg.append("g")
    .attr("class", "y axis")
    .call(d3.svg.axis().scale(y).orient("left"));

var path = svg.append("g")
    .attr("clip-path", "url(#clip)")
  .append("path")
    .datum(data)
    .attr("class", "line")
    .attr("d", line);

function printData(msg) {
  /**
   * Strip last comma from string as it arrives with a trailing comma
   */
  if (msg.endsWith(',')) {
    msg = msg.substring(0, msg.length - 1);
  }

  var split = msg.split(',');

  /**
   * Convert to int
   */
  var numbers = split.map(function(el) {
    return parseInt(el, 10);
  });

  pushValues(numbers);
}

function pushValues(numbers) {
  var value = numbers[0]/1023;

  console.log(value);
  // push a new data point onto the back
  data.push(value);

  // pop the old data point off the front
  data.shift();
}

// first tick
tick();

function tick() {

  // redraw the line, and slide it to the left
  path
      .attr("d", line)
      .attr("transform", null)
    .transition()
      .duration(1000)
      .ease("linear")
      .attr("transform", "translate(" + x(0) + ",0)")
      .each("end", tick);
}
