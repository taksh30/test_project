import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: Colors.black,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
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
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: _homeController.scrollController,
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 3.0,
                  ),
                  itemCount: _homeController.mealLogs.length,
                  itemBuilder: (context, index) {
                    final mealLog = _homeController.mealLogs[index];
                    return Image.network(
                      mealLog.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
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
