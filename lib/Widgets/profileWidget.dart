
import 'package:flutter/material.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppConstants.dart';
import 'package:maxsports/Models/CommonResponse.dart';
import 'package:maxsports/Providers/LiveShowProvider.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {

String email;
ProfileWidget({this.email});

  Function onSavePressed , onCancelPressed;
  TextEditingController oldPinController = new TextEditingController();
  TextEditingController newPinController = new TextEditingController();
  TextEditingController confirmPinController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: AppColors.backGroundColor,
        child: ListView(
          children: [
            SizedBox(
              height: 58,
            ),
            Container(
              height: 107,
              width: 107,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Image.asset("assets/images/profile.png"),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Jhon Smith",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$email",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 29,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 21, horizontal: 16),
              color: AppColors.lightBackGroundColor,
              child: Text(
                "Change pin",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            _textformField("Old pin", oldPinController),
            SizedBox(
              height: 10,
            ),
            _textformField("New pin", newPinController),
            SizedBox(
              height: 10,
            ),
            _textformField("Confirm pin", confirmPinController),
            SizedBox(
              height: 44,
            ),
            _buttonRow(context)
          ],
        ),
      ),
    );
  }

// _drawerItems(){
//   return
// }

  _textformField(String text, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 17.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 4,

        decoration: InputDecoration(
          counterText: "",
          hintText: text,
          hintStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff606060)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffBAC2DA),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffBAC2DA),
            ),
          ),
          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffBAC2DA),
            ),
          ),
        ),
      ),
    );
  }
  _buttonRow(context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 17.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buttons(color: AppColors.buttonGreenColor,text: "SAVE",textColor: Colors.white,onPressed: (){
            if (oldPinController.text.trim().length == 0 ) {
AppConstants().showToast(msg: "Please enter the old pin");

            }else if (newPinController.text.trim().length == 0 ) {
              AppConstants().showToast(msg: "Please enter the new pin");

            } else if (confirmPinController.text.trim().length == 0 ) {
              AppConstants().showToast(msg: "Please enter the confirm pin");

            }else if (newPinController.text != confirmPinController.text) {
              AppConstants().showToast(msg: "Your new pin doesn't match with the confirm pin");

            }

            else {
              changePin(pin: newPinController.text,context: context);
            }
          }),
          _buttons(color: Colors.white,text: "CANCEL",textColor: Colors.black, onPressed: (){
            Navigator.pop(context);

          }),
        ],
      ),
    );
  }

  _buttons({Color color , String text , Color textColor , Function onPressed}){
    return MaterialButton(onPressed: onPressed,
      minWidth: 119,
      padding: EdgeInsets.symmetric(vertical: 10),
    child: Text("$text",style: TextStyle(fontSize: 16,color: textColor,fontWeight:FontWeight.w600 ),),
      color: color,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),

    );
  }

  changePin({
String pin ,context
}) async {
    Provider.of<LiveShowProvider>(context,listen: false).setContext(context);
    CommonResponse data =
    await Provider.of<LiveShowProvider>(context, listen: false)
        .changePin(pin: pin);
    AppConstants().showToast(msg: data.msg);
  }
}
