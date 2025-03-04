import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  final _formkey = GlobalKey<FormState>();
  var _isLogin=true;
  var _enteredemail='';
  var _enteredpass='';
  File? _selectedimg;
  var _isauthenticating = false;
  var _enteredusername='';

  void _submit()async{
    final isvalid = _formkey.currentState!.validate();
    
    if (!isvalid || !_isLogin && _selectedimg == null) {
      return;
    }

    // if () {
    //   return;
    // }
      
      _formkey.currentState!.save();

  try{
    setState(() {
      _isauthenticating=true;
    });
    if (_isLogin) {
      // ignore: unused_local_variable
      final userCredentials = await _firebase.signInWithEmailAndPassword(
        email: _enteredemail,
        password: _enteredpass
        );
      // ignore: avoid_print
      // print(userCredentials);
    }else {
        final usercredentials = await _firebase.createUserWithEmailAndPassword(
        email: _enteredemail,
        password: _enteredpass
        );

        final storageref = FirebaseStorage.instance.ref().child('userimg').child('${usercredentials.user!.uid}.jpg');

      await storageref.putFile(_selectedimg!);
      final imgurl = await storageref.getDownloadURL();
      
      await FirebaseFirestore.instance.
        collection('users').
        doc(usercredentials.user!.uid).
        set({
            'username':_enteredusername,
            'email':_enteredemail,
            'img_url':imgurl,
        });
      // print(imgurl);

        // ignore: avoid_print
        // print(usercredentials);
      }
      }on FirebaseAuthException catch (error){
        if (error.code=='email-alredy-in-use') {
          //...
        }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        )
      );
      setState(() {
        _isauthenticating=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(!_isLogin) UserImagePicker(
                            onpickimg: (pickedimg){
                            _selectedimg = pickedimg;
                          },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value==null || value.trim().isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredemail=value!;
                            },
                          ),
                          if(!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Username'
                            ),
                            enableSuggestions: false,
                            validator: (value){
                              if (value == null || value.isEmpty || value.trim().length<4) {
                                return 'please enter a valid username,atleast 4 characters.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredusername=newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value==null || value.trim().length<6) {
                                return 'Password must be atleast 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredpass=value!;
                            },
                          ),
                          const SizedBox(height: 12,),
                        if(_isauthenticating)
                          const
                        CircularProgressIndicator(),
                        if(!_isauthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer
                            ),
                            child:  Text(_isLogin ? 'Login' : 'signup'),
                          ),
                        if(!_isauthenticating)
                          TextButton(
                            onPressed: (){
                              setState(() {
                                _isLogin= !_isLogin;
                              });
                            },
                            child:  Text( _isLogin ? 'Create an account' : 'I already have an account')
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}