import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart'; // Get dart
import 'package:testfirebase/main.dart';

import 'package:testfirebase/widgets/simple_ui_controller.dart';
import 'constants.dart';
import 'forgot_password.dart';
import '../Utils.dart';

import 'package:lottie/lottie.dart';


class Inicio extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Inicio({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  _Inicio createState() => _Inicio();
}

class _Inicio extends State<Inicio> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
  Widget _buildLargeScreen(Size size, SimpleUIController simpleUIController,
      ThemeData theme) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/wave.json',
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
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
        Container(
        height: size.height * 0.30, /// antes 0.25
          //padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logotipoUAL02.png',
              height: size.height * 0.25,
              width: size.width *0.7,
            ),
        ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 0.0),
              child: Text(
                'Inicio de Sesión',
                style: kLoginTitleStyle(size),
              ),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),


            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Bienvenido/a',
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
                      controller: emailController,
                      style: kTextFormFieldStyle(),
                      //cursorColor: Colors.white,
                      textInputAction: TextInputAction.next,
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
                          () =>
                          TextFormField(
                            style: kTextFormFieldStyle(),
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: simpleUIController.isObscure.value,
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction,
                            validator: (value) =>
                            value != null && value.length < 6
                                ? 'Contraseña mínima de 6 caracteres'
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                  Icons.lock_outline_rounded),
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)),
                              ),
                            ),
                          ),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// SignUp Button
                    signUpButton(theme),

                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const Text(
                      'Todos los términos de servicio y nuestra política de privacidad se guian por la Universidad de Almeria',
                      //style: kLoginTermsAndPrivacyStyle(size),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
                        text: '¿No tienes una cuenta?  ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'Registrate',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    GestureDetector(
                      child: Text(
                        '¿Te has olvidado la contraseña?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                          fontSize: 20,

                        ),
                      ),
                      onTap: () =>
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword())),
                    ),

                    SizedBox(
                      height: size.height * 0.03,
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
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: signIn,
        child: const Text('Iniciar Sesión'),
      ),

    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
