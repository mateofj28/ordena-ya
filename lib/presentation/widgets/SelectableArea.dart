// import 'package:flutter/material.dart';
// import 'package:ordena_ya/core/constants/AppColors.dart';
// import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
// import 'package:provider/provider.dart';


// class SelectableArea extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final double height;
//   final double width;

//   const SelectableArea({
//     super.key,
//     required this.label,
//     required this.icon,
//     required this.height,
//     required this.width,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<OrderSetupProvider>(context);
//     final isSelected = provider.isSelectedOption(label);

//     return GestureDetector(
//       onTap: () => {},
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primaryButton : Colors.white,
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 32, color: isSelected ? Colors.white : Colors.black),
//               SizedBox(height: 8),
//               Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
