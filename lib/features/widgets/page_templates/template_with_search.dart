import 'package:flutter/material.dart';
import 'package:mis_mobile/core/styles/custom_colors.dart';
import 'package:mis_mobile/core/utils/screen_util.dart';
import 'package:mis_mobile/features/widgets/buttons/back_button.dart';

class TemplateWithSearch extends StatelessWidget {
  final String title;
  final String? searchHint;
  final bool? isSearch;
  final Widget? header;
  final Widget body;

  const TemplateWithSearch({
    Key? key,
    required this.title,
    this.searchHint,
    this.isSearch = true,
    this.header,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: CustomColors.mainBg.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CustomColors.white,
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.black.withOpacity(0.1),
                    offset: const Offset(0, 10),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(70),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(33)),
                    child: CustomBackButton(
                      text: "Back",
                      onPressed: () => Navigator.pop(context),
                      color: CustomColors.black,
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(27),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(33),
                        right: getProportionateScreenWidth(28)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(27),
                  ),
                  Divider(
                    height: getProportionateScreenHeight(1),
                    thickness: 1,
                    color: CustomColors.grey,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: getProportionateScreenHeight(60),
                    alignment: Alignment.center,
                    child: isSearch!
                        ? Container(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(33)),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: searchHint,
                                hintStyle: const TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: CustomColors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : header,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: body,
              ),
            )
          ],
        ),
      )),
    );
  }
}
