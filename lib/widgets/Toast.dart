import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(BuildContext context,String msg) {

  FToast fToast = FToast();
  fToast.init(context);

  fToast.showToast(
    child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ), blurRadius: 10.0,
                  spreadRadius: 3.0 )
            ], border: Border.all(color:Colors.transparent ),
            color: Colors.white),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/—Pngtree—fast shopping bag logo designs_5301634.png",height: 30,width: 20),
              SizedBox(width: 15.0),
              Text(msg)] )
    ),
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}