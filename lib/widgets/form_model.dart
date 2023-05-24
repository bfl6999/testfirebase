
class FormModel {
  String name;

  FormModel(this.name);

  factory FormModel.fromJson(dynamic json) {
    return FormModel("${json['name']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    'name': name,
  };
}