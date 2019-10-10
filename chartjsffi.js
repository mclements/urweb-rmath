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

function chartjsChartJson(id, json_string) {

    var ctx = document.getElementById(id).getContext('2d');
    
    var chart = new Chart.Scatter(ctx, JSON.parse(json_string));
    
    return chart;
}

function objectMapUr(object, mapFn) {
    return Object.keys(object).reduce(function(result, key) {
	if (key == "_Typ") {
	    result["type"] = mapFn(object[key])
	} else {
	    result[key.substr(1,1).toLowerCase()+key.substr(2)] = mapFn(object[key])
	}
	return result
    }, {})
}

function urToObject(l) {
    if (typeof(l) != 'object') {
	return l;
    }
    else if (Array.isArray(l)) {
	return l.map(urToObject);
    }
    else if (Object.keys(l)[0] == '_1') {
	var acc = [];
	var ll = l;
	for (; ll !== null; ll=ll._2) {
	    acc.push(urToObject(ll._1));
	}
	return acc;
    }
    else {
	return objectMapUr(l,urToObject);
    }
}

function chartjsChartStruct(id, obj) {

    var ctx = document.getElementById(id).getContext('2d');

    var chart = new Chart.Scatter(ctx, urToObject(obj));
    
    return chart;
}
