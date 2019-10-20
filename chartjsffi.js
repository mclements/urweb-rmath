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

function objectMap(object, mapFn) {
    return Object.keys(object).reduce(function(result, key) {
	result[key] = mapFn(object[key])
	return result
    }, {})
}

function urToObject(l) {
    // case: atom
    if (typeof(l) != 'object') {
	return l;
    }
    // case: JavaScript array (not used)
    else if (Array.isArray(l)) {
	return l.map(urToObject);
    }
    // case: Ur/Web list
    else if (Object.keys(l)[0] == '_1') {
	var acc = [];
	var ll = l;
	for (; ll !== null; ll=ll._2) {
	    acc.push(urToObject(ll._1));
	}
	return acc;
    }
    // case: Ur/Web struct
    else {
	return Object.keys(l).reduce(function(result, key) {
	    var newkey = key.substr(1,1).toLowerCase()+key.substr(2);
	    var y = urToObject(l[key]);
	    if (newkey == "typ") {
		newkey = "type";
	    }
	    if (y != null) {
		result[newkey] = urToObject(l[key]);
	    }
	    return result;
	}, {});
    }
}

function chartjsChartStruct(id, obj) {

    var ctx = document.getElementById(id).getContext('2d');

    var chart = new Chart.Scatter(ctx, urToObject(obj));
    
    return chart;
}

function chartjsChartStructDebug(id, obj) {

    alert(JSON.stringify(urToObject(obj)));
    
    return chartjsChartStruct(id,obj);
}
