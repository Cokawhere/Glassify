// import 'package:flutter/material.dart';
// import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

// class LiquidGlassScaffold extends StatelessWidget {
//   final Widget child; // الـ Widget اللي هيترندر داخل الـ Scaffold
//   final AppBar? appBar; // AppBar اختياري لو عايزة تستخدميه
//   final Widget? floatingActionButton; // زر عائم اختياري
//   final Widget? bottomNavigationBar; // شريط سفلي اختياري

//   const LiquidGlassScaffold({
//     super.key,
//     required this.child,
//     this.appBar,
//     this.floatingActionButton,
//     this.bottomNavigationBar,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent, // لازم يكون شفاف عشان الـ Liquid Glass يبان
//       appBar: appBar,
//       floatingActionButton: floatingActionButton,
//       bottomNavigationBar: bottomNavigationBar,
//       body: Stack(
//         children: [
//           // الخلفية الثابتة بتاعت LinearGradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white, // الأبيض
//                   Color.fromRGBO(255, 144, 187, 1), // البينك
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           // طبقة الـ Liquid Glass باستخدام LiquidGlass من المكتبة
//           LiquidGlass(
//             blur: 20.0, // درجة التمويه (blur) للتأثير الزجاجي
//             shape: LiquidRoundedSuperellipse(
//               borderRadius: const Radius.circular(50), // شكل زجاجي دائري
//             ),
//             glassContainsChild: true, // الـ child بيكون جزء من التأثير الزجاجي
//             child: SizedBox.expand(
//               child: child, // الـ child بتاعك هيترندر هنا
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }