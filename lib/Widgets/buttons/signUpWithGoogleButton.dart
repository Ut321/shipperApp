import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/constants/radius.dart';
import '/constants/fontSize.dart';
import '/constants/borderWidth.dart';
import '/constants/elevation.dart';

class SignUpWithGoogleButton extends StatelessWidget {
  var onPressed;

  SignUpWithGoogleButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.060,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius_1),
          border: Border.all(
            color: black,
            width: borderWidth_10,
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: elevation_0,
              //backgroundColor: Colors.black.withOpacity(0.01),
              backgroundColor: Color.fromARGB(255, 26, 26, 26)),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: screenHeight * 0.063,
                  width: space_5,
                  child: const Image(
                    image: AssetImage("assets/icons/google_icon.png"),
                  )),
              SizedBox(
                width: space_7,
              ),
              Text(
                "Sign in Google",
                style: GoogleFonts.montserrat(
                    fontSize: screenHeight * 0.019,
                    fontWeight: FontWeight.w600,
                    color: white),
              ),
            ],
          ),
        ));
  }
}
