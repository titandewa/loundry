import 'package:flutter/material.dart';
import '../models/laundry_service.dart';

class BestSellerCard extends StatelessWidget {
  final LaundryService service;
  final bool isSelected;
  final VoidCallback onTap;

  const BestSellerCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: service.color.withOpacity(0.15),
              radius: 28,
              child: Icon(service.image, color: service.color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              service.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              service.subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              service.price,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (service.discount != null) ...[
              const SizedBox(height: 4),
              Text(
                '${service.discount} OFF',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
