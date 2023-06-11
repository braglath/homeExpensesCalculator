import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/data/models/home_model.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_string.dart';
import 'package:homeexpensecalculator/helpers/functions/capture_save_image.dart';
import 'package:homeexpensecalculator/helpers/mixins/field_validations.dart';
import 'package:homeexpensecalculator/providers/registration/home_setup_provider.dart';
import 'package:homeexpensecalculator/utils/app_constants.dart';
import 'package:homeexpensecalculator/widgets/common_elevated_button.dart';
import 'package:homeexpensecalculator/widgets/common_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class RegistrationHomeSetupScreen extends StatefulWidget {
  const RegistrationHomeSetupScreen({super.key});

  @override
  State<RegistrationHomeSetupScreen> createState() =>
      RegistrationHomeSetupState();
}

class RegistrationHomeSetupState
    extends CommonScaffold<RegistrationHomeSetupScreen>
    with FieldValidationMixin {
  late TextEditingController homeTitleTextController;
  late PageController pageController;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String encryptedHomeTitle = '';
  String random4String = '';

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    homeTitleTextController = TextEditingController();
    homeTitleTextController.addListener(() {
      if (!homeTitleTextController.text.isNullOrEmpty &&
          key.currentState!.validate() &&
          !context.read<RegistrationHomeSetupProvider>().showSaveBtn) {
        context.read<RegistrationHomeSetupProvider>().setShowSaveBtn(true);
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    homeTitleTextController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => SafeArea(
        child: PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            _homeName(context),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.amber,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.green,
            ),
          ],
        ),
      );

  Container _homeName(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height,
        padding: AppConstants.pad16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Home Setup",
                style: Theme.of(context).textTheme.headlineLarge),
            _textFieldWButton(context),
            if (context.watch<RegistrationHomeSetupProvider>().isCardLoading)
              const Center(child: CircularProgressIndicator())
            else if (context.watch<RegistrationHomeSetupProvider>().showNextBtn)
              _homeDetailsCard(context)
            else
              const SizedBox.shrink(),
          ],
        ),
      );

  Widget _textFieldWButton(BuildContext context) => Form(
        key: key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: homeTitleTextController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              decoration:
                  const InputDecoration(hintText: 'Enter name for your house'),
              validator: (String? title) => homeTitleValidation(title),
            ),
            AppConstants.height10,
            Row(
              children: <Widget>[
                const Spacer(),
                CommonElevatedButton(
                  text: 'Save',
                  onTap: !context
                          .watch<RegistrationHomeSetupProvider>()
                          .showSaveBtn
                      ? null
                      : () async => context
                          .read<RegistrationHomeSetupProvider>()
                          .setHomeCodeAndEncryption(
                            homeTitleTextController.text,
                          ),
                ),
              ],
            ),
          ],
        ),
      );

  // ignore: always_specify_types
  Widget _homeDetailsCard(BuildContext context) => Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          // ignore: always_specify_types
          Screenshot(
            controller: screenshotController,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: AppConstants.pad16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Home Code",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey[500]),
                          ),
                          Text(
                            context
                                .watch<RegistrationHomeSetupProvider>()
                                .homeCode,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      _qrCode(context),
                    ],
                  ),
                  Text(
                    '''
  \nNote*
  code has been copied to your clipboard.
  Save this code somewhere and share it with your home mates to join your home.
  In-Mates can also scan the QR Code to join your home.
  ''',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: TextButton(
                onPressed: () async {
                  await screenshotController
                      .capture()
                      .then((Uint8List? image) => CaptureSaveImage.saveWidget(
                            image!,
                            homeTitleTextController.text,
                            screenshotController,
                          ))
                      .catchError((dynamic e) {
                    throw (e);
                  });
                },
                child: const Text("Save to Gallery")),
          )
        ],
      );

  QrImageView _qrCode(BuildContext context) => QrImageView(
        data: <String, String>{
          "homeCode": context.watch<RegistrationHomeSetupProvider>().homeCode,
          "encryptionKey":
              context.watch<RegistrationHomeSetupProvider>().encryptedKey
        }.toString(),
        version: QrVersions.auto,
        size: 125.0,
      );

  @override
  Widget? bottomNavBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            CommonElevatedButton(
              text: context
                          .watch<RegistrationHomeSetupProvider>()
                          .currentPageIndex !=
                      0
                  ? 'Back'
                  : 'Cancel',
              onTap: () async {
                if (context
                        .read<RegistrationHomeSetupProvider>()
                        .currentPageIndex !=
                    0) {
                  await context
                      .read<RegistrationHomeSetupProvider>()
                      .navigateTo(
                          pageController,
                          context
                                  .read<RegistrationHomeSetupProvider>()
                                  .currentPageIndex -
                              1);
                }
              },
              color: Colors.redAccent,
            ),
            AppConstants.width25,
            CommonElevatedButton(
                text: 'Next',
                onTap:
                    !context.watch<RegistrationHomeSetupProvider>().showNextBtn
                        ? null
                        : () async {
                            final RegistrationHomeSetupProvider viewModel =
                                context.read<RegistrationHomeSetupProvider>();

                            await viewModel.addOrUpdateHome(
                                home: HomeModel(
                                    id: viewModel.createdHomeId ?? 0,
                                    name: homeTitleTextController.text,
                                    code: viewModel.homeCode,
                                    encryption: viewModel.encryptedKey,
                                    startDate: DateTime.now()),
                                pageController: pageController,
                                i: context
                                        .read<RegistrationHomeSetupProvider>()
                                        .currentPageIndex +
                                    1);
                          }),
          ],
        ),
      );
}
