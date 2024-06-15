import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import '../../../componets/buttons.dart';
import 'api_call/login_api.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passworController = TextEditingController();
  late String phoneNo;
  late String password;

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    passworController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passworController.dispose();
    super.dispose();
  }

  void _loginPressed() async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: Material(
            color: Colors.transparent,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    try {
      await LoginApi.LogIn(context, ref, phoneNo, password);
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCard(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 9,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo(size.height / 8, size.height / 8),
          // SizedBox(height: size.height * 0.03),
          richText(24),
          SizedBox(height: size.height * 0.05),
          emailTextField(size),
          SizedBox(height: size.height * 0.02),
          passwordTextField(size),
          SizedBox(height: size.height * 0.01),
          buildForgetSection(),
          SizedBox(height: size.height * 0.02),
          signInButton(size),
        ],
      ),
    );
  }


  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/Image/logo.png',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: blue,
          letterSpacing: 2.0,
        ),
        children: const [
          TextSpan(
            text: 'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: phoneNumberController,
          style: const TextStyle(
            fontSize: 18.0,
            color: Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.number,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Phone Number',
            hintStyle: TextStyle(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: blue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: blue,
              ),
            ),
            prefixIcon: Icon(
              Icons.person_2_outlined,
              color: blue,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: passworController,
          style: const TextStyle(
            fontSize: 16.0,
            color: Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          obscureText: obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'password',
            hintStyle: TextStyle(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: blue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: blue,
              ),
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: blue,
              size: 16,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              child: Icon(
                obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: blue,
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget signInButton(Size size) {
    return CustomElevatedButton(
      onPressed: (){
        phoneNo = phoneNumberController.text ?? '';
        password = passworController.text ?? '';
        isLoading ? null : _loginPressed();

      },
      buttonText: 'Login',
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
      buttonstyle: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: blue,
        minimumSize: Size(size.width * 0.7, size.height / 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        shadowColor: const Color(0xFF4C2E84).withOpacity(0.2),
        elevation: 6,
      ),
    );
  }




  Widget buildForgetSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          const Spacer(),
          CustomTextButton(
            onPressed: () {
              GoRouter.of(context).push('/forrgetpassword');
            },
            buttonText: 'Forgot password',
            style: TextStyle(
              fontSize: 13.0,
              color: blue,
              fontWeight: FontWeight.w500,
            ),
            TextAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
