import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';

class SMSTimer extends StatefulWidget {
  const SMSTimer({Key? key}) : super(key: key);

  @override
  State<SMSTimer> createState() => _SMSTimerState();
}

class _SMSTimerState extends State<SMSTimer> {
  static const int _maxTimeInSeconds =
      20; // sms code expiration time in seconds
  int _time = _maxTimeInSeconds;
  Timer? _timer;
  Duration? _duration;

  // Function to start the timer
  void _startTimer() {
    _duration = Duration(seconds: _time);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time == 0) {
        timer.cancel();
      } else {
        setState(() {
          _time--;
        });
        _duration = Duration(seconds: _time);
      }
    });
  }

  // Function to format the duration to a string
  String _formatDuration(Duration duration) =>
      "${(duration.inHours % 60).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  void initState() {
    _startTimer(); // start timer when the page is loaded
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(61.0),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [CustomColors.customBoxShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          _time == 0
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _time = _maxTimeInSeconds;
                    });
                    _startTimer();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.replay_rounded,
                        color: Color(0xFF303030),
                      ),
                      SizedBox(width: getProportionateScreenWidth(9.5)),
                      Text(
                        "Time out. Click to resend code.",
                        style: TextStyle(
                          color: const Color(0xff303030),
                          fontSize: getProportionateScreenHeight(14),
                          fontWeight: FontWeight.w500,
                          height: 1.64,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(19.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Code valid for",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: getProportionateScreenHeight(14.0),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _formatDuration(_duration!),
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: getProportionateScreenHeight(14.0),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
          const Spacer(),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: LinearPercentIndicator(
              isRTL: true,
              percent: (_duration!.inSeconds / _maxTimeInSeconds),
              lineHeight: getProportionateScreenHeight(6.0),
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFFB9C7D3),
              linearGradient: CustomColors.timerGradient,
              clipLinearGradient: true,
            ),
          ),
        ],
      ),
    );
  }
}
