function canvasjsChart(id, x, y) {

    function listsToDataPoints(inx,iny) {
	var acc = [];
	var xs = inx;
	var ys = iny;
	for (; xs !== null; xs=xs._2, ys=ys._2) {
	    acc.push({x: xs._1, y: ys._1});
	}
	return acc;
    }

    var data = listsToDataPoints(x,y);

    var chart = new CanvasJS.Chart(id,
				   {
				       data: [{
					   type: 'line',
					   dataPoints: data}]
				   });

    chart.render();

    // return chart;
}

function idAsString(id) {
    return id;
}
function stringAsId(s) {
    return s;
}
