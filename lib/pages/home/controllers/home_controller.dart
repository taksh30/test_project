import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/models/meallog.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/services/shared_preferences.dart';

class HomeController extends GetxController {
  RxList<MealLogElement> mealLogs = <MealLogElement>[].obs;
  String? userToken;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeMealLogs();
  }

  // load meal logs
  void _initializeMealLogs() async {
    userToken = await loadToken() ?? '';
    await fetchMealLogs(userToken: userToken, page: currentPage.value);

    print(mealLogs.length);
  }

  // fetch meal logs
  Future<void> fetchMealLogs({String? userToken, int page = 1}) async {
    isLoading.value = true;
    String url =
        "https://aaloo-dev-api.scaleupdevops.in/v1/api/meallogs?page=$page";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // get the meal log data
      MealLog mealLog = mealLogFromJson(response.body);

      currentPage.value = mealLog.data.pagination.currentPage;
      totalPages.value = mealLog.data.pagination.totalPages;

      // assign the meal logs to the mealLogs list

      if (page == 1) {
        mealLogs.value = mealLog.data.mealLogs;
      } else {
        mealLogs.addAll(mealLog.data.mealLogs);
      }

      isLoading.value = false;
      print("Meal Logs: $mealLogs");
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  }

  void loadMoreMealLogs() {
    if (currentPage.value <= totalPages.value) {
      currentPage.value++;
      fetchMealLogs(userToken: userToken, page: currentPage.value);
    }
  }
}
