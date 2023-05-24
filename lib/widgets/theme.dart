import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils.dart';


class ForgotPassword extends StatefulWidget{
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}
class _ForgotPasswordState extends State<ForgotPassword>{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: const Text('Recuperar Contraseña'),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_reset_outlined,
            size: 150.0,
            color: Colors.blueAccent,
          ),
          const Text(
            'Resetea tu contraseña',
            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10,),
          const Text(
            'Introduce tu correo electrónico y te enviaremos un enlace para resetear tu contraseña.',
            style: TextStyle(fontSize: 14,
              decoration: TextDecoration.none,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined), // <-- left icon
                hintText: "correo",
                border: InputBorder.none),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            email != null && !EmailValidator.validate(email) ?
            'Introduce un correo válido':
            null,
          ),
          const SizedBox(
            height: 20,
          ),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(
              Icons.email_outlined,
              size: 32,
            ),
            label: const Text(
              'Restablecer contraseña',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: verificarEmail,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );

  Future verificarEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Se envío un correo para restablecer su contraseña');
      Navigator.of(context).popUntil((route) => route.isFirst);

    } on FirebaseAuthException catch (e) {
      print (e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}

