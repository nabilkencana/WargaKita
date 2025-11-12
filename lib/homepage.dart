// import 'package:flutter/material.dart';
// import 'package:flutter_latihan1/laporanpage.dart';
// import 'package:flutter_latihan1/models/user_model.dart';
// import 'package:flutter_latihan1/profile_page.dart';
// import 'package:flutter_latihan1/sos_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key, required User user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       // 🔹 Bottom navigation bar
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.all(12),
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.15),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//           border: Border.all(color: Colors.blue.withOpacity(0.1)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             const _NavItem(
//               icon: Icons.home_rounded,
//               label: "Home",
//               active: true,
//             ),
//             _NavItem(
//               icon: Icons.report_rounded,
//               label: "Laporan",
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LaporanPage()),
//                 );
//               },
//             ),
//             _NavItem(
//               icon: Icons.sos_rounded,
//               label: "Darurat",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SOSPage()),
//                 );
//               },
//             ),
//               _NavItem(
//               icon: Icons.person_rounded,
//               label: "Profil",
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ProfilePage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Foto profil dan notifikasi
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         // Foto profil dengan bayangan lembut
//                         Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.withOpacity(0.15),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: const CircleAvatar(
//                             radius: 26,
//                             backgroundImage: NetworkImage(
//                               'https://1.bp.blogspot.com/-mFWPriC5yZM/VUx-jyHRCEI/AAAAAAAAITM/zfCUzS4Y2wM/s1600/gambar+monyet+(17).jpg',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         // Nama dan status kecil
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               "Budi Setiawan",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF004AAD),
//                               ),
//                             ),
//                             Text(
//                               "Kelola akun Anda",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.blueGrey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     // Tombol notifikasi dengan badge
//                     Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         IconButton(
//                           icon: const Icon(
//                             Icons.notifications_outlined,
//                             color: Colors.blue,
//                             size: 28,
//                           ),
//                           onPressed: () {},
//                         ),
//                         Positioned(
//                           right: 6,
//                           top: 8,
//                           child: Container(
//                             width: 10,
//                             height: 10,
//                             decoration: const BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Sapaan
//               Padding(
//                 padding: const EdgeInsets.only(top: 8, bottom: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Animasi muncul halus
//                     TweenAnimationBuilder<double>(
//                       tween: Tween(begin: 0, end: 1),
//                       duration: const Duration(milliseconds: 600),
//                       builder: (context, value, child) => Opacity(
//                         opacity: value,
//                         child: Transform.translate(
//                           offset: Offset(0, (1 - value) * 10),
//                           child: child,
//                         ),
//                       ),
//                       child: const Text(
//                         "Hai Budi!",
//                         style: TextStyle(
//                           color: Color(0xFF004AAD),
//                           fontSize: 28,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       "Selamat Pagi 👋",
//                       style: TextStyle(
//                         color: Color(0xFF7A8FA6),
//                         fontSize: 17,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Search bar
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.10),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     icon: const Icon(Icons.search, color: Color(0xFF0066FF)),
//                     hintText: "Cari pengumuman atau warga...",
//                     hintStyle: const TextStyle(color: Colors.grey),
//                     border: InputBorder.none,
//                   ),
//                   onChanged: (value) {
//                     // misalnya nanti kamu mau filter list berdasarkan pencarian
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Gambar kegiatan utama
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Stack(
//                   alignment: Alignment.bottomLeft,
//                   children: [
//                     Image.network(
//                       'https://tse3.mm.bing.net/th/id/OIP.At1OjqSgXO74hncVlDWbHQHaE7?cb=12ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', // contoh link gambar
//                       height: 180,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const Center(child: CircularProgressIndicator());
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           height: 180,
//                           color: Colors.grey[300],
//                           alignment: Alignment.center,
//                           child: const Icon(
//                             Icons.broken_image,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                           colors: [
//                             // ignore: deprecated_member_use
//                             Colors.black.withOpacity(0.6),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       child: const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Kerja Bakti",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 25),

//               // Bagian pengumuman
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "Pengumuman",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color(0xFF004AAD),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "Lihat Semua",
//                     style: TextStyle(color: Colors.blue, fontSize: 12),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Kartu pengumuman 1
//               _AnnouncementCard(
//                 date: "17",
//                 month: "Agustus",
//                 title: "Lomba Pitulasan",
//                 subtitle: "Seluruh Warga",
//                 time: "Minggu , 07.00 WIB",
//                 color: Colors.red.shade400,
//               ),
//               const SizedBox(height: 10),

//               // Kartu pengumuman 2
//               _AnnouncementCard(
//                 date: "06",
//                 month: "Oktober",
//                 title: "Rapat",
//                 subtitle: "Orang Penting",
//                 time: "Senin , 12.00 WIB",
//                 color: Colors.black87,
//               ),
//               const SizedBox(height: 10),


//               // Kartu pengumuman 3
//               _AnnouncementCard(
//                 date: "26",
//                 month: "November",
//                 title: "Jalan Sehat",
//                 subtitle: "Yang Mau",
//                 time: "Selasa , 02.00 WIB",
//                 color: const Color.fromARGB(255, 20, 237, 0),
//               ),
//               const SizedBox(height: 10),


//               // Kartu pengumuman 4
//               _AnnouncementCard(
//                 date: "01",
//                 month: "Desember",
//                 title: "Pingpong",
//                 subtitle: "Club Budi",
//                 time: "Kamis , 09.00 WIB",
//                 color: const Color.fromARGB(255, 0, 0, 0),
//               ),
//               const SizedBox(height: 10),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Widget untuk item navigasi bawah
// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool active;
//   final VoidCallback? onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     this.active = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap ??
//           () {
//             if (label == "Kegiatan") {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LaporanPage()),
//               );
//             }
//           },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: active ? Colors.blue.withOpacity(0.15) : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: active ? const Color(0xFF0066FF) : Colors.grey.shade600,
//               size: active ? 28 : 24,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: active ? const Color(0xFF0066FF) : Colors.grey.shade600,
//                 fontSize: 12,
//                 fontWeight: active ? FontWeight.w600 : FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // Widget kartu pengumuman
// class _AnnouncementCard extends StatelessWidget {
//   final String date, month, title, subtitle, time;
//   final Color color;
//   const _AnnouncementCard({
//     required this.date,
//     required this.month,
//     required this.title,
//     required this.subtitle,
//     required this.time,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: () {
//         showDialog(
//           context: context,
//           barrierDismissible: true,
//           builder: (context) {
//             return Dialog(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Judul
//                     Text(
//                       "$title!",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const [
//                         Text(
//                           "17 Agustus 2025",
//                           style: TextStyle(fontSize: 13, color: Colors.black45),
//                         ),
//                         Text(
//                           "Ketua RT",
//                           style: TextStyle(fontSize: 13, color: Colors.black45),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const Divider(),
//                     const SizedBox(height: 10),

//                     const Text(
//                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: 14,
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Tombol aksi
//                     Center(
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   "Pengumuman ditandai sudah dibaca.",
//                                 ),
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0066FF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "Tandai Sudah Dibaca",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       date,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       month,
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: const TextStyle(
//                         color: Colors.black54,
//                         fontSize: 12,
//                         height: 1.4,
//                       ),
//                     ),
//                     Text(
//                       time,
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(right: 12),
//               child: Icon(Icons.menu, color: Colors.blue),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
