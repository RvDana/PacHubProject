import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/button.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/controller/fotgot_password_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  final forgotViewController = Get.put(ForgotPasswordController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                splashbackimage,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child:  Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 50, left: 30, right: 30, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildColumnView(),
                        const SizedBox(height: 130),
                        _buildButtonView()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildButtonView() {
    return Button(
      textColor: (forgotViewController.emailTextController.text.isEmpty)
          ? AppColors.grey_hint_color
          : AppColors.white,
      color: (forgotViewController.emailTextController.text.isEmpty)
          ? AppColors.ligt_grey_color
          : AppColors.blue_text_Color,
      text: AppString.save,
      onClick: () {
        if (_formKey.currentState!.validate()) {
          forgotViewController.apiForgotPassword(
              context: context,
              email: forgotViewController.emailTextController.text);
        }
      },
    );
  }

  _buildColumnView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: CommonText(
            text: AppString.pleaseForgot,
            fontSize: 24,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        TextFieldView(
          controller: forgotViewController.emailTextController,
          validator: (val) {
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
              return AppString.email_validation;
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          type: TextInputType.emailAddress,
          text: "Email Address",
        ),
      ],
    );
  }

  // _buildUserCards() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       FutureBuilder<TotalAmountModel?>(
  //           future: getTotalAmount(accessToken),
  //           builder: (context, snapshot) {
  //             final overlay = LoadingOverlay.of(context);
  //             if (snapshot.hasError)
  //               const Center(
  //                 child: NoDataFound(),
  //               );
  //             switch (snapshot.connectionState) {
  //               case ConnectionState.waiting:
  //                 return Center(child: CustomLoader());
  //               case ConnectionState.done:
  //                 if (snapshot.hasData) {
  //                   List<TotalUserAmount>? totalUserAmount =
  //                       snapshot.data?.userDetails?.totalUserAmount;
  //                   List<TotalActiveUser>? totalActiveUser =
  //                       snapshot.data?.userDetails?.totalActiveUser;
  //                   List<TotalPending>? totalPending =
  //                       snapshot.data?.userDetails?.totalPending;
  //                   return Column(
  //                     children: [
  //                       if (totalActiveUser!.isNotEmpty)
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 25),
  //                           child: ListView.builder(
  //                             shrinkWrap: true,
  //                             physics: const NeverScrollableScrollPhysics(),
  //                             itemCount: totalActiveUser.length.compareTo(0),
  //                             itemBuilder: (context, index) {
  //                               var totalActiveItem = totalActiveUser[index];
  //                               return Padding(
  //                                 padding: const EdgeInsets.only(bottom: 10),
  //                                 child: _buildTotalCard(
  //                                     "Active Users",
  //                                     totalActiveItem.total.toString(),
  //                                     contactIcon,
  //                                     AppColors.contacts_card_color,
  //                                     _detailTotalActive,
  //                                     AppColors.white),
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                       if (totalActiveUser.isEmpty)
  //                         Padding(
  //                           padding: const EdgeInsets.only(bottom: 10),
  //                           child: _buildTotalCard(
  //                               "Active Users",
  //                               "",
  //                               contactIcon,
  //                               AppColors.contacts_card_color,
  //                               _detailTotalActive,
  //                               AppColors.white),
  //                         ),
  //                       if (totalUserAmount!.isNotEmpty)
  //                         ListView.builder(
  //                           shrinkWrap: true,
  //                           physics: const NeverScrollableScrollPhysics(),
  //                           itemCount: totalUserAmount.length.compareTo(0),
  //                           itemBuilder: (context, index) {
  //                             var totalAmountItem = totalUserAmount[index];
  //                             return Padding(
  //                               padding: const EdgeInsets.only(bottom: 10),
  //                               child: _buildTotalCard(
  //                                   "Subscription Revenue",
  //                                   "\$ ${totalAmountItem.amount}",
  //                                   revenueIcon,
  //                                   AppColors.matches_card_color,
  //                                   _detailTotalAmount,
  //                                   AppColors.white),
  //                             );
  //                           },
  //                         ),
  //                       if (totalUserAmount.isEmpty)
  //                         Padding(
  //                           padding: const EdgeInsets.only(bottom: 10),
  //                           child: _buildTotalCard(
  //                               "Subscription Revenue",
  //                               "",
  //                               revenueIcon,
  //                               AppColors.matches_card_color,
  //                               _detailTotalAmount,
  //                               AppColors.white),
  //                         ),
  //                       if (totalPending!.isNotEmpty)
  //                         ListView.builder(
  //                           shrinkWrap: true,
  //                           physics: const NeverScrollableScrollPhysics(),
  //                           itemCount: totalPending.length.compareTo(0),
  //                           itemBuilder: (context, index) {
  //                             var totalPendingItem = totalPending[index];
  //                             return Padding(
  //                               padding: const EdgeInsets.only(bottom: 10),
  //                               child: _buildTotalCard(
  //                                   "New Requests",
  //                                   "${totalPendingItem.total}",
  //                                   contactIcon,
  //                                   AppColors.black,
  //                                   _detailTotalPending,
  //                                   AppColors.white),
  //                             );
  //                           },
  //                         ),
  //                       if (totalPending.isEmpty)
  //                         Padding(
  //                           padding: const EdgeInsets.only(bottom: 10),
  //                           child: _buildTotalCard(
  //                               "New Requests",
  //                               "",
  //                               contactIcon,
  //                               AppColors.black,
  //                               _detailTotalPending,
  //                               AppColors.white),
  //                         ),
  //                     ],
  //                   );
  //                 } else {
  //                   return const Center(
  //                     child: NoDataFound(),
  //                   );
  //                 }
  //             }
  //             return const Center(
  //               child: NoDataFound(),
  //             );
  //           }),
  //     ],
  //   );
  // }

}
