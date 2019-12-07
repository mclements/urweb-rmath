
type chartjschart
type fullconfig = {Data: {Datasets : list {Data : option (list {X:float, Y:float}),
					   Fill : option bool,
					   ShowLine : option bool,
					   BorderColor : option string,
					   Label : option string}},
		   Typ : string,
		   Options : {Legend : option bool,
			      ShowLines : option bool}}

val chartjsChart : id -> list {X:float, Y:float} -> transaction chartjschart

val chartjsChartJson : id -> string -> transaction chartjschart

val chartjsChartStruct : id -> fullconfig -> transaction chartjschart

val chartjsChartStructDebug : id -> fullconfig -> transaction chartjschart

val canvas : bodyTag ([Width = int, Height = int] ++ boxAttrs)
