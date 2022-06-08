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
        backgroundColor: Color.fromARGB(0, 254, 254, 254),
        child: Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Get.back()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: AuthBackground(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox( height: 10 ),
                    Text( 'Registrarse', style: Theme.of(context).textTheme.headline4 ),
                    SizedBox( height: 30 ),
                    _RegisterForm()
                    // ChangeNotifierProvider(
                    //   create: ( _ ) => {},
                    //   // create: ( _ ) => LoginFormProvider(),
                    //   child: _RegisterForm()
                    // ),
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

  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   registerController.init(context);
    // });
  }

  bool _obscureText = false;
  bool _obscureText2 = false;
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
    
    // final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        // key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            _textName(),
            _textLastName(),
            _textPhone(),
            _textEmail(),
            _textPassword(),
            _textConfirmPassword(),
            SizedBox( height: 25, ),
            _registerButton(),
            
          ]
        )
      )
    );
  }

  Widget _backButton() {
    
    return SafeArea(
      child: Container(
        child: IconButton(
          icon: Icon( Icons.arrow_back_ios_rounded, color: Colors.white ),
          onPressed: () => Get.back(),
        )
      )

    );

  }

  Widget _textName() {

    return TextFormField(
      cursorRadius: Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.name,
      decoration: InputDecorations.authInputDecoration(
        hintText: "Will",
        labelText: "Nombre",
        prefixIcon: Icons.perm_identity_sharp
      ),
      // onChanged: ( value ) => loginForm.name = value,
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
      cursorRadius: Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.name,
      decoration: InputDecorations.authInputDecoration(
        hintText: "Smith",
        labelText: "Apellido",
        prefixIcon: Icons.co_present_outlined
      ),
      // onChanged: ( value ) => loginForm.name = value,
      validator: ( value ){
        String pattern = r"\b([a-zA-ZÀ-ÿ][-,a-z. ']+[ ]*)+";
        RegExp nameregExp  = RegExp(pattern);
        return nameregExp.hasMatch( value ?? '' ) 
          ? null 
          : 'Nombre no válido';
      }
    );

  }

  Widget _textEmail() {

    return TextFormField(
      // controller: registerController.emailController,
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

  Widget _textPhone() {

    return TextFormField(
      // controller: registerController.phoneController,
      cursorRadius: Radius.circular(8.0),
      autocorrect: false,
      keyboardType: TextInputType.phone,
      decoration: InputDecorations.authInputDecoration(
        hintText: "5555555555",
        labelText: "Número de teléfono",
        prefixIcon: Icons.call
      ),
      // onChanged: ( value ) => loginForm.phone = value,
      validator: ( value ){
        return ( value != null && value.length == 10 ) 
          ? null
          : 'Número no válido, deben ser 10 dígitos';
      }
    );

  }

  Widget _textPassword() {
    return TextFormField(
      // controller: registerController.passController,
      cursorRadius: Radius.circular(8.0),
      autocorrect: false,
      obscureText: !_obscureText,
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
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.indigo.shade300,
          ),
          onPressed: _toggle
        ),
      ),
      // onChanged: ( value ) => loginForm.password = value,
      validator: (value) {
        return (value != null && value.length >= 6)
          ? null
          : 'Contraseña no válida, deben ser 6 caracteres';
      }
    );
  }

  Widget _textConfirmPassword() {

    return TextFormField(
      // controller: registerController.confirmPassController,
      cursorRadius: Radius.circular(8.0),
      autocorrect: false,
      obscureText: !_obscureText2,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo.shade300
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo,
            width: 2
          )
        ),
        hintText: "**********",
        hintStyle: TextStyle( color: Colors.grey[400] ),
        labelText: "Confirmar contraseña",
        labelStyle: TextStyle( color: Colors.blueGrey ),
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
      // onChanged: ( value ) => loginForm.confirmPassword = value,
      // validator: ( value ){
      //   return ( value == loginForm.password ) 
      //     ? null
      //     : 'Las contraseñas no coinciden, intenta de nuevo';
      // }
    );

  }

  Widget _registerButton() {

    return MaterialButton(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10) ),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.indigo[300],
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15 ),
        // child: Text(
        //   loginForm.isLoading
        //     ? 'Espere...'
        //     : 'Ingresar',
        //   style: TextStyle( color: Colors.white ),
        // )
      ),
      // onPressed: registerController.login
        // }

      
    );

  }

}