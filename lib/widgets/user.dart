
class Datos {
  String id;
  final String name;
  final int age;
  final String ubicacion;
  final String sexo;
  final String fechaRegistro;

  Datos({
    this.id = '',
    required this.name,
    required this.age,
    required this.ubicacion,
    required this.sexo,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'age' : age,
    'ubicacion' : ubicacion,
    'sexo' : sexo,
    'fechaRegistro' : fechaRegistro,
  };
}