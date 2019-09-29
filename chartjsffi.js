function chartjsChart(id, x, y) {

    function listsToDataPoints(inx,iny) {
	var acc = [];
	var xs = inx;
	var ys = iny;
	for (; xs !== null; xs=xs._2, ys=ys._2) {
	    acc.push({x: xs._1, y: ys._1});
	}
	return acc;
    }

    var datapoints = listsToDataPoints(x,y);

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

function makeChartjs(id) {

    return new Chart(id, {});

}

function idAsString(id) {
    return id;
}
function stringAsId(s) {
    return s;
}
