
type chartjschart
type fullconfig = {Data: {Datasets : list {Data : list {X:float, Y:float},
					   Fill : option bool,
					   ShowLine : option bool,
					   BorderColor : option string}},
		   Options : {Legend : option bool}}

val chartjsChart : id -> list (float*float) -> transaction chartjschart

val chartjsChartJson : id -> string -> transaction chartjschart

val chartjsChartStruct : id -> fullconfig -> transaction chartjschart

val canvas : bodyTag ([Width = int, Height = int] ++ boxAttrs)
