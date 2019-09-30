function chartjsChart(id, l) {

    function listToDataPoints(l) {
	var acc = [];
	var ll = l;
	for (; ll !== null; ll=ll._2) {
	    acc.push({x: ll._1._1, y: ll._1._2});
	}
	return acc;
    }

    var datapoints = listToDataPoints(l);

    var ctx = document.getElementById(id).getContext('2d');
    
    var chart = new Chart.Scatter(ctx,
			  {
			      data : {datasets: [{data : datapoints,
						  fill : false,
						  showLine : true}]},
			      options : {legend : false}
			  });

    return chart;
}
