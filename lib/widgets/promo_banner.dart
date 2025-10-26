import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar promo 
    final List<Map<String, String>> PromoList = [
     {
        'title': 'Flat 50% off on\nFirst Order',
        'subtitle': 'View all offers',
        'image': 'assets/images/washing_machine.png',
      },
      {
        'title': 'Get 25% off on\nDry Cleaning',
        'subtitle': 'Check deals',
        'image': 'assets/images/laundry_basket.png',
      },
    ];

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: PromoList.length,
        itemBuilder: (context, index) {
          final promo = PromoList[index];
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Text(
                            promo['subtitle']!,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4,),
                          const Icon(Icons.arrow_right_alt, color: Colors.blue,),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    promo['image']!,
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                )
              ],
            ),
          );

      
        },
      ),
    );

  }
}
