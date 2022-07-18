// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, prefer_final_fields, unnecessary_new
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agenda_app/src/widgets/auth_background.dart';
import 'package:agenda_app/src/widgets/card_container.dart';
import 'package:agenda_app/src/screens/login/login_controller.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';

class LoginPage extends StatelessWidget {

  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Iniciar Sesión',
                      style: Theme.of(context).textTheme.headline4
                    ),
                    SizedBox(height: 30),
                    _loginForm(context)
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text('¿No tienes una cuenta?'),
              TextButton(
                onPressed: () => loginController.goToRegisterPage(),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
                child: Text('Regístrate', style: TextStyle(fontSize: 14))
              ),
              SizedBox(height: 50),
            ],
          )
        )
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            _textEmail(),
            SizedBox(
              height: 32,
            ),
            _textPassword(),
            SizedBox(height: 32),
            _loginButton(context),
          ]
        )
      )
    );
  }

  Widget _textEmail() {
    return TextFormField(
      controller: loginController.emailController,
      cursorRadius: Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
        hintText: "ejemplo@ejemplo.com",
        labelText: "Correo Electrónico",
        prefixIcon: Icons.alternate_email_sharp
      ),
      // onChanged: ( value ) => loginForm.email = value,
      validator: ( value ){
        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp  = RegExp(pattern);

        return regExp.hasMatch( value ?? '' )
          ? null
          : 'El correo no es válido';
      }
    );
  }

  Widget _textPassword() {
    return Obx( () =>
      TextFormField(
        controller: loginController.passwordController,
        cursorRadius: Radius.circular(8.0),
        autocorrect: false,
        obscureText: loginController.obscureText.value,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo.shade300),
          ),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.indigo)),
          hintText: "**********",
          hintStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Contraseña",
          labelStyle: TextStyle(color: Colors.blueGrey),
          prefixIcon: Icon(Icons.lock_rounded, color: Colors.indigo.shade300),
          suffixIcon: IconButton(
            icon: Icon(
              loginController.obscureText.value ? Icons.visibility : Icons.visibility_off,
              color: Colors.indigo.shade300,
            ),
            onPressed: () => loginController.obscureText.value = !loginController.obscureText.value
          ),
        ),
        validator: (value) {
          return (value != null && value.length >= 6)
            ? null
            : 'Contraseña no válida, deben ser 6 caracteres';
        }
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Obx( () =>
      MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.indigo.shade300,
        onPressed: loginController.isEnable.value
          ? () {
          loginController.login();
            loginController.isLoading.value = true;
            Future.delayed(const Duration( milliseconds: 500 ), (){
              loginController.isLoading.value = false;
            });
          }
          : null,
        child: Container(
          padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15 ),
          child: loginController.isLoading.value
            ? FittedBox(child: const Text('Espere...', style: TextStyle( color: Colors.white ),))
            : FittedBox(child: const Text('Ingresar', style: TextStyle( color: Colors.white )))
        ),
        // }
      ),
    );
  }
}