import 'package:flutter/material.dart';
import 'package:mis_mobile/core/models/message.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportChat extends StatefulWidget {
  final List<Message> messages;

  const SupportChat({Key? key, required this.messages}) : super(key: key);

  @override
  _SupportChatState createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: ListView.builder(
            itemCount: widget.messages.length,
            reverse: true,
            padding: const EdgeInsets.only(top: 20, bottom: 0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final reversedIndex = widget.messages.length - index - 1;
              final reversedMessages = widget.messages[reversedIndex];
              return Align(
                alignment: reversedMessages.type == 'receiver'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: !reversedMessages.isDefault
                    ? Container(
                        width: getProportionateScreenWidth(292),
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(24)),
                        margin: reversedMessages.type == 'receiver'
                            ? EdgeInsets.only(
                                left: getProportionateScreenWidth(33),
                                bottom: getProportionateScreenHeight(20))
                            : EdgeInsets.only(
                                right: getProportionateScreenWidth(33),
                                bottom: getProportionateScreenHeight(20)),
                        decoration: reversedMessages.type == 'receiver'
                            ? const BoxDecoration(
                                color: CustomColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(11),
                                  topRight: Radius.circular(11),
                                  bottomRight: Radius.circular(11),
                                ))
                            : const BoxDecoration(
                                color: CustomColors.primary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(11),
                                  topRight: Radius.circular(11),
                                  bottomLeft: Radius.circular(11),
                                )),
                        child: Text(reversedMessages.text,
                            style: reversedMessages.type == 'receiver'
                                ? const TextStyle(
                                    color: CustomColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)
                                : const TextStyle(
                                    color: CustomColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                      )
                    : Container(
                        width: getProportionateScreenWidth(292),
                        height: getProportionateScreenHeight(390),
                        padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(24),
                            right: getProportionateScreenWidth(24)),
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeight(166),
                            left: getProportionateScreenWidth(33),
                            bottom: getProportionateScreenHeight(20)),
                        decoration: const BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(11),
                              topRight: Radius.circular(11),
                              bottomRight: Radius.circular(11),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: getProportionateScreenHeight(24)),
                            const Text(
                                'Hello, MyApp support here.\nHow can we help you?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.black,
                                  fontWeight: FontWeight.w400,
                                )),
                            SizedBox(height: getProportionateScreenHeight(24)),
                            GestureDetector(
                              child: Container(
                                height: getProportionateScreenHeight(45),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFCEDEEA),
                                    )),
                                alignment: Alignment.center,
                                child: const Text(
                                  'How to log in?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.messages.add(Message(
                                      'How to log in?', 'sender', false));
                                });
                              },
                            ),
                            SizedBox(height: getProportionateScreenHeight(11)),
                            GestureDetector(
                              child: Container(
                                height: getProportionateScreenHeight(45),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFCEDEEA),
                                    )),
                                alignment: Alignment.center,
                                child: const Text(
                                  'How to make money transfer?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.messages.add(Message(
                                      'How to make money transfer?',
                                      'sender',
                                      false));
                                });
                              },
                            ),
                            SizedBox(height: getProportionateScreenHeight(11)),
                            GestureDetector(
                              child: Container(
                                height: getProportionateScreenHeight(45),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFCEDEEA),
                                    )),
                                alignment: Alignment.center,
                                child: const Text(
                                  'How to add money to account?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.messages.add(Message(
                                      'How to add money  to account?',
                                      'sender',
                                      false));
                                });
                              },
                            ),
                            SizedBox(height: getProportionateScreenHeight(24)),
                            const Text(
                                'If you have other problem, please\ntype your concerns below or',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.black,
                                  fontWeight: FontWeight.w400,
                                )),
                            SizedBox(height: getProportionateScreenHeight(18)),
                            GestureDetector(
                              child: Container(
                                  height: getProportionateScreenHeight(45),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xFFCEDEEA),
                                      )),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.call),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(10)),
                                      const Text('Call us (free number)',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: CustomColors.black,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  )),
                              onTap: () async {
                                await launch('tel:+233503300330');
                              },
                            )
                          ],
                        ),
                      ),
              );
            }));
  }
}
