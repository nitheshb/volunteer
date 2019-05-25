import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app_1/models/state.dart';
import 'package:razorpay_plugin/razorpay_plugin.dart';
import 'package:test_app_1/util/state_widget.dart';


class RazorPayHome extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<RazorPayHome> {
   StateModel appState;
   final myAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
     appState = StateWidget.of(context).state;
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0XFF00b1e1),
          body: new Container(
            margin: const EdgeInsets.symmetric(
              vertical: 100.0,
              horizontal: 24.0,
            ),
            child: new Stack(
              children: <Widget>[
                new Container(
                  child: new Container(
                    constraints: new BoxConstraints.expand(),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          height: 80.0,
                          color: Color(0xFFE2E2E2),
                        ),
                        new Container(height: 16.0),
                        new TextField(
                          decoration: InputDecoration(
    hintText: "Demo Text",
    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.red)
  ),
                          controller: myAmount,
                          // style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
                          keyboardType: TextInputType.number,
                        ),
                        new Container(height: 8.0),
                        new Container(height: 8.0),
                        new Text(
                          "This is a real transcation",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        new Container(height: 16.0),
                        new RaisedButton(
                          onPressed: () {
                            startPayment();
                          },
                          child: new Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          splashColor: Colors.blue,
                        )
                      ],
                    ),
                  ),
                  height: 280.0,
                  margin: new EdgeInsets.only(top: 72.0),
                  decoration: new BoxDecoration(
                    color: new Color(0xFFFFFFFF),
                    shape: BoxShape.rectangle,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(vertical: 16.0),
                  alignment: FractionalOffset.topCenter,
                  child: Column(
                    children: <Widget>[
                      new Image.network(
                        "https://www.73lines.com/web/image/12427",
                        width: 92.0,
                        height: 92.0,
                      ),
                      new Container(height: 12.0),
                      new Text("Order #RZP42"),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }


  SaveSuccess2wallet(String transId, String amount) async {
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    final firstName = appState?.user?.firstName ?? '';
    final lastName = appState?.user?.lastName ?? '';
    
    if(transId == null || email == null){

      print ("----> found empty values");

    }else{

    Object TransactionDetails = { "amount": amount, "email": email, "transactionId":transId};

        try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
              .collection("wallet")
              .document()
              .setData(TransactionDetails);
        },
      );
    } catch (e) {
      print(e.toString());
    }
    }
  }

Future validator(Map paymentResp, String amount) async {
    print("Inside Validator response $paymentResp");
     print("data checker ${paymentResp['code'] == "1"}");

    if(paymentResp['code'] == "1"){
      //  on payment success 1) update transaction to userDetails table
      //  payments
        String code = paymentResp['code'];
        String message = paymentResp['message'];
        SaveSuccess2wallet( message, amount);
      

      print("payment success");
    } else if(paymentResp['code'] == "0"){
      print("payment failed");
    }

  }
  startPayment() async {
 
      print("extracted valuessssssssssss =====> ");
    if(myAmount == null){
      print("enter valid amount");
    } else{
      print("amount is $myAmount");
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Razorpay T-Shirt");
    options.putIfAbsent("image", () => "https://www.73lines.com/web/image/12427");
    options.putIfAbsent("description", () => "This is a real transactionr");
    options.putIfAbsent("amount", () => myAmount.text);
    options.putIfAbsent("email", () => "test@testing.com");
    options.putIfAbsent("contact", () => "9988776655");
    //Must be a valid HTML color.
    options.putIfAbsent("theme", () => "#FF0000");
    options.putIfAbsent("api_key", () => "rzp_test_QmZJOEOHabMdst");
    //Notes -- OPTIONAL
    Map<String, String> notes = new Map();
    notes.putIfAbsent('key', () => "value");
    notes.putIfAbsent('randomInfo', () => "haha");
    options.putIfAbsent("notes", () => notes);
    Map<dynamic,dynamic> paymentResponse = new Map();
    paymentResponse = await Razorpay.showPaymentForm(options);
    validator(paymentResponse, myAmount.text);
    print("response $paymentResponse");

  }

  


}
}