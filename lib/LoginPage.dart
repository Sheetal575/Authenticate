
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
   String _email;
   String _password;
   FormType _formType = FormType.login;


  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      // print("form is valid. Email:$_email,password:$_password");
      return true;
    }
    else{
      // print('form is invalid');
      return false;
    }
  }
  void validateAndSubmit() async{
    if(validateAndSave()){
        try {
          if(_formType == FormType.login){
              UserCredential user= await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
              print('Signed in : ${user.credential} ');
          }
          else{
            UserCredential user= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
            print('Signed in : ${user.credential}');
          }
            
        }
         catch (e) {
           print('Error:$e');
        }
    }
  }
  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
       _formType =FormType.register;
    });
  }

  void moveToLogin(){
     formKey.currentState.reset();
    setState(() {
       _formType =FormType.login;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
         title: Text('Authenticaton'),
      ),
      body: Container(
        padding: EdgeInsets.only(top:100.0,left:20.0,right:20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          )
        ),
      ),
    );
  }
  List<Widget> buildInputs(){
    return [
        TextFormField(
                decoration: InputDecoration(labelText:'Email'),
                validator: (value)=>value.isEmpty ? 'Email can\'t be empty':null,
                onSaved: (value)=>_email=value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText:'Password'),
                validator: (value)=>value.isEmpty ? 'Password can\'t be empty':null,
                 onSaved: (value)=>_password=value,
                obscureText: true,
              ),
    ];
  }
  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login){
       return [
              Container(
                padding: EdgeInsets.only(top:12.0),
                  child:RaisedButton(
                      color: Colors.cyan,
                      child: Text('Login',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                      onPressed:validateAndSubmit,
                  ),
              ),
              FlatButton(
                child: Text('create new account', style: TextStyle(fontSize: 17.0,color: Colors.grey),),
                onPressed: moveToRegister, 
              )
        ];
    }
    else{
      return [
         Container(
                padding: EdgeInsets.only(top:12.0),
                  child:RaisedButton(
                      color: Colors.cyan,
                      child: Text('Create an account',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                      onPressed:validateAndSubmit,
                  ),
              ),
              FlatButton(
                onPressed: moveToLogin, 
                child: Text('Have an account ? Login', style: TextStyle(fontSize: 17.0,color: Colors.grey),)
              ),
      ];
     
    }
    
  }
}
