import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:c_talent/presentation/components/all/custom_bottom_modal.dart';
import 'package:c_talent/presentation/components/all/custom_bottom_modal_body.dart';
import 'package:c_talent/presentation/components/services/search_service_body.dart';
import 'package:c_talent/presentation/components/services/services_body.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/tabs/service_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../components/all/rounded_text_form_field.dart';

class InterestClassTab extends StatefulWidget {
  const InterestClassTab({Key? key}) : super(key: key);

  @override
  State<InterestClassTab> createState() => _InterestClassTabState();
}

class _InterestClassTabState extends State<InterestClassTab>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    loadAllServices();
    super.initState();
  }

  Future<void> loadAllServices() async {
    await Future.wait([
      // RECOMMENDED SERVICES
      Provider.of<ServicesProvider>(context, listen: false)
          .loadRecommendedServices(context: context),
      // ALL SERVICES
      Provider.of<ServicesProvider>(context, listen: false)
          .loadInitialServices(context: context),
      // SERVICES CATEGORIES
      Provider.of<ServicesProvider>(context, listen: false)
          .loadServiceCategories(context: context)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: interestAppBar(context: context),
        body: Consumer<ServicesProvider>(builder: (context, data, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: SizedBox(
                  height: SizeConfig.defaultSize * 5.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      data.searchTxtController.text != ''
                          ? const SizedBox()
                          : Container(
                              margin: EdgeInsets.only(
                                  right: SizeConfig.defaultSize),
                              height: SizeConfig.defaultSize * 4.9,
                              width: SizeConfig.defaultSize * 4.9,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color(0xFFE6E6E6),
                                    width: 1,
                                  )),
                              child: TextButton(
                                onPressed: () {
                                  if (data.allServiceCategories?.categories ==
                                      null) {
                                    // translate
                                    EasyLoading.showInfo(
                                        'Please refresh the page to reload category options',
                                        duration: const Duration(seconds: 4),
                                        dismissOnTap: true);
                                  } else {
                                    showCustomModalBottom(
                                      context: context,
                                      child: Consumer<ServicesProvider>(
                                          builder: (modalContext, data, child) {
                                        return customBottomModalBody(
                                            modalContext: modalContext,
                                            listItems: data
                                                .allServiceCategories!
                                                .categories!
                                                .map((category) =>
                                                    category.title.toString())
                                                .toList(),
                                            value: data.selectedCategory,
                                            onClose: (context) =>
                                                data.closeCustomBottomModal(
                                                    context: context),
                                            onChanged: (modalContext, value) {
                                              data.setFilterCategoryType(value);
                                            },
                                            onPress: (modalContext) {
                                              data.filterServiceCategory(
                                                  context: modalContext);
                                            },
                                            onReset: (modalContext) {
                                              data.resetCategory(
                                                  context: context);
                                            });
                                      }),
                                    );
                                  }
                                },
                                child: Center(
                                    child: SvgPicture.asset(
                                  "assets/svg/filter.svg",
                                  height: SizeConfig.defaultSize * 2.5,
                                  width: SizeConfig.defaultSize * 2.5,
                                  color: data.isFilterBtnClick == true
                                      ? const Color(0xFFA08875)
                                      : const Color(0xFFA1A1A1),
                                )),
                              ),
                            ),
                      Expanded(
                        child: SizedBox(
                          height: SizeConfig.defaultSize * 5.0,
                          child: RoundedTextFormField(
                            onChanged: (value) => data.searchNewServices(
                                servicesFilterType: ServicesFilterType.search,
                                query: value,
                                context: context,
                                // IF USER HAS CLEARED ALL THE KEYWORD IN TEXTFIELD
                                debounceMilliSecond:
                                    data.searchTxtController.text.trim() != ''
                                        ? 800
                                        : 0),
                            textEditingController: data.searchTxtController,
                            textInputType: TextInputType.text,
                            isEnable: true,
                            isReadOnly: false,
                            usePrefix: true,
                            useSuffix: false,
                            hintText:
                                AppLocalizations.of(context).searchTitleKeyword,
                            prefixIcon: SvgPicture.asset(
                              "assets/svg/search.svg",
                              height: SizeConfig.defaultSize * 1.6,
                              width: SizeConfig.defaultSize * 1.6,
                            ),
                            suffixOnPress: () {},
                            borderRadius: SizeConfig.defaultSize * 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize * 2),
              Flexible(
                  // IF SEARCH OR FILTER IS DONE IN SERVICES
                  child: data.searchTxtController.text.trim() != '' ||
                          data.isFilterBtnClick == true
                      ? SearchServicesBody(
                          servicesFilterType:
                              data.searchTxtController.text.trim() != ''
                                  ? ServicesFilterType.search
                                  : ServicesFilterType.filter,
                        )
                      :
                      // NORMAL SERVICES BODY
                      const ServicesBody())
            ],
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
