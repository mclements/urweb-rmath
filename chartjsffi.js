function chartjsChartOld(id, l) {

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
						  borderColor : "green",
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
	// case: Type constructor
	else if (Object.keys(ur)[0] == 'n' && Object.keys(ur)[1] == 'v') {
	    var d = {};
	    var key = '_'+ur.n;
	    d[key] = convert(ur.v);
    	    return convert(d);
	}
	// case: Ur/Web struct
	else {
	    return Object.keys(ur).reduce(function(result, key) {
		var y = convert(ur[key]);
		var newKey = key;
		if (key.substr(0,1)=='_') {
		    newKey = key.substr(1,1).toLowerCase()+key.substr(2);
		}
		if (Object.keys(newKeyMap).includes(newKey)) {
		    newKey = newKeyMap[newKey];
		}
		if (y != null) {
		    result[newKey] = y;
		}
		return result;
	    }, {});
	}
    }
    return convert(urValue, newKeyMap);
}

function chartjsArgs(obj) {
    function convert(obj) {
        function array2object(a) {
            var acc = {};
            var i;
            for(i=0; i<a.length; i++) {
                var key = Object.keys(a[i])[0];
                var y = a[i][key];
                // arguments that are part of a list
                if (key=='data' && Array.isArray(y)) {
                    y = y.map(convert);
                }
                else if (key=='legend' && Array.isArray(y)) {
		    // nested arguments
                    y = array2object(y);
                }
                else y = convert(y);
            acc[key] =  y;
            }
            return acc;
        }
        if (obj == null)
	        return null;
        else if (typeof(obj) != 'object') // atom
            return obj;
        else
            return Object.keys(obj).reduce(function(result, key) {
                var y = obj[key];
                // arguments that are part of a record
                if (key=='datasets' && Array.isArray(y))
                    y = y.map(array2object); // array of arrays -> array of objects
                else if (key=='options' && Array.isArray(y))
                    y = array2object(y); // array -> object
                else y = convert(y);
                result[key] = y;
                return result;
            }, {});
    }
    return convert(obj);
};

function chartjsChart(id, obj) {

    var ctx = document.getElementById(id).getContext('2d');

    var chart = new Chart(ctx, chartjsArgs(objectifyUr(obj, urNewKeyMap)));
    
    return chart;
}

function chartjsChartDebug(id, obj) {

    // alert(JSON.stringify(obj));
    alert(JSON.stringify(objectifyUr(obj,urNewKeyMap)));
    alert(JSON.stringify(chartjsArgs(objectifyUr(obj,urNewKeyMap))));
    
    return chartjsChart(id,obj);
}
