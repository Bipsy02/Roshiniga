
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Components/campaignCard.dart';
import '../Components/campaignCardDetail.dart';

class ExploreSearchPage extends StatefulWidget {
  const ExploreSearchPage({super.key});

  @override
  State<ExploreSearchPage> createState() => _ExploreSearchPageState();
}

class _ExploreSearchPageState extends State<ExploreSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      final lowercaseQuery = query.toLowerCase();

      final campaignSnapshot = await _firestore
          .collection('campaigns')
          .where('searchIndex', arrayContains: lowercaseQuery)
          .limit(10)
          .get();

      final userSnapshot = await _firestore
          .collection('users')
          .where('searchIndex', arrayContains: lowercaseQuery)
          .limit(10)
          .get();

      setState(() {
        _searchResults = [
          ...campaignSnapshot.docs,
          ...userSnapshot.docs,
        ];
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search campaigns or users',
                      hintStyle: GoogleFonts.outfit(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        onPressed: () => _search(_searchController.text.trim()),
                      ),
                    ),
                    onSubmitted: _search,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                  ? Center(
                    child: Text(
                      'No results found',
                      style: GoogleFonts.outfit(),
                    ),
                  )
                  : ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final data = _searchResults[index].data() as Map<String, dynamic>;

                      if (data.containsKey('title')) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('campaigns')
                              .where('creatorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, campaignSnapshot) {
                            if (!campaignSnapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
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

                                final dueDate = data['dueDate'] as Timestamp;
                                final timeLeft = _calculateDaysLeft(Timestamp.now(), dueDate);

                                return GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CampaignCardDetail(
                                          size: MediaQuery.of(context).size,
                                          title: data['title'] ?? 'Untitled Campaign',
                                          organizerName: organizerName,
                                          organizerRole: 'Organizer',
                                          progressText: '${data['amountCollected']}/${data['fundingGoal']}',
                                          progress: (data['amountCollected'] / data['fundingGoal']).clamp(0.0, 1.0),
                                          profileImage: profileImage,
                                          timeLeft: timeLeft,
                                          description: data['description'] ?? 'No description available.',
                                        ),
                                      ),
                                    );
                                  },
                                  child: CampaignCard(
                                    size: MediaQuery.of(context).size,
                                    title: data['title'] ?? 'Untitled Campaign',
                                    organizerName: organizerName,
                                    organizerRole: 'Organizer',
                                    progressText: '${data['amountCollected']}/${data['fundingGoal']}',
                                    progress: (data['amountCollected'] / data['fundingGoal']).clamp(0.0, 1.0),
                                    campaignCover: data['coverImage'] ?? '',
                                    profileImage: profileImage,
                                    timeLeft: timeLeft,
                                    category: data['category'] ?? 'Uncategorized',
                                    backers: data['backers'] ?? 0,
                                    description: data['description'] ?? 'No description available.',
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (data.containsKey('email')) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: data['profilePicture'] != null
                                ? MemoryImage(base64Decode(data['profilePicture']))
                                : null,
                          ),
                          title: Text(
                            data['name'],
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            data['email'],
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            //redirect to user profile TO-DO
                          },
                        );
                      } else {
                        return const ListTile(title: Text('Unknown data'));
                      }
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDaysLeft(Timestamp currentDate, Timestamp dueDate) {
    DateTime currentDateTime = currentDate.toDate();
    DateTime dueDateTime = dueDate.toDate();

    return dueDateTime.difference(currentDateTime).inDays;
  }
}
