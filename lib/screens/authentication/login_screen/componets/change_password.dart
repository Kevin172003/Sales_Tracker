import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../componets/buttons.dart';
import '../../../../constant/constant.dart';
import '../api_call/changepass_api.dart';
import 'forget_password_screen.dart';


class ChangePassScreen extends StatefulWidget {
   ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

TextEditingController oldPassword = TextEditingController();
TextEditingController newPassword = TextEditingController();

class _ChangePassScreenState extends State<ChangePassScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Change Password",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: blue,

      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 150,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: const BorderRadiusDirectional.only(
                        bottomEnd: Radius.elliptical(500, 190),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                              color: white,
                              fontSize: 30,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 25, right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: oldPassword,
                          decoration: InputDecoration(
                              hintText: 'Old Password',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: newPassword,
                          decoration: InputDecoration(
                              hintText: 'New Password',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomTextButton(
                              onPressed: () {
                                Get.to(() => const ForgetPassScreen());
                              },
                              buttonText: "Forgot Password?",
                              style: TextStyle(color: blue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        MaterialButton(
                          onPressed: () {

                            changePassword(context);

                          },
                          height: 50,
                          color: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              "Save Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )],
              ),
            ]),

      ),

    );
  }
}
