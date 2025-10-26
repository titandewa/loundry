import 'package:flutter/material.dart';
import '../utils/dummy_data.dart';
import '../widgets/header.dart';
import '../widgets/category_item.dart';
import '../widgets/best_seller_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/recommend_card.dart';
import '../widgets/bottom_nav.dart';
import '../experiments/comparison_page.dart'; // ✅ Tambahkan impor untuk navigasi langsung

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({Key? key}) : super(key: key);

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  int? selectedCategoryIndex;
  int? selectedBestSellerIndex;
  int? selectedRecommendIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog Laundry',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded),
            tooltip: 'Buka Halaman Perbandingan',
            onPressed: () {
              // ✅ Navigasi ke ComparisonPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComparisonPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: dummyCategories.length,
                        itemBuilder: (context, index) {
                          final category = dummyCategories[index];
                          final isSelected = selectedCategoryIndex == index;
                          return CategoryItem(
                            category: category,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex =
                                    isSelected ? null : index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBestSellerSection(),
                    const SizedBox(height: 16),
                    const PromoBanner(),
                    const SizedBox(height: 16),
                    _buildRecommendSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildBestSellerSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Seller',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'View All >',
                style: TextStyle(fontSize: 13, color: Color(0xFFFF8C42)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: dummyBestSellers.length,
            itemBuilder: (context, index) {
              final service = dummyBestSellers[index];
              final isSelected = selectedBestSellerIndex == index;
              return BestSellerCard(
                service: service,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    selectedBestSellerIndex = isSelected ? null : index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recommend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth < 400
                  ? 2
                  : constraints.maxWidth < 800
                      ? 3
                      : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: dummyRecommended.length,
                itemBuilder: (context, index) {
                  final service = dummyRecommended[index];
                  final isSelected = selectedRecommendIndex == index;
                  return RecommendCard(
                    service: service,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedRecommendIndex =
                            isSelected ? null : index;
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
