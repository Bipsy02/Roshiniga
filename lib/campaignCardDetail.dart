import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampaignCardDetail extends StatefulWidget {
  final Size size;
  final String title;
  final String organizerName;
  final String organizerRole;
  final String progressText;
  final double progress;
  final String profileImage;
  final int timeLeft;
  final List<String> campaignImages;
  final String description;

  const CampaignCardDetail({
    required this.size,
    required this.title,
    required this.organizerName,
    required this.organizerRole,
    required this.progressText,
    required this.progress,
    required this.profileImage,
    required this.timeLeft,
    this.campaignImages = const [],
    required this.description,
    super.key,
  });

  @override
  State<CampaignCardDetail> createState() => _DetailPageState();
}

class _DetailPageState extends State<CampaignCardDetail> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget imageCard() {
    final List<String> imagePaths = widget.campaignImages.isNotEmpty
        ? widget.campaignImages
        : [
      'assets/images/crowdLinkLogo.png',
      'assets/images/crowdLinkLogo.png',
      'assets/images/crowdLinkLogo.png',
    ];

    return Container(
      height: widget.size.height / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: PageView.builder(
              controller: _pageController,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePaths[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodySection() {
    return Expanded(
      child: Container(
        width: widget.size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.outfit().fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Rs. ${widget.progressText}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.timeLeft} days left',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1,),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: widget.progress,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: MemoryImage(
                      base64Decode(widget.profileImage),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.organizerName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.outfit().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.organizerRole,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.outfit().fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'About',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Story',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'FAQs',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
            ),
            const SizedBox(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Text(
                    'hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha hahahaha',
                    style: GoogleFonts.outfit(fontSize: 16),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Text(
                      'Campaign Story goes here...',
                      style: GoogleFonts.outfit(fontSize: 16),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Text(
                      'FAQs go here...',
                      style: GoogleFonts.outfit(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            imageCard(),
            bodySection(),
          ],
        ),
      ),
    );
  }
}
