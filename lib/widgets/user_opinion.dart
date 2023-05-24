
class Opiniones{
  String id;
  final int opinion;
  final double ropa;
  final int actividad;

  Opiniones({
    this.id = '',
   required this.opinion,
   required this.ropa,
   required this.actividad,
});

  Map<String, dynamic> toJson() => {
    'id' :id,
    'opinion' : opinion,
    'ropa' : ropa,
    'actividad' : actividad,
  };

}