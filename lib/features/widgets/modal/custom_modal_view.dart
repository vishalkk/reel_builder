import 'package:flutter/material.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';

class CustomModalView extends StatefulWidget {
  final String text;
  final String? subText;
  final Color? backgroundColor;
  final LinearGradient? backgroundGradient;
  final Color? textColor;
  final Color? subTextColor;
  final Widget? closeIcon;
  final Widget? content;

  const CustomModalView({
    Key? key,
    required this.text,
    this.subText,
    this.backgroundColor,
    this.backgroundGradient,
    this.textColor,
    this.subTextColor,
    this.closeIcon,
    this.content,
  }) : super(key: key);

  @override
  _CustomModalViewState createState() => _CustomModalViewState();
}

class _CustomModalViewState extends State<CustomModalView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: getProportionateScreenHeight(30),
        left: getProportionateScreenWidth(35),
        right: getProportionateScreenWidth(31.15),
        bottom: getProportionateScreenHeight(30),
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? CustomColors.white,
        gradient: widget.backgroundGradient,
      ),
      child: Wrap(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: getProportionateScreenWidth(273),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor ?? CustomColors.black,
                    fontSize: getProportionateScreenHeight(30),
                    fontWeight: FontWeight.w700,
                    // height: 35,
                    // letterSpacing: -1.08,
                  ),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(23.18)),
              Expanded(
                  child: widget.closeIcon ??
                      GestureDetector(
                        child: SizedBox(
                          width: getProportionateScreenWidth(20),
                          height: getProportionateScreenWidth(20),
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: widget.textColor ?? CustomColors.black,
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ))
            ]),
        Container(height: getProportionateScreenHeight(20)),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            bottom: getProportionateScreenWidth(32),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.subText!,
            style: TextStyle(
              color: widget.subTextColor ?? CustomColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        widget.content ?? Container(),
      ]),
    );
  }
}
