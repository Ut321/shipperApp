import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/responsive.dart';
import 'package:sizer/sizer.dart';
import '../controller/shipperIdController.dart';
import '../functions/add_user_functions.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String phoneOrMail;
  bool isError = false;
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  String selectedRole = "employee";
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: FractionallySizedBox(
        widthFactor: Responsive.isMobile(context) ? 0.9 : 0.5,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: Responsive.isMobile(context) ?  screenHeight * 0.4  : screenHeight * 0.45,
                maxWidth:  screenWidth * 0.7 ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Invite Member",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: darkBlueTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: Responsive.isMobile(context) ? 14.sp : 4.75.sp),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 817,
                            child: Padding(
                              padding: Responsive.isMobile(context) ? 
                              const EdgeInsets.only(left: 20.0, top: 30, bottom: 30) 
                              : const EdgeInsets.only(left: 54.0, top: 30, bottom: 30),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.start,
                                  floatingLabelStyle: GoogleFonts.montserrat(
                                      color: darkBlueTextColor,
                                      fontWeight: FontWeight.w500),
                                  hintText: 'Enter Email Address ',
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                  ),
                                ),
                                validator: (value) {
                                  setState(() {
                                    isError = false;
                                  });
                                  return null;
                                },
                                onSaved: (value) {
                                  phoneOrMail = value.toString();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 183,
                              child: Container(
                                margin: Responsive.isMobile(context) 
                                ? const EdgeInsets.only(left: 15, right: 15.0)
                                : const EdgeInsets.only(left: 15, right: 50.0),
                                height: 50,
                                width: 22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: darkBlueTextColor),
                                child: Padding(
                                  padding: Responsive.isMobile(context) 
                                  ? EdgeInsets.symmetric(horizontal: screenWidth * 0.005) 
                                  : const EdgeInsets.all(12.0),
                                  child: const Icon(
                                      size: 25, Icons.add, color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 0.005.h :  1.9.h,
                      ),
                      Container(
                        height: 55,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: Responsive.isMobile(context) ? screenWidth * 0.20 : 265.0, vertical: Responsive.isMobile(context)? 3.0 : 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: const Color(0xFF000066),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                //Add the user
                                await AddUserFunctions().addUser(phoneOrMail,
                                    shipperIdController.companyName.value,
                                    context: context, role: selectedRole);
                                //Send email to the same user
                                AddUserFunctions().sendEmailToEmployee(phoneOrMail, shipperIdController.name.value);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Send Invite',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size_8)),
                                const Image(
                                    image: AssetImage(
                                        'assets/icons/telegramicon.png')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
