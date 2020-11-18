import 'package:flutter/material.dart';

class customList extends StatelessWidget{

  IconData icon;
  String text;
  Function onTap;

  customList(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return InkWell(
        splashColor: Colors.lightBlueAccent,
        onTap: onTap,
        child: Container(
          height: data.size.height*0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Text(text, style: TextStyle(fontSize: 18.0),),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}