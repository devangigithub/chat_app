import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wharapp/controller/login_controller.dart';
import 'package:wharapp/view/login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register',style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.green,
      leading: IconButton(onPressed: (){
       Get.to(LoginPage);
      }, icon: Icon(Icons.arrow_back,color: Colors.white,)),),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Name',border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton( style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
              onPressed: () => authController.registerWithEmail(
                emailController.text,
                passwordController.text,
                nameController.text,

              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}