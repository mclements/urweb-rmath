type canvasjschart

val canvasjsChart : id -> list float -> list float -> transaction canvasjschart
val makeCanvasjs : id -> transaction canvasjschart
val idAsString : id -> string
val stringAsId : string -> id
