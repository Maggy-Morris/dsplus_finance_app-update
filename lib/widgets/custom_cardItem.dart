import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  final String title;
  final String value ;
  const BuildCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}

// Widget BuildCard(String title, String value) {
//   return Card(
//     elevation: 4,
//     margin: EdgeInsets.symmetric(vertical: 8.0),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
