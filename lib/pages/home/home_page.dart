import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/models/meallog.dart';
import 'package:test_project/pages/home/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    _homeController.scrollController.addListener(() {
      if (_homeController.scrollController.position.pixels ==
          _homeController.scrollController.position.maxScrollExtent) {
        if (_homeController.currentPage.value <
            _homeController.totalPages.value) {
          _homeController.loadMoreMealLogs();
        }
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
      ),
      body: Obx(
        () {
          if (_homeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_homeController.mealLogs.isEmpty) {
            return const Center(
              child: Text('No meal logs added yet.'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxHeight: 50),
                    hintText: 'Search by name',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MasonryGridView.builder(
                  controller: _homeController.scrollController,
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  shrinkWrap: true,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                  itemCount: _homeController.mealLogs.length,
                  itemBuilder: (context, index) {
                    final mealLog = _homeController.mealLogs[index];
                    return MealViewCard(
                      mealLog: mealLog,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MealViewCard extends StatelessWidget {
  const MealViewCard({super.key, required this.mealLog, required this.index});
  final MealLogElement mealLog;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: index % 6 == 5
              ? Constants.aspectRatioValue / 2.01
              : Constants.aspectRatioValue,
          child: Image.network(
            mealLog.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
          ),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
