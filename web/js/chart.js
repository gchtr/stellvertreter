// set up our data series with 150 random data points

var empties = 50;
var initValue = 0.1;
var timeCount = empties + 1;
var seriesData = [ [], [], [], [] ];
var isRunning = true;

seriesData.forEach(function(series, index) {
  for (var i = 0; i < empties; i++) {
    series.push({x: i, y: initValue});
  }
});

var graph = new Rickshaw.Graph( {
  element: document.getElementById("chart"),
  width: 1200,
  height: 500,
  renderer: 'area',
  stroke: true,
  preserve: true,
  series: [
    {
      color: '#e6ad47',
      data: seriesData[0],
      name: 'Links vorne'
    }, {
      color: '#ff5755',
      data: seriesData[1],
      name: 'Links hinten'
    }, {
      color: '#64d182',
      data: seriesData[2],
      name: 'Rechts vorne'
    }, {
      color: '#8e36d9',
      data: seriesData[3],
      name: 'Rechts hinten'
    }
  ]
} );

graph.render();

var legend = new Rickshaw.Graph.Legend({
    graph: graph,
    element: document.querySelector('#legend')
});

var shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
    graph: graph,
    legend: legend
});

var highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
    graph: graph,
    legend: legend
});

var ticksTreatment = 'glow';

var xAxis = new Rickshaw.Graph.Axis.Time( {
  graph: graph,
  ticksTreatment: ticksTreatment,
  timeFixture: new Rickshaw.Fixtures.Time.Local()
} );

xAxis.render();

var yAxis = new Rickshaw.Graph.Axis.Y( {
  graph: graph,
  tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
  ticksTreatment: ticksTreatment,
} );

yAxis.render();

function pushValues(numbers) {
  var rangeMax = 1023;

  seriesData.forEach(function(series, index) {
    var y = numbers[index]/rangeMax;
    var x = timeCount;
    series.shift();
    series.push({x: x, y: y});
  });

  timeCount++;
  graph.update();
}

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

  if (isRunning) {
    pushValues(numbers);
  }

}

var Controls = {

  el: {
    $play: $('#play'),
    $pause: $('#pause'),
    $reset: $('#reset')
  },

  init: function() {
    this.bindEvents();
  },

  bindEvents: function() {
    this.el.$play.on('click', this.play);
    this.el.$pause.on('click', this.pause);
    this.el.$reset.on('click', this.reset);
  },

  play: function() {
    isRunning = true;
  },

  pause: function() {
    isRunning = false;
  },

  reset: function() {
    seriesData.forEach(function(series) {
      for (var i = 0; i < empties; i++) {
        series[i] = {x: i, y: initValue};
      }
    });
    timeCount = empties + 1;
  }

}

$(document).ready(function() {
  Controls.init();
});
