import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:testfirebase/widgets/simple_ui_controller.dart';
import 'package:testfirebase/widgets/user_opinion.dart';

import 'constants.dart';

class FormularioGoogle extends StatefulWidget {
  const FormularioGoogle({Key? key}) : super(key: key);

  @override
  _FormularioGoogleState createState() => _FormularioGoogleState();
}

enum Ejemplo {
  one(1),
  two(2),
  three(3),
  zero(0),
  lessone(-1),
  lesstwo(-2),
  lessthree(-3);

  const Ejemplo(this.value);
  final int value;
}

late int varAux = 0;

enum Ropa {
  corta,
  larga,
  abrigada;
}

enum Actividad {
  sedentaria,
  ligera,
  media;
}

/// Dejamos las variables que mas en la época resultarían
Actividad? _actividad = Actividad.ligera;
Ropa? _ropa = Ropa.corta;
Ejemplo? _ejemplo = Ejemplo.zero;

class _FormularioGoogleState extends State<FormularioGoogle> {
  final user = FirebaseAuth.instance.currentUser!;
  late String nombreUser;
  late String horaRegistro;

  ///@override
  ////void dipose(){
  ///super.dispose();
  /// }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  int convertToIntActivity(String aux) {
    return (aux == "Actividad.sedentaria"
        ? 65
        : aux == "Actividad.ligera"
            ? 85
            : aux == "Actividad.media"
                ? 105
                : 85);
  }

  double convertToClothe(String aux) {
    return (aux == "Ropa.corta"
        ? 0.36
        : aux == "Ropa.larga"
            ? 0.61
            : aux == "Ropa.abrigada"
                ? 1.30
                : 0.36);
  }

  //hasta aqui de momento
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario Confort Térmico'),
        automaticallyImplyLeading: false,
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
              fit: BoxFit.fill,
            ),
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
    return ListView(
      /// child: Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.center,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      children: [
        Visibility(
            visible: false,
            child: Text(
              nombreUser = user.email!,
              semanticsLabel: nombreUser,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),

        ///Padding(
        ///padding: const EdgeInsets.only(left: 0.0, right: 5.0),
        ///child: Column(children: [Padding(padding: (const EdgeInsets.only(left: 0.0, right: 0.0),child: Form()

        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              'Cuestionario sobre el confort térmico',
              style: kLoginTitleStyle(size),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text(
          'Preguntas breves para conocer el grado de satisfacción de las personas '
          'con la sensación térmica. Seleccione las respuestas mas de acorde a su situación.',
          style: kFormQuestions(size),
        ),

        SizedBox(
          height: size.height * 0.03,
        ),

        Container(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(children: <Widget>[
            /// Aqui probar a poner un Form y la misma key para los campos --> SIgnOutEvent
            ///39 - 22 = 17

            Text(
              '1. ¿Se encuentra satisfecho con el ambiente térmico?',
              style: kFormQuestions(size),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment(-1.1, 0),
                // Cambiar a todos los Textos por igual
                child: Text('Siento mucho calor     '),
              ),
              contentPadding: const EdgeInsets.all(0),

              ///minLeadingWidth : 10,
              leading: Radio<Ejemplo>(
                value: Ejemplo.three,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 3;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment:
                    Alignment(-1.1, 0), // Cambiar a todos los Textos por igual
                child: Text('Siento calor           '),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Ejemplo>(
                value: Ejemplo.two,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 2;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Align(
                alignment: Alignment(-1.1,
                    0), // Cambiar a todos los Textos por igual 17 + 6 = 22
                child: Text('Siento un poco de calor'),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Ejemplo>(
                value: Ejemplo.one,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 1;
                    }
                  });
                },
              ),
            ),

            ListTile(
              title: const Align(
                alignment:
                    Alignment(-1.1, 0), // Cambiar a todos los Textos por igual
                child: Text('Conforme               '),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Ejemplo>(
                value: Ejemplo.zero,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = 0;
                    }
                  });
                },
              ),
            ),

            ListTile(
              title: const Align(
                alignment:
                    Alignment(-1.1, 0), // Cambiar a todos los Textos por igual
                child: Text('Siento un poco de frío '),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Ejemplo>(
                value: Ejemplo.lessone,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = -1;
                    }
                  });
                },
              ),
            ),

            ListTile(
              title: const Align(
                alignment:
                    Alignment(-1.1, 0), // Cambiar a todos los Textos por igual
                child: Text('Siento frío            '),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Ejemplo>(
                value: Ejemplo.lesstwo,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = -2;
                    }
                  });
                },
              ),
            ),

            ListTile(
              title: const Align(
                alignment:
                    Alignment(-1.1, 0), // Cambiar a todos los Textos por igual
                child: Text('Siento mucho frío      '),
              ),
              contentPadding: const EdgeInsets.all(0),
              leading: Radio<Ejemplo>(
                value: Ejemplo.lessthree,
                groupValue: _ejemplo,
                onChanged: (Ejemplo? value) {
                  setState(() {
                    _ejemplo = value;
                    if (_ejemplo != null) {
                      varAux = -3;
                    }
                  });
                },
              ),
            ),
          ]),
        ),

        SizedBox(
          height: size.height * 0.05,
        ),

        Container(
          //height: MediaQuery.of(context).size.height*0.50,
          height: 550.0,
          //alignment: Alignment.topLeft,
          //width: MediaQuery.of(context).size.width*0.50,
          width: 300.0,
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),

          /// bottom 10.0
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '2. ¿Qué tipo de ropa diría lleva puesta ahora?      ',

                  ///52
                  style: kFormQuestions(size),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/ropaLigeraMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment(-55,
                                    0), // Cambiar a todos los Textos por igual
                                child: Text('Ropa ligera corta'),

                                ///11
                              ),

                              ///contentPadding: const EdgeInsets.all(0),
                              leading: Radio<Ropa>(
                                value: Ropa.corta,
                                groupValue: _ropa,
                                onChanged: (Ropa? value) {
                                  setState(() {
                                    _ropa = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/ropaLargaMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment(-55,
                                    0), // Cambiar a todos los Textos por igual
                                ///child: Text('Ropa    '), ///17 comoda
                                child: Text('Ropa manga larga'),
                              ),

                              ///contentPadding: const EdgeInsets.all(0),
                              leading: Radio<Ropa>(
                                value: Ropa.larga,
                                groupValue: _ropa,
                                onChanged: (Ropa? value) {
                                  setState(() {
                                    _ropa = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  //flex: 33,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/genteConRopaAbrigadaMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment(-55,
                                    0), // Cambiar a todos los Textos por igual
                                child: Text('Ropa abrigada'),

                                ///13 - -55
                              ),

                              ///contentPadding: const EdgeInsets.all(0),
                              leading: Radio<Ropa>(
                                value: Ropa.abrigada,
                                groupValue: _ropa,
                                onChanged: (Ropa? value) {
                                  setState(() {
                                    _ropa = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Visibility(
                                visible: false,
                                child: Expanded(
                                  child: Image.network(
                                    'https://i.pinimg.com/550x/d9/05/63/d90563d4c01efc682f74db9c815ff831.jpg',
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        /*const Text('3. ¿Cuál es la actividad mas parecida que realiza?', ///textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),), */

        SizedBox(
          height: size.height * 0.05,
        ),

        /*const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  '3. ¿Cuál es la actividad mas parecida que realiza?',
                  style: TextStyle(fontSize: 16),
                ),
              ),*/

        Container(
          //height: MediaQuery.of(context).size.height*0.50,
          height: 550.0,
          //alignment: Alignment.topLeft,
          //width: MediaQuery.of(context).size.width*0.50,
          width: 300.0,
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '3. ¿Cuál es la actividad mas parecida que realiza?    ',
                  style: kFormQuestions(size),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Expanded(
                  //flex: 33,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/actividadSedentariaMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment(-55,
                                    0), // Cambiar a todos los Textos por igual
                                child: Text('Actividad sedentaria'),
                              ),
                              leading: Radio<Actividad>(
                                value: Actividad.sedentaria,
                                groupValue: _actividad,
                                onChanged: (Actividad? value) {
                                  setState(() {
                                    _actividad = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/actividadLigeraMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment(-55,
                                    0), // Cambiar a todos los Textos por igual
                                child: Text('Actividad ligera'),
                              ),
                              leading: Radio<Actividad>(
                                value: Actividad.ligera,
                                groupValue: _actividad,
                                onChanged: (Actividad? value) {
                                  setState(() {
                                    _actividad = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  //flex: 33,
                  child: Row(
                    children: [ 
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/actividadMediaMod.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            ListTile(
                              title: const Align(
                                alignment: Alignment(-55,
                                    0), // Cambiar a todos los Textos por igual
                                child: Text('Actividad media'),
                              ),
                              leading: Radio<Actividad>(
                                value: Actividad.media,
                                groupValue: _actividad,
                                onChanged: (Actividad? value) {
                                  setState(() {
                                    _actividad = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Visibility(
                                visible: false,
                                child: Expanded(
                                  child: Image.network(
                                    'https://i.pinimg.com/550x/d9/05/63/d90563d4c01efc682f74db9c815ff831.jpg',
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),

        SizedBox(
          height: size.height * 0.03,
        ),
        //botonmover(context),
        sendData(theme),
        SizedBox(
          height: size.height * 0.02,
        ),

        ///closeSesion(theme),
        closeSesion(theme, onCloseSession: () {
          Navigator.pop(context);
        }),
        SizedBox(
          height: size.height * 0.03,
        )
      ],
    );
  }

  Widget closeSesion(ThemeData theme, {VoidCallback? onCloseSession}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            //deepPurpleAccent
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          icon: const Icon(Icons.arrow_back_ios, size: 32),
          //Icons.logout_outlined,
          label: const Text(
            'Cerrar Sesión',
            style: TextStyle(fontSize: 24),
          ),

          /// onPressed: () => FirebaseAuth.instance.signOut(),
          ///onPressed: () async {
          ///FirebaseAuth.instance.signOut();
          onPressed: () {
            FirebaseAuth.instance.signOut();
            if (onCloseSession != null) {
              onCloseSession();
            }
          }),
    );
  }

  Widget sendData(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
          icon: const Icon(Icons.arrow_forward_ios, size: 32),
          label: const Text(
            'Enviar respuestas',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () async {
            //Guardamos la hora en la que registramos los datos: HH hora formato..min..seg
            horaRegistro =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
            final user = Opiniones(
              //opinion: int.parse(_ejemplo.value.toString()),
              opinion: varAux,

              ///opinion: _ejemplo!.value, --- Quizas probar mas adelante -> Nos ahorramos ifs
              ropa: convertToClothe(_ropa.toString()),
              actividad: convertToIntActivity(_actividad.toString()),
            );

            ///bool success = await createUser(user); /// bool await...

            showDialog(
              context: context,
              builder: (context) {
                // Create a FutureBuilder to handle the createUser() operation
                return FutureBuilder<bool>(
                  future: createUser(user),
                  builder: (context, snapshot) {
                    // Check the current state of the future
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the future to complete, show a progress indicator
                      return const AlertDialog(
                        title: Text('Enviando respuesta'),
                        content: Center(
                          heightFactor: 2.0,
                          ///widthFactor: 5.0,
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.blueGrey,
                        ),
                      ),);
                    } else if (snapshot.hasError) {
                      // If an error occurred, show an error dialog
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Hubo un error al enviar la opinión'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    } else {
                      // The future completed successfully
                      final success = snapshot.data;
                      return AlertDialog(
                        title: Text(success! ? '¡Enviado!' : 'Error'),
                        content: Text(success
                            ? 'La opinión se envió correctamente'
                            : 'Hubo un error al enviar la opinión'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            );

            /// Pop up ---- Respuesta enviada ---
          }),
    );
  }

  /*
  Comprobamos si el usuario no esta creado ya en la coleccion Usuarios. Si ya está registrado, añadimos el registro a un nuevo Documento.
  Si no está registrado creamos una nueva Colección con el nombre del correo
   */
  Future<bool> createUser(Opiniones user) async {
    /// Cambios con el bool
    // Referenciamos el documento del usuario
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(nombreUser)
        .collection(nombreUser)
        .doc(horaRegistro);
    // Referencia a la colección del usuario del que iniciamos sesion
    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(nombreUser)
        .collection(nombreUser);
    try {
      // Try catch
      QuerySnapshot colec =
          await ref.get(); // Capturamos la colección en el objeto colec
      if (colec.docs.isEmpty) {
        //if(colec.docs.length == 0){
        user.id = docUser.id;
        final json = user.toJson();
        // Creamos el documento y lo escribimos en la base de datos
        await docUser.set(json);
      } else {
        //añadir en misma coleccion con otro documento
        user.id = ref.id;
        final json = user.toJson();
        // Creamos el documento y lo escribimos en la base de datos
        await docUser.update(json);
      }
      return true;

      /// bool
    } catch (e) {
      return false;

      ///bool
      ///const Text('Algo salio mal');
    }
  }
}
