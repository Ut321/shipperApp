import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/addTransporterWidget.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/BiddingDateTime.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/functions/shipperApis/TransporterListFromShipperApi.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';

import 'package:shipper_app/constants/spaces.dart';

class PublishMethodBidWebScreen extends StatefulWidget {
  final publishMethod;

  const PublishMethodBidWebScreen({super.key, required this.publishMethod});

  @override
  State<PublishMethodBidWebScreen> createState() =>
      _PublishMethodBidWebScreenState();
}

class _PublishMethodBidWebScreenState extends State<PublishMethodBidWebScreen> {
  var transporterList = [];
  var selectedTransporterList = [];
  bool setSelectedTransporterList = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inti");
    getTransporterListFromShipperApi();
  }

  getTransporterListFromShipperApi() async {
    await TransporterListFromShipperApi()
        .getTransporterListFromShipperApi()
        .then((value) {
      setState(() {
        transporterList = [...value];
        print("Oye -------> $transporterList");
        setSelectedTransporterList = true;
      });
    });
  }

  bool areListsEqual(var list1, var list2) {
    // check if both are lists
    if (!(list1 is List && list2 is List)
        // check if both have same length
        ||
        list1.length != list2.length) {
      return false;
    }

    // check if elements are equal
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (setSelectedTransporterList && transporterList.isNotEmpty) {
      selectedTransporterList.clear();
      for (int i = 0; i < providerData.loadTransporterList.length; i++) {
        for (int j = 0; j < transporterList.length; j++) {
          if (areListsEqual(
              providerData.loadTransporterList[i], transporterList[j])) {
            selectedTransporterList.add(transporterList[j]);
          }
        }
      }
      setSelectedTransporterList = false;
    }
    print("ok -------> $selectedTransporterList");
    return Scaffold(
      floatingActionButton: SizedBox(
        height: space_8,
        width: space_33,
        child: TextButton(
          style: ButtonStyle(
            mouseCursor: MaterialStatePropertyAll(
                (selectedTransporterList.isNotEmpty)
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: (Responsive.isMobile(context))
                  ? BorderRadius.circular(50)
                  : BorderRadius.all(Radius.zero),
            )),
            backgroundColor: MaterialStateProperty.all<Color>(
                (selectedTransporterList.isNotEmpty)
                    ? truckGreen
                    : disableButtonColor),
          ),
          onPressed: () {
            if (selectedTransporterList.isNotEmpty) {
              //selectedTransporterList.sort();
              providerData.updateLoadTransporterList(selectedTransporterList);
              providerData.updatePublishMethod(widget.publishMethod);
              ((kIsWeb)
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreenWeb(
                                index: screens.indexOf(postLoadScreenTwo),
                                selectedIndex: screens.indexOf(postLoadScreen),
                              )))
                  : Get.to(() => PostLoadScreenTwo()));
            }
          },
          child: Text(
            'Finish', // AppLocalizations.of(context)!.postLoad,
            style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: white,
                fontSize: size_8,
                fontFamily: 'Montserrat'),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (widget.publishMethod == 'Bid')
                ? Row(
                    children: [
                      BiddingDateTime(),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                            child: TextField(
                              style: TextStyle(
                                  color: kLiveasyColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_8),
                              textAlign: TextAlign.center,
                              cursorColor: kLiveasyColor,
                              cursorWidth: 1,
                              mouseCursor: SystemMouseCursors.click,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                          color: borderLightColor, width: 1.5)),
                                  hintText: 'Search Transporter',
                                  hintStyle: TextStyle(
                                      color: borderLightColor,
                                      fontFamily: 'Montserrat',
                                      fontSize: size_8),
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: borderLightColor,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                          color: truckGreen, width: 1.5))),
                            ),
                          )),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  elevation: 10,
                                  content:
                                      addTransporter(context, transporterList),
                                );
                              },
                            ).then(
                                (value) => getTransporterListFromShipperApi());
                          },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text('Add Transporter',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: size_7)),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(truckGreen),
                            mouseCursor: MaterialStatePropertyAll<MouseCursor>(
                                SystemMouseCursors.click),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10)),
                            shape:
                                MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero),
                                        side: BorderSide(
                                          color: truckGreen,
                                          width: 2,
                                        ))),
                            textStyle: MaterialStatePropertyAll<TextStyle>(
                                TextStyle(
                                    color: truckGreen,
                                    fontFamily: 'Montserrat',
                                    fontSize: size_6)),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.5,
              child: InputDecorator(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: truckGreen,
                        width: 2,
                      )),
                      contentPadding: EdgeInsets.all(20),
                      label: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 200,
                        child: Row(
                          children: [
                            Text(
                              'Transporter',
                              style: TextStyle(
                                  color: truckGreen,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_10),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    'assets/images/filter.png',
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  )),
                            )
                          ],
                        ),
                      )),
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20),
                    itemBuilder: (context, index) {
                      return (transporterList.isEmpty)
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: selectedTransporterList
                                        .contains(transporterList[index]),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selectedTransporterList
                                              .add(transporterList[index]);
                                        } else {
                                          selectedTransporterList
                                              .remove(transporterList[index]);
                                        }
                                      });
                                    },
                                    side:
                                        BorderSide(width: 2, color: truckGreen),
                                    mouseCursor: SystemMouseCursors.click,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2))),
                                    fillColor: MaterialStatePropertyAll<Color>(
                                        truckGreen),
                                  ),
                                  Text(
                                    transporterList[index][1],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: size_10),
                                  ),
                                ],
                              ),
                            );
                    },
                    itemCount: transporterList.length,
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<bool>('firstLoad', setSelectedTransporterList));
  }
}
