import 'package:flutter/material.dart';
import 'package:foodybite_app/pallete.dart';

class RoundedButton extends StatelessWidget {
  Function() click;
  RoundedButton({
    Key key,@required this.click,
    @required this.buttonName,
  }) : super(key: key);

  final String buttonName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kBlue,
      ),
      child: FlatButton(
        onPressed: click,
        child: Text(
          buttonName,
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
