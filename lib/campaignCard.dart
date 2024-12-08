
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_link/Components/campaignCardDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class CampaignCard extends StatelessWidget {
  final Size size;
  final String title;
  final String organizerName;
  final String organizerRole;
  final String progressText;
  final double progress;
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
      onTap: () async {
        var currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          var campaignsSnapshot = await FirebaseFirestore.instance
              .collection('campaigns')
              .where('creatorID', isEqualTo: currentUser.uid)
              .get();

          if (campaignsSnapshot.docs.isNotEmpty) {
            var campaign = campaignsSnapshot.docs.first;

            var userSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();

            if (userSnapshot.exists) {
              var user = userSnapshot.data();
              var profileImage = user?['profilePicture'] ?? '';
              var organizerName = user?['name'] ?? 'Unknown';

              var dueDate = campaign['dueDate'];
              var timeLeft = _calculateDaysLeft(Timestamp.now().toDate(), dueDate.toDate());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampaignCardDetail(
                    size: size,
                    title: campaign['title'] ?? 'Untitled Campaign',
                    organizerName: organizerName,
                    organizerRole: 'Organizer',
                    progressText: '${campaign['amountCollected']}/${campaign['fundingGoal']}',
                    progress: (campaign['amountCollected'] / campaign['fundingGoal']).clamp(0.0, 1.0),
                    profileImage: profileImage,
                    timeLeft: timeLeft,
                    description: campaign['description'] ?? '',
                  ),
                ),
              );
            }
          }
        }
      },
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundImage:MemoryImage(
                        base64Decode(profileImage), // Decode Base64 to display the image
                      )
                  ),
                ),
                const SizedBox(width: 10),
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
                        color: const Color(0xFF747474),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                SizedBox(
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
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                      color: Colors.white,
                    ),
                    child: const Icon(
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
                      fontSize: 16, color: const Color(0xFF747474)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category),
                const SizedBox(width: 10),
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
