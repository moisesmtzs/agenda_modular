// ignore_for_file: use_key_in_widgetregisterControllerstructors, preferregisterControllerstregisterControllerstructors, avoid_unnecessaryregisterControllertainers, prefer_final_fields, unnecessary_new
import 'package:agenda_app/src/screens/register/register_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:agenda_app/src/widgets/auth_background.dart';
import 'package:agenda_app/src/widgets/card_container.dart';
import 'package:agenda_app/src/ui/input_decoration.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 254, 254, 254),
        child: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Get.back()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: AuthBackground(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox( height: 10 ),
                    Text( 'Crear cuenta', style: Theme.of(context).textTheme.headline4 ),
                    const SizedBox( height: 30 ),
                    _RegisterForm()
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          )
        )
      )
    );
  }
}

class _RegisterForm extends StatefulWidget {

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {

  RegisterController registerController = new RegisterController();

  bool _obscureText = false;
  bool _obscureText2 = false;
  bool isLoading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,

      child: Column(
        children: [
          _textName(),
          _textLastName(),
          _textPhone(),
          _textEmail(),
          _textPassword(),
          _textConfirmPassword(),
          const SizedBox( height: 25, ),
          _registerButton(),
          
        ]
      )
    );
  }

  Widget _textName() {

    return TextFormField(
      controller: registerController.nameController,
      cursorRadius: const Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.name,
      decoration: InputDecorations.authInputDecoration(
        hintText: "Will",
        labelText: "Nombre",
        prefixIcon: Icons.perm_identity_sharp
      ),
      validator: ( value ){
        String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
        RegExp nameregExp  = RegExp(pattern);
        return nameregExp.hasMatch( value ?? '' ) 
          ? null 
          : 'Nombre no válido';
      }
    );

  }

  Widget _textLastName() {

    return TextFormField(
      controller: registerController.lastNameController,
      cursorRadius: const Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.name,
      decoration: InputDecorations.authInputDecoration(
        hintText: "Smith",
        labelText: "Apellido",
        prefixIcon: Icons.co_present_outlined
      ),
      validator: ( value ){
        String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
        RegExp nameregExp  = RegExp(pattern);
        return nameregExp.hasMatch( value ?? '' ) 
          ? null 
          : 'Apellido no válido';
      }
    );

  }

  Widget _textEmail() {

    return TextFormField(
      controller: registerController.emailController,
      cursorRadius: const Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
        hintText: "ejemplo@ejemplo.com",
        labelText: "Correo Electrónico",
        prefixIcon: Icons.alternate_email_sharp
      ),
      validator: ( value ){
        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp  = RegExp(pattern);

        return regExp.hasMatch( value ?? '' )
          ? null
          : 'El correo no es válido';
      }
    );

  }

  Widget _textPhone() {

    return TextFormField(
      controller: registerController.phoneController,
      cursorRadius: const Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.phone,
      decoration: InputDecorations.authInputDecoration(
        hintText: "5555555555",
        labelText: "Número de teléfono",
        prefixIcon: Icons.call
      ),
      validator: ( value ){
        return ( value != null && value.length == 10 ) 
          ? null
          : 'Número no válido, deben ser 10 dígitos';
      }
    );

  }

  Widget _textPassword() {

    return TextFormField(
      controller: registerController.passwordController,
      cursorRadius: const Radius.circular(8.0),
      autocorrect: false,
      obscureText: !_obscureText,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo.shade300),
        ),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.indigo)),
        hintText: "**********",
        hintStyle: TextStyle(color: Colors.grey[400]),
        labelText: "Contraseña",
        labelStyle: const TextStyle(color: Colors.blueGrey),
        prefixIcon: Icon(Icons.lock_rounded, color: Colors.indigo.shade300),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.indigo.shade300,
          ),
          onPressed: _toggle
        ),
      ),
      validator: (value) {
        return (value != null && value.length >= 6)
          ? null
          : 'Contraseña no válida, deben ser 6 caracteres';
      }
    );
  }

  Widget _textConfirmPassword() {

    return TextFormField(
      controller: registerController.confirmPasswordController,
      cursorRadius: const Radius.circular(8.0),
      autocorrect: false,
      obscureText: !_obscureText2,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo.shade300
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo,
            width: 2
          )
        ),
        hintText: "**********",
        hintStyle: TextStyle( color: Colors.grey[400] ),
        labelText: "Confirmar contraseña",
        labelStyle: const TextStyle( color: Colors.blueGrey ),
        prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.indigo[300]),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText2
            ? Icons.visibility
            : Icons.visibility_off,
            color: Colors.indigo[300],
          ),
          onPressed: _toggle2
        ),
      ),
    );

  }

  Widget _registerButton() {

    return MaterialButton(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) ),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.indigo[300],
      onPressed: registerController.isEnable 
        ? () {
        registerController.register(context);
          setState(() {
            isLoading = true;
          });
          Future.delayed(const Duration( milliseconds: 3500 ), (){
            setState(() {
              isLoading = false;
            });
          });
        }
        : null,
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15 ),
        child: isLoading
          ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Espere...', style: TextStyle( color: Colors.white ),),
              const SizedBox(width: 10),
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color:  Colors.orange[300]))
            ],
          )
          : const Text('Registrarse', style: TextStyle( color: Colors.white ))
      ),

      
    );

  }

}