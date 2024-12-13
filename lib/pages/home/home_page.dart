import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/pages/home/controllers/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

          return MasonryGridView.builder(
            controller: _homeController.scrollController,
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
            ),
            mainAxisSpacing: 8.0,
            itemCount: _homeController.mealLogs.length,
            itemBuilder: (context, index) {
              final mealLog = _homeController.mealLogs[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0)),
                      child: Image.network(
                        mealLog.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        mealLog.note,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
