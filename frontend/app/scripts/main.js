/* jshint devel:true */

var Searcher = {
  init: function() {
    $(this.selector).typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    },
    {
      name: 'donations',
      source: this.substringMatcher(this.donationsDataSource)
    });
  },
  selector: '#search-field',
  donationsDataSource: [],
  substringMatcher: function(strs) {
    return function findMatches(q, cb) {
      var matches, substrRegex, data;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          // the typeahead jQuery plugin expects suggestions to a
          // JavaScript object, refer to typeahead docs for more info
          matches.push({ value: str });
        }
      });

      cb(matches);
    };
  }
};

$(function() {
  function insertTreemap(path) {
    var margin = {top: 40, right: 0, bottom: 0, left: 0},
    width = 700 - margin.right - margin.left,
    height = 500 - margin.top - margin.bottom,
    formatNumber = d3.format('$,f'),
    transitioning;

    var x = d3.scale.linear()
    .domain([0, width])
    .range([0, width]);

    var y = d3.scale.linear()
    .domain([0, height])
    .range([0, height]);

    var mousemove = function(d) {
      var xPosition = d3.event.pageX - 15;
      var yPosition = d3.event.pageY + 5;

      d3.select("#tooltip")
        .style("left", xPosition + "px")
        .style("top", yPosition + "px");

      d3.select("#tooltip")
        .html(tooltipText(d));
        // .html('<p>'+d.name+'</p>' + '<br>' + '<p>' + d["value"] + '</p>');

      d3.select("#tooltip").classed("hidden", false);
    };

    function tooltipText(d) {
      var text = "";
      text = text + "<p>" + d.name + "</p>";
      text = text + "<p>" + formatNumber(d.value) + "</p>";
      if(d.parent) {
        text = text + "<p>" + "Overall "  + d.parent.name + "</p>";
        text = text + "<p>" + formatNumber(d.parent.value) + "</p>";
      }
      return text;
    }


    var mouseout = function() {
      d3.select("#tooltip").classed("hidden",true)
    };

    var treemap = d3.layout.treemap()
    .children(function(d, depth) { return depth ? null : d._children; })
    .sort(function(a, b) { return a.value - b.value; })
    .ratio(height / width * 0.5 * (1 + Math.sqrt(5)))
    .round(false);

    var svg = d3.select('#treemap').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.bottom + margin.top)
    .style('margin-left', -margin.left + 'px')
    .style('margin.right', -margin.right + 'px')
    .append('g')
    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
    .style('shape-rendering', 'crispEdges');

    var grandparent = svg.append('g')
    .attr('class', 'grandparent');

    grandparent.append('rect')
    .attr('y', -margin.top)
    .attr('width', width)
    .attr('height', margin.top);

    grandparent.append('text')
    .attr('x', 20)
    .attr('y', 10 - margin.top)
    .attr('dy', '1em');

    d3.json(path, function(root) {
      initialize(root);
      var totalSpending = accumulate(root);
      layout(root);
      display(root);
      setupSearch();

      function initialize(root) {
        root.x = root.y = 0;
        root.dx = width;
        root.dy = height;
        root.depth = 0;
      }

      // Aggregate the values for internal nodes. This is normally done by the
      // treemap layout, but not here because of our custom implementation.
      // We also take a snapshot of the original children (_children) to avoid
      // the children being overwritten when when layout is computed.
      function accumulate(d) {
        return (d._children = d.children)
          ? d.value = d.children.reduce(function(p, v) { return p + accumulate(v); }, 0)
          : d.value;
      }

      // Compute the treemap layout recursively such that each group of siblings
      // uses the same size (1×1) rather than the dimensions of the parent cell.
      // This optimizes the layout for the current zoom state. Note that a wrapper
      // object is created for the parent node for each group of siblings so that
      // the parent’s dimensions are not discarded as we recurse. Since each group
      // of sibling was laid out in 1×1, we must rescale to fit using absolute
      // coordinates. This lets us use a viewport to zoom.
      function layout(d) {
        if (d._children) {
          treemap.nodes({_children: d._children});
          d._children.forEach(function(c) {
            c.x = d.x + c.x * d.dx;
            c.y = d.y + c.y * d.dy;
            c.dx *= d.dx;
            c.dy *= d.dy;
            c.parent = d;
            layout(c);
          });
        }
      }

      function display(d) {
        grandparent
        .datum(d.parent)
        .on('click', transition)
        .select('text')
        .text(name(d));

        var g1 = svg.insert('g', '.grandparent')
        .datum(d)
        .attr('class', 'depth');

        var g = g1.selectAll('g')
        .data(d._children)
        .enter().append('g');

        g.filter(function(d) { return d._children; })
        .classed('children', true)
        .on('click', transition);

        g.selectAll('.child')
        .data(function(d) { return d._children || [d]; })
        .enter().append('rect')
        .attr('class', 'child')
        .call(rect);

        g.append('rect')
        .attr('class', 'parent')
        .call(rect)
        .on("mousemove", mousemove)
        .on("mouseout", mouseout);

        /* g.append("text")
        .attr("dy", ".75em")
        .text(function(d) { return d.name; })
        .call(text); */

        $(Searcher.selector).on('typeahead:selected', transitionToNode);
        $(Searcher.selector).on('typeahead:autocompleted', transitionToNode);

        function findNode(event, suggestion, datasetName) {
          var children = selectTreemapChildren();
          var selectedNode = children.filter(function(c) { return c.name === suggestion.value })[0];
          return selectedNode;
        }

        function transitionToNode(event, suggestion, datasetName) {
          $(Searcher.selector).typeahead('val', '');
          var selectedNode = findNode(event, suggestion, datasetName);
          //var transitionSequence = findParentChain(selectedNode);
          //for(var i = 0, len = transitionSequence.length; i < len; i++) {
          //  transition(transitionSequence[i]);
          //}
          transition(selectedNode);
        }

        function findParentChain(node, chain) {
          var nodeChain = [];
          if(chain) nodeChain = chain;
          nodeChain.push(node);

          if(node.parent) {
            return findParentChain(node.parent, nodeChain)
          }
          else {
            return nodeChain;
          }
        }

        function transition(d) {
          if (transitioning || !d) return;
          transitioning = true;

          var svg = d3.selectAll('svg');

          var g2 = display(d),
          t1 = g1.transition().duration(750),
          t2 = g2.transition().duration(750);

          // Update the domain only after entering new elements.
          x.domain([d.x, d.x + d.dx]);
          y.domain([d.y, d.y + d.dy]);

          // Enable anti-aliasing during the transition.
          svg.style('shape-rendering', null);

          // Draw child nodes on top of parent nodes.
          svg.selectAll('.depth').sort(function(a, b) { return a.depth - b.depth; });

          // Clean up
          var els = svg.selectAll('.depth')[0].reverse();
          if(els.length > 2) {
            for(var i = 2; i < els.length; i++) {
              els[i].remove();
            }
          }

          // Fade-in entering text.
          g2.selectAll('text').style('fill-opacity', 0);

          // Transition to the new view.
          t1.selectAll('text').call(text).style('fill-opacity', 0);
          t2.selectAll('text').call(text).style('fill-opacity', 1);
          t1.selectAll('rect').call(rect);
          t2.selectAll('rect').call(rect);

          // Remove the old node when the transition is finished.
          t1.remove().each('end', function() {
            svg.style('shape-rendering', 'crispEdges');
            transitioning = false;
          });
        }

        return g;
      }
      function text(text) {
        text.attr('x', function(d) { return x(d.x) + 6; })
        .attr('y', function(d) { return y(d.y) + 6; });
      }

      function rect(rect) {
        rect.attr('x', function(d) { return x(d.x); })
        .attr('y', function(d) { return y(d.y); })
        .attr('width', function(d) { return x(d.x + d.dx) - x(d.x); })
        .attr('height', function(d) { return y(d.y + d.dy) - y(d.y); })
        .style('fill', function(d) { return findColour(d); })
        .style('opacity', '0.5');

      }

      function findColour(d) {
        if(d.colour) {
          return d.colour;
        }
        else {
          if(d.parent) {
            return findColour(d.parent);
          } else
          {
            return '#7f8c8d';
          }
        }
      };

      function name(d) {
        return d.parent ? name(d.parent) + ' - ' + d.name : d.name;
      };

      function selectTreemapChildren() {
        var dataSource = [];
        dataSource = d3.selectAll('g.children').data();
        dataSource = dataSource.concat(d3.selectAll('g.children rect').data());
        return dataSource;
      }

      function setupSearch() {
        Searcher.donationsDataSource = selectTreemapChildren().map(function(d) { return d.name });
        Searcher.init()
      };
    });
  };

  insertTreemap('parties.json');

  $('.by-party').on('click', function(e) {
    e.preventDefault();
    $('button').removeClass('active');
    $('button.by-party').addClass('active');
    $(Searcher.selector).typeahead('destroy');
    $('#treemap').empty();
    insertTreemap('parties.json');
  });
  $('.by-electorate').on('click', function(e) {
    e.preventDefault();
    $('button').removeClass('active');
    $('button.by-electorate').addClass('active');
    $(Searcher.selector).typeahead('destroy');
    $('#treemap').empty();
    insertTreemap('electorates.json');
  });
  $('.by-donor').on('click', function(e) {
    e.preventDefault();
    $('button').removeClass('active');
    $('button.by-donor').addClass('active');
    $(Searcher.selector).typeahead('destroy');
    $('#treemap').empty();
    insertTreemap('donors.json');
  });
});
