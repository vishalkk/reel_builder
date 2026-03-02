import 'package:flutter/material.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:mis_mobile/features/widgets/buttons/button.dart';

class ModalView extends StatefulWidget {
  final String text;
  final String? subText;
  final Color? backgroundColor;
  final LinearGradient? backgroundGradient;
  final Color? textColor;
  final Color? subTextColor;
  final Widget? closeIcon;
  final Widget? content;
  final Widget? actionButton;
  bool? showActionButton = false;
  final bool removePadding;
  final Function? onActionButtonPressed;

  ModalView({
    Key? key,
    required this.text,
    this.subText,
    this.backgroundColor,
    this.backgroundGradient,
    this.textColor,
    this.subTextColor,
    this.closeIcon,
    this.content,
    this.actionButton,
    this.showActionButton,
    this.onActionButtonPressed,
    this.removePadding = false,
  }) : super(key: key);

  @override
  _ModalViewState createState() => _ModalViewState();
}

class _ModalViewState extends State<ModalView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? CustomColors.white,
          gradient: widget.backgroundGradient,
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: getProportionateScreenHeight(30),
                left:
                    widget.removePadding ? 0 : getProportionateScreenWidth(35),
                right: widget.removePadding
                    ? 0
                    : getProportionateScreenWidth(31.15),
                bottom: getProportionateScreenHeight(30),
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          widget.removePadding
                              ? SizedBox(width: getProportionateScreenWidth(35))
                              : Container(),
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
                                        color: widget.textColor ??
                                            CustomColors.black,
                                      ),
                                    ),
                                    onTap: () => Navigator.pop(context),
                                  ))
                        ]),
                    widget.subText != null
                        ? SizedBox(height: getProportionateScreenHeight(20))
                        : SizedBox(
                            height: getProportionateScreenHeight(35),
                          ),
                    widget.subText != null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                              bottom: getProportionateScreenWidth(32),
                            ),
                            alignment: Alignment.center,
                            child: Text(widget.subText!,
                                style: TextStyle(
                                  color:
                                      widget.subTextColor ?? CustomColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                          )
                        : Container(),
                    Expanded(
                      child: widget.content ?? Container(),
                    ),
                    widget.showActionButton == true
                        ? SizedBox(height: getProportionateScreenHeight(90))
                        : const SizedBox(),
                  ]),
            ),
            widget.showActionButton == true
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(49),
                            bottom: getProportionateScreenHeight(30),
                            left: getProportionateScreenWidth(35),
                            right: getProportionateScreenWidth(35)),
                        color: CustomColors.white.withOpacity(0.7),
                        child: widget.actionButton ??
                            Button(
                                text: "Select account",
                                onPressed: widget.onActionButtonPressed!)))
                : Container(),
          ],
        ));
  }
}
