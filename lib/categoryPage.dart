
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/discoverCampaignCard.dart';

class CategoryProjectsPage extends StatefulWidget {
  final String categoryName;

  const CategoryProjectsPage({super.key, required this.categoryName});

  @override
  State<CategoryProjectsPage> createState() => _CategoryProjectsPageState();
}

class _CategoryProjectsPageState extends State<CategoryProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} Projects',
          style: GoogleFonts.outfit(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('campaigns')
            .where('creatorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('category', isEqualTo: widget.categoryName)
            .snapshots(),
        builder: (context, campaignSnapshot) {
          if (!campaignSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final campaigns = campaignSnapshot.data!.docs;

          if (campaigns.isEmpty) {
            return Center(
              child: Text(
                'No projects in ${widget.categoryName} category',
                style: GoogleFonts.outfit(),
              ),
            );
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = userSnapshot.data!;
              final profileImage = user['profilePicture'] ?? '';
              final organizerName = user['name'] ?? 'Unknown';

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: campaigns.map((campaign) {
                      final dueDate = campaign['dueDate'];
                      final timeLeft = _calculateDaysLeft(Timestamp.now(), dueDate);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DiscoverCampaignCard(
                            size: MediaQuery.of(context).size,
                            title: campaign['title'] ?? 'Untitled Campaign',
                            organizerName: organizerName,
                            organizerRole: 'Organizer',
                            progressText:
                            '${campaign['amountCollected']}/${campaign['fundingGoal']}',
                            progress: (campaign['amountCollected'] / campaign['fundingGoal'])
                                .clamp(0.0, 1.0),
                            campaignCover: campaign['coverImage'] ?? '',
                            profileImage: profileImage,
                            timeLeft: timeLeft,
                            category: campaign['category'] ?? 'Uncategorized',
                            backers: campaign['numberOfBackers'] ?? 0,
                            description: campaign['description'],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int _calculateDaysLeft(Timestamp currentDate, Timestamp dueDate) {
    DateTime currentDateTime = currentDate.toDate();
    DateTime dueDateTime = dueDate.toDate();

    return dueDateTime.difference(currentDateTime).inDays;
  }
}
