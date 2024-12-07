import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_link/pages/editProfilePage.dart';
import 'package:crowd_link/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Components/campaignCard.dart';
import '../Components/bottomNavBar.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;
  String? userName;
  String? description;
  String? about;
  String? profilePicture;
  int? connectionsCount;
  int? backedCount;
  int? campaignsCount;
  int? balance;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      // Step 1: Get current user's UID
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;

        // Step 2: Fetch the document directly by UID (used as document ID)
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        // Step 3: Retrieve the fields if the document exists
        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name']; // Access the 'name' field
            description = userDoc['description']; // Access the 'description' field
            connectionsCount = userDoc['connectionsCount']; // Access the 'connectionsCount' field
            backedCount = userDoc['backedCount']; // Access the 'backedCount' field
            campaignsCount = userDoc['campaignsCount']; // Access the 'campaignsCount' field
            balance = userDoc['balance']; // Access the 'balance' field
            about = userDoc['about'];
            profilePicture = userDoc['profilePicture'];
            print('found');
            setState(() {
              isLoading = false; // Fetching is complete
            });
          });
        } else {
          print('No document found for the current user.');
          setState(() {
            isLoading = false; // Fetching is complete
          });        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }


  Widget buildProfileHeader(Size size) {
    return Container(
      height: size.height / 3,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Profile Info
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profilePicture != null
                    ? MemoryImage(
                  base64Decode(profilePicture!), // Decode Base64 to display the image
                )
                    : AssetImage('assets/images/default_profile.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Container(
                width: size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName != null
                        ? '$userName'
                        : 'Guest',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1, // Limit to 2 lines
                      overflow: TextOverflow.ellipsis, // Add "..." if text overflows
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description != null
                          ? '$description'
                          : 'No description',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2, // Limit to 2 lines
                      overflow: TextOverflow.ellipsis, // Add "..." if text overflows
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Ensures the sheet takes only the space it needs
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit Profile'),
                              onTap: () {
                                Navigator.pop(context); // Close the modal
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditor(
                                      username: userName,
                                      about: about,
                                      description: description,
                                      profilePicture: profilePicture,
                                      fetchUserData: fetchUserData,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('Logout'),
                              onTap: () {
                                // Clear the navigation stack and go to the login page
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => Loginpage()), // Replace with your actual LoginPage
                                      (route) => false, // Removes all routes from the stack
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildProfileStat('Connections', (connectionsCount != null ? connectionsCount.toString() : '0')),
              buildProfileStat('Backed', (backedCount != null ? backedCount.toString() : '0')),
              buildProfileStat('Campaigns', (campaignsCount != null ? campaignsCount.toString() : '0')),
            ],
          ),
          const SizedBox(height: 16),
          // Wallet Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    balance != null
                    ? '\$$balance'
                    : '\$0',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      'Top Up',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileStat(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentPage = 'ProfilePage';
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body:
        isLoading ? Center(child: CircularProgressIndicator()):// Show loader while fetching
          SafeArea(
        child: Column(
          children: [
            buildProfileHeader(size),
            const SizedBox(height: 1),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: TabBar(
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.only(left: 30),
                dividerColor: Colors.white,
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'About',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Campaigns',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.black87,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:  [
                  AboutPage(about: about),
                  CampaignsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BottomNavBar(
        size: size,
        currentPage: currentPage,
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  final String? about;
  const AboutPage({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(about != null ? about! : '', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return Placeholder();
  // }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('campaigns')
            .where('creatorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, campaignSnapshot) {
          if (!campaignSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final campaigns = campaignSnapshot.data!.docs;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final user = userSnapshot.data!;
              final profileImage = user['profilePicture'] ?? '';
              final organizerName = user['name'] ?? 'Unknown';

              return ListView.builder(
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];

                  final dueDate = campaign['dueDate'];

                  final timeLeft = _calculateDaysLeft(Timestamp.now(), dueDate);

                  return CampaignCard(
                    size: size,
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  int _calculateDaysLeft(Timestamp currentDate, Timestamp dueDate) {
    // Convert Timestamp to DateTime before calculating the difference
    DateTime currentDateTime = currentDate.toDate();
    DateTime dueDateTime = dueDate.toDate();

    return dueDateTime.difference(currentDateTime).inDays;
  }

  // DateTime _calculateDueDate(String dueDays, DateTime createdAt) {
  //   final days = int.tryParse(dueDays.split(' ')[0]) ?? 0;
  //   return createdAt.add(Duration(days: days));
  // }
}
