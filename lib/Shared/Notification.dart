import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Controller/auth_controller.dart';
import '../Controller/Notification-controller.dart';
import '../Models/notification_model.dart';

class Notifications extends StatelessWidget {
  final NotificationsController _notificationsController =
  Get.put(NotificationsController());
AuthController authController=new AuthController();



  //Notifications({required this.userId});

  Widget build(BuildContext context) {
    final String userId=authController.currentUserUid!; // User ID variable
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    // Fetch notifications when the widget is built
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _notificationsController.fetchAllUserNotifications(userId);
    });

    return Scaffold(
      body: Obx(() {
        if (_notificationsController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                  EdgeInsets.fromLTRB(221.34 * fem, 0 * fem, 0 * fem, 8 * fem),
                  width: 22.34 * fem,
                  height: 22.34 * fem,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(

                        child: IconButton(
                          icon: Icon(Icons.notifications),
                          onPressed: null,
                          color: Color(0xFFFC5448),
                        ),
                      ),

                      Container(
                        margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 120 * fem, 0 * fem),
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 20 * ffem,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _notificationsController.notifications.length,
                  separatorBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 50 * fem),
                    width: double.infinity,
                    height: 1 * fem,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFFC5448),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, index) {
                    NotificationModel notification =
                    _notificationsController.notifications[index];
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 7 * fem, horizontal: 12 * fem),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            // Add onTap function here
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12 * fem, horizontal: 10 * fem),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontSize: 19 * ffem,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 3 * fem),
                                      // Text(
                                      //   notification.body,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   maxLines: 1,
                                      //   style: TextStyle(
                                      //     fontSize: 14 * ffem,
                                      //     fontWeight: FontWeight.w700,
                                      //     height: 1.3 * ffem / fem,
                                      //     color: Color(0xff6f6f6f),
                                      //   ),
                                      // ),
                                      SizedBox(height: 5 * fem),
                                      Text(
                                        'Type: ${notification.type}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(height: 5 * fem),
                                      Text(
                                        'Time: ${notification.timestamp}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                      SizedBox(height: 5 * fem),
                                      Text(
                                        'Request ID: ${notification.requestId}',
                                        style: TextStyle(
                                          fontSize: 13 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4 * ffem / fem,
                                          color: Color(0xff6f6f6f),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    );
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
