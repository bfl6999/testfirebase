import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'form_model.dart';


class FormController {
  // Google App Script Web URL
  String URL = "https://script.google.com/macros/s/AKfycbwdrklP474uI64P6m0BpUDEqg5S-vJiLFjXX7VFKnqW2bO__SxhF2WhmjkH8wnwZqrncA/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void submitForm(
      FormModel formModel, void Function(String) callback) async {
    try {
      await http.post(Uri.parse(URL), body: formModel.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(Uri.parse(url!)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }}
}