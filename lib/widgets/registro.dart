import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:testfirebase/widgets/simple_ui_controller.dart';

import 'package:flutter/cupertino.dart';

//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../Utils.dart';
import '../main.dart';
import 'constants.dart';

class Registro extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const Registro({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  //final _formKey = GlobalKey<FormState>();

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
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
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
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
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            :
        Container(
          height: size.height * 0.30,
          //padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/logotipoUAL02.png',
            height: size.height * 0.25,
            width: size.width *0.7,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Crear cuenta',
            style: kLoginTitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Regístrate',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
              key: formKey,
              child: Column(children: [
                /// username
                TextFormField(
                  //inputFormatters: [loginMask],
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  //cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Introduce un correo electrónico válido'
                          : null,
                  //keyboardType: TextInputType.emailAddress,
                  //style: const TextStyle(fontSize: 20),

                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined), // <-- left icon
                      hintText: 'correo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: simpleUIController.isObscure.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Contraseña mínima de 6 caracteres'
                        : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Contraseña',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                Obx(
                  () => TextFormField(
                    //style: kTextFormFieldStyle(),
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: simpleUIController.isObscure.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                    passwordController.text != confirmPasswordController.text
                        ? 'Contraseñas no coinciden' : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Confirmar Contraseña',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                const Text(
                  'Crear una cuenta significa que está de acuerdo con nuestros términos de servicio y nuestra política de privacidad',
                  //style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),

                SizedBox(
                  height: size.height * 0.03,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                    text: '¿Ya tienes una cuenta?',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Iniciar Sesion',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        ),
      ],
      )
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
          //deepPurpleAccent
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: signUp,
        child: const Text('Registrarse'),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    //Navigator context no funciona
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

