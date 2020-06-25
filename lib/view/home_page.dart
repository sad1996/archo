import 'package:archo/util/essentials.dart';
import 'package:archo/widget/component/ui_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:build_context/build_context.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "HomePage";

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlutterLogo(style: FlutterLogoStyle.markOnly, colors: Colors.orange,),
        ),
        title: Text(
          "Archo",
        ),
        actions: [
          themeSwitcher,
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
