// class DeepLinkWidget {
//   Future<Uri> createDynamicLink(String id) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://your.page.link',
//       link: Uri.parse('https://{your URL}.com/?id=$id'),//<----id=some value is custom data that you wish to pass
//       androidParameters: AndroidParameters(
//         packageName: 'your_android_package_name',
//         minimumVersion: 1,
//       ),
//       iosParameters: IosParameters(
//         bundleId: 'your_ios_bundle_identifier',
//         minimumVersion: '1',
//         appStoreId: 'your_app_store_id',
//       ),
//     );
//     var dynamicUrl = await parameters.buildUrl();
//
//     return dynamicUrl;
//   }
// }