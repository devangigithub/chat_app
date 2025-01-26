//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../controller/login_controller.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   LoginController controller = Get.put(LoginController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Obx(() {
//               if (controller.isLoad.value) {
//                 return CupertinoActivityIndicator(
//                   color: Colors.black,
//                   radius: 20,
//                 );
//               } else {
//                 return SizedBox.shrink();
//               }
//             }),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: controller.email,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Email",
//               ),
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: controller.password,
//               obscureText: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Password",
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         controller.login();
//                       },
//                       child: Text("Login")),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         controller.register();
//                       },
//                       child: Text("Register")),
//                 ),
//               ],
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
//                   try {
//                     var act = await _googleSignIn.signIn();
//                     print("act ${act?.email}");
//                     print("act ${act?.id}");
//                   } catch (e) {
//                     print("google Error $e");
//                   }
//                 },
//                 child: Text("Google login"))
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wharapp/controller/login_controller.dart';
import 'package:wharapp/view/Register_Page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to ChatApp",style: TextStyle(
                fontSize: 35,
                color: Colors.green
              ),),
              SizedBox(height: 25,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),

              ),
              SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
               style: ButtonStyle( backgroundColor:  MaterialStateProperty.all(Colors.green),foregroundColor: WidgetStatePropertyAll(Colors.white)),

                onPressed: () {
                  authController.loginWithEmail(
                    emailController.text,
                    passwordController.text,
                  );
                  emailController.clear();
                  passwordController.clear();
                },
                child: Text('Login',),
              ),
              ElevatedButton(
                style: ButtonStyle( backgroundColor:  MaterialStateProperty.all(Colors.green),foregroundColor: WidgetStatePropertyAll(Colors.white)),

                onPressed: () => Get.to(RegisterPage()),
                child: Text('Register'),
              ),
              ElevatedButton(
                style: ButtonStyle( backgroundColor:  MaterialStateProperty.all(Colors.green),foregroundColor: WidgetStatePropertyAll(Colors.white)),

                onPressed: () => authController.loginWithGoogle(),
                child: Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
