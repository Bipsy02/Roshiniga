
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_link/Components/searchBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/bottomNavBar.dart';
import '../Components/discoverCampaignCard.dart';
import 'categoryPage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  Widget categoryItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 12),
        ),
      ],
    );
  }

  campaignCard() {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Together we can: Fundraiser Gala',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$18,432/\$20,000',
                  style: GoogleFonts.outfit(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Back this project',
                    style: GoogleFonts.outfit(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  categoriesSection() {
    final categories = [
      {'name': 'Education', 'icon': Icons.school_outlined},
      {'name': 'Gaming', 'icon': Icons.sports_esports_outlined},
      {'name': 'Art', 'icon': Icons.palette_outlined},
      {'name': 'Food', 'icon': Icons.rice_bowl_outlined},
      {'name': 'Technology', 'icon': Icons.computer_outlined},
      {'name': 'Music', 'icon': Icons.music_note_outlined},
      {'name': 'Social Cause', 'icon': Icons.people_outlined},
    ];

    return Container(
      padding: const EdgeInsets.only(left: 18, top: 10, right: 18, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProjectsPage(
                          categoryName: category['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(category['icon'] as IconData, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'] as String,
                          style: GoogleFonts.outfit(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  discoverSection() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              'Discover Now',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('campaigns')
                .where('creatorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, campaignSnapshot) {
              if (!campaignSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final campaigns = campaignSnapshot.data!.docs;

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
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: campaigns.map((campaign) {
                          final dueDate = campaign['dueDate'];
                          final timeLeft = _calculateDaysLeft(Timestamp.now(), dueDate);

                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 350,
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
        ],
      ),
    );
  }

  popularSection(Size size) {
    return Container(
      padding: const EdgeInsets.only(left: 18, top: 10, right: 18, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Column(
            children: [
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    String currentPage = 'ExplorePage';
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SearchNavBar(),
              const SizedBox(height: 1),
              categoriesSection(),
              const SizedBox(height: 1),
              discoverSection(),
              const SizedBox(height: 1),
              popularSection(size),
            ],
          ),
        ),
      ),
      floatingActionButton:BottomNavBar(
        size: size,
        currentPage: currentPage,
      ),
    );
  }

  int _calculateDaysLeft(Timestamp currentDate, Timestamp dueDate) {
    DateTime currentDateTime = currentDate.toDate();
    DateTime dueDateTime = dueDate.toDate();

    return dueDateTime.difference(currentDateTime).inDays;
  }
}