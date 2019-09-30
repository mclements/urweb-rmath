type chartjschart

val chartjsChart : id -> list float -> list float -> transaction chartjschart
val makeChartjs : id -> transaction chartjschart
val idAsString : id -> string
val stringAsId : string -> id

val canvas : bodyTag ([Width = int, Height = int] ++ boxAttrs)
