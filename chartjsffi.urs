
type chartjschart
con data = list {X : float, Y : float}
datatype legend = Display of bool
		| Position of string
datatype options = Legend of list legend
                 | ShowLines of bool
datatype dataset = Data of data
		 | Fill of bool
		 | ShowLine of bool
		 | Label of string
		 | BorderColor of string
con fullconfig = {Data: {Datasets : list (list dataset)},
		  Typ : string,
		  Options : list options}

(* deprecated *)
val chartjsChartOld : id -> list {X:float, Y:float} -> transaction chartjschart

(* not used *)
val chartjsChartJson : id -> string -> transaction chartjschart

val chartjsChart : id -> fullconfig -> transaction chartjschart

val chartjsChartDebug : id -> fullconfig -> transaction chartjschart

val canvas : bodyTag ([Width = int, Height = int] ++ boxAttrs)
