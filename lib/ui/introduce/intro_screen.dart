import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/introduce/intro_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/circle_indicator_widget.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends BaseState<IntroModel, IntroScreen> {
  @override
  void initState() {
    super.initState();
    model.setFirstUsedApp();
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  Widget _buildSlider() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - (190 + 50 + 10 + 20);
    return CarouselSlider(
      carouselController: model.carouselController,
      options: CarouselOptions(
          autoPlay: false,
          viewportFraction: 1,
          aspectRatio: width / height,
          initialPage: 0,
          onPageChanged: (index, reason) {
            model.currentIndex.value = index;
          }),
      items: [
        Image.asset(
          DImages.intro1,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Image.asset(
          DImages.intro2,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Image.asset(
          DImages.intro3,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Image.asset(
          DImages.intro4,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        )
      ],
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          margin: EdgeInsets.only(top: 47, right: 18),
          child: InkWell(
            child: Text(
              Strings.ignore.localize(context),
              style: textTheme(context).text15.colorDart,
            ),
            onTap: () async {
              await locator<UserModel>().setAuthState(AuthState.unauthorized);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )),
    );
  }

  Widget _buildIndicator() {
    return CircleIndicatorWidget(10, 4, model.currentIndex);
  }

  Widget _buildText() {
    return ValueListenableProvider.value(
      value: model.currentIndex,
      child: Consumer<int>(
        builder: (context, index, child) {
          String text = "";
          switch (index) {
            case 0:
              text = Strings.friends_app.localize(context);
              break;
            case 1:
              text = Strings.quick_connect.localize(context);
              break;
            case 2:
              text = Strings.exchange_virtual.localize(context);
              break;
            case 3:
              text = Strings.exciting_events.localize(context);
              break;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Text(
              text,
              style: textTheme(context).text18.bold.colorDart,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomButton() {
    return ValueListenableProvider.value(
      value: model.currentIndex,
      child: Consumer<int>(
        builder: (context, index, child) => Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
          child: SafeArea(
            child: PrimaryButton(
              text: index == 3
                  ? Strings.done.localize(context)
                  : Strings.next.localize(context),
              onPressed: () async {
                if (index != 3)
                  model.carouselController.nextPage();
                else {
                  await locator<UserModel>()
                      .setAuthState(AuthState.unauthorized);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, IntroModel model) {
    return Scaffold(
      backgroundColor: getColor().white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: _buildSlider()),
              SizedBox(
                height: 20,
              ),
              _buildIndicator(),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildText(),
                    _buildBottomButton(),
                  ],
                ),
              ),
            ],
          ),
          _buildSkipButton(),
        ],
      ),
    );
  }
}
