// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class Campaigncard extends StatefulWidget {
//   const Campaigncard({super.key});
//
//   @override
//   State<Campaigncard> createState() => _CampaigncardState();
// }
//
// class _CampaigncardState extends State<Campaigncard> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
// Widget campaignCardTest(Size size){
//   return GestureDetector(
//     onTap: () {},
//     child: Container(
//       height: 400,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color:Color(0xFFEEEEEE), width: 1),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//               children: [
//                 Container(
//                   height: 50,
//                   width: 50,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(25),
//                       child: Image.network(
//                         "https://plus.unsplash.com/premium_photo-1689539137236-b68e436248de?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
//                         ,fit: BoxFit.cover,
//                         //   Image.asset("images/bg.png",fit: BoxFit.cover,)),
//                       )
//                   ),
//                 ),
//                 SizedBox(width: 10,),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Insan Pribadi',
//                       style: GoogleFonts.outfit(fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       'Organizer',
//                       style: GoogleFonts.outfit(fontSize: 14,
//                         color: Color(0xFF747474),
//                       ),
//                     )
//                   ],
//                 )
//               ]
//           ),
//           Stack(
//             children: [
//               Container(
//                 width: size.width,
//                 height: 165,
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.network(
//                       "https://media.istockphoto.com/id/1498170916/photo/a-couple-is-taking-a-bag-of-food-at-the-food-and-clothes-bank.jpg?s=1024x1024&w=is&k=20&c=ASXbBbzgxFx83RgmjnQoHssc6zTlPZlhZgSnKJhOPQ0="
//                       ,fit: BoxFit.cover,
//                       //   Image.asset("images/bg.png",fit: BoxFit.cover,)),
//                     )
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Container(
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(color:Color(0xFFEEEEEE), width: 1),
//                       color: Colors.white
//                   ),
//                   //TODO: Make the color Red when liked
//                   child: Icon(CupertinoIcons.heart, color: Colors.black,),
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             'Together we can: Fundraiser Gala',
//             style: GoogleFonts.outfit(fontSize: 18,
//                 fontWeight: FontWeight.w600),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Container(
//                       height: 5, // Thickness of the progress bar
//                       // Background color
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.grey[300],
//                       ),
//                     ),
//                     FractionallySizedBox(
//                       //TODO: replace constant value of widthFactor with a parameter from constructor
//                       widthFactor: 0.7, // Progress as a percentage (0.7 = 70%)
//                       child: Container(
//                         height: 5, // Same as background height
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.green,
//                         ), // Progress color
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "\$18,000/\$20,000",
//                 style: GoogleFonts.outfit(fontSize: 16,
//                     fontWeight: FontWeight.w500),
//               ),
//               Text(
//                 "12 days left",
//                 style: GoogleFonts.outfit(fontSize: 16,
//                     color: Color(0xFF747474)),
//               ),
//             ],
//           ),
//           SizedBox(height: 20,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Category'),
//               SizedBox(width: 10,),
//               Text('Backed by 1,987 people')
//             ],
//           )
//         ],
//       ),
//     ),
//   );
// }

import 'dart:convert';

import 'package:crowd_link/Components/campaignCardDetail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class CampaignCard extends StatelessWidget {
  final Size size;
  final String title;
  final String organizerName;
  final String organizerRole;
  final String progressText;
  final double progress; // Progress percentage (e.g., 0.7 for 70%)
  final String campaignCover;
  final String profileImage;
  final int timeLeft;
  final String category;
  final int backers;
  final String description;

  const CampaignCard({
    required this.size,
    required this.title,
    required this.organizerName,
    required this.organizerRole,
    required this.progressText,
    required this.progress,
    required this.campaignCover,
    required this.profileImage,
    required this.timeLeft,
    required this.category,
    required this.backers,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CampaignCardDetail(
            size: MediaQuery.of(context).size,
            title: title,
            organizerName: organizerName,
            organizerRole: organizerRole,
            progressText: '18,432 / 20,000',
            progress: 0.92,
            profileImage: profileImage,
            timeLeft: timeLeft,
            description: description,
            )
          ),
        );
      },
      child: Container(
        height: 400,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFEEEEEE), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundImage:MemoryImage(
                        base64Decode(profileImage), // Decode Base64 to display the image
                      )
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organizerName,
                      style: GoogleFonts.outfit(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      organizerRole,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Color(0xFF747474),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  width: size.width,
                  height: 165,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: MemoryImage(
                        base64Decode(campaignCover), // Decode Base64 to display the image
                      ),
                      fit: BoxFit.cover, // Adjust the image to fit the container
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xFFEEEEEE), width: 1),
                      color: Colors.white,
                    ),
                    child: Icon(
                      CupertinoIcons.heart,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 5, // Thickness of the progress bar
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress, // Dynamic progress
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progressText,
                  style: GoogleFonts.outfit(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$timeLeft days left',
                  style: GoogleFonts.outfit(
                      fontSize: 16, color: Color(0xFF747474)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category),
                SizedBox(width: 10),
                Text('backed by $backers people'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateDaysLeft(DateTime currentDate, DateTime dueDate) {

    // Calculate the difference
    Duration difference = dueDate.difference(currentDate);

    // Get the number of days left
    int daysLeft = difference.inDays;

    return daysLeft;
  }
}
