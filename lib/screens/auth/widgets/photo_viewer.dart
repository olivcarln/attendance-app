import 'package:flutter/material.dart';

class PhotoViewer extends StatelessWidget {
  final String? photoKey;
  final String label;

  const PhotoViewer({super.key, required this.photoKey, required this.label});

  @override
  Widget build(BuildContext context) {
    if (photoKey == null || photoKey!.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
              SizedBox(height: 8),
              Text(
                'No $label photo',
                style: TextStyle(color: Colors.grey[600]),
              )
            ],
          ),
        ),
      );
    }

    final storageService =; //TODO: Buat logika untuk penyimpanan data 
  }
}