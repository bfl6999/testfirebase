import 'package:flutter/material.dart';
import 'package:testfirebase/widgets/registro.dart';

import 'inicio_sesion.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin ? Inicio(onClickedSignUp: toggle) : Registro(onClickedSignIn: toggle);
 
  void toggle() => setState(() => isLogin = !isLogin);
}