function chartjsChart(id, l) {

    function listToDataPoints(l) {
	var acc = [];
	var ll = l;
	for (; ll !== null; ll=ll._2) {
	    acc.push({x: ll._1._X, y: ll._1._Y});
	}
	return acc;
    }

    var datapoints = listToDataPoints(l);

    var ctx = document.getElementById(id).getContext('2d');
    
    var chart = new Chart(ctx,
			  {
			      type : 'scatter',
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
	result[key] = mapFn(object[key]);
	return result;
    }, {});
}

var urNewKeyMap = {typ : "type"};

function objectifyUr(urValue, newKeyMap) {
    function convert(ur) {
	// case: null value
	if (ur == null) {
	    return null;
	}
	// case: atom
	else if (typeof(ur) != 'object') {
	    return ur;
	}
	// case: JavaScript array (not used)
	else if (Array.isArray(ur)) {
	    return ur.map(convert);
	}
	// case: Ur/Web list
	else if (Object.keys(ur)[0] == '_1') {
	    var acc = [];
	    var ll = ur; // is this needed?
	    for (; ll !== null; ll=ll._2) {
		acc.push(convert(ll._1));
	    }
	    return acc;
	}
	// case: Some list
	else if (Object.keys(ur)[0] == 'v') {
    	    return convert(ur.v);
	}
	// case: Some ??
	else if (Object.keys(ur)[0] == 'n' && Object.keys(ur)[1] == 'v') {
    	    return convert(ur.v);
	}
	// case: Ur/Web struct
	else {
	    return Object.keys(ur).reduce(function(result, key) {
		var newKey = key.substr(1,1).toLowerCase()+key.substr(2);
		var y = convert(ur[key]);
		if (Object.keys(newKeyMap).includes(newKey)) {
		    newKey = newKeyMap[newKey];
		}
		if (y != null) {
		    result[newKey] = convert(ur[key]);
		}
		return result;
	    }, {});
	}
    }
    return convert(urValue, newKeyMap);
}

function chartjsChartStruct(id, obj) {

    var ctx = document.getElementById(id).getContext('2d');

    var chart = new Chart(ctx, objectifyUr(obj, urNewKeyMap));
    
    return chart;
}

function chartjsChartStructDebug(id, obj) {

    alert(JSON.stringify(obj));
    // alert(JSON.stringify(objectifyUr(obj)));
    
    return chartjsChartStruct(id,obj);
}
