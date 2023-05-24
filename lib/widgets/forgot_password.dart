import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:testfirebase/widgets/simple_ui_controller.dart';
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
  SimpleUIController simpleUIController = Get.put(SimpleUIController());


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            //key: formKey,
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildLargeScreen(size, simpleUIController, theme);
                } else {
                  return _buildSmallScreen(size, simpleUIController, theme);
                }
              },
            )),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.network(
              'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return ListView(
      /// child: Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.center,
      padding: const EdgeInsets.only(left: 20.0, right: 20),
        ///child: Column(
          children: [

            Container(
              height: size.height * 0.30,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: const Icon(
                //Icons.heart_broken_outlined,
                Icons.lock_reset_outlined,
                size: 150.0,
                color: Colors.blueAccent,
              ),
            ),

        const Text(
          'Recupera tu contraseña',
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
          SizedBox(
            height: size.height * 0.02,
          ),
        const Text(
          'Introduce tu correo electrónico y te enviaremos un enlace para resetear tu contraseña.',
          style: TextStyle(fontSize: 14,
            decoration: TextDecoration.none,
            color: Colors.black54,
          ),
        ),
          SizedBox(
            height: size.height * 0.02,
          ),

        TextFormField(
          controller: emailController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined), // <-- left icon
              hintText: 'correo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) =>
          email != null && !EmailValidator.validate(email) ?
          'Introduce un correo válido':
          null,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
            restartPassword(theme),
      ],///),
    );
  }

  Widget restartPassword(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        icon: const Icon(
          Icons.email_outlined,
          size: 32,
        ),
        onPressed: verificarEmail,
        label: const Text('Restablecer contraseña'),
      ),
    );
  }

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

