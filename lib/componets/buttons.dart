import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final ButtonStyle? buttonstyle;
  final TextStyle? style;

  CustomElevatedButton(
      {super.key,
      required this.onPressed,
      this.buttonText = '',
      this.style,
      this.buttonstyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonstyle,
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: style,
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final TextStyle? style;
  final TextAlign;

  CustomTextButton(
      {super.key, required this.onPressed, this.buttonText = '', this.style,  this.TextAlign});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: style,
       textAlign: TextAlign,
      ),
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final TextStyle? style;
  final backgroundColor;
  final child;
  final shape;
  final elevation;

  CustomFloatingButton({required this.onPressed, this.buttonText = '', this.style, this.backgroundColor, this.child, this.shape, this.elevation});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor:backgroundColor,
      child:child,
      shape:shape,
      elevation:elevation,
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  CustomIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
