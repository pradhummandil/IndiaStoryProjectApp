import 'package:flutter/material.dart';

/// Your Collections section — bento grid of story collections.
///
/// HTML: mb-section-gap
/// header: "Your Collections" bookmark icon + "View All" link
/// grid: 1 col md:3 col gap-6
/// Large card (md:col-span-2): "Forgotten Stepwells of Gujarat"
/// Small cards: "The Silk Route Weavers", "Vedic Astronomy"
class ProfileCollectionsSection extends StatelessWidget {
  const ProfileCollectionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with "View All" link
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE8E2D8))),
            ),
            child: Row(
              children: [
                Icon(Icons.bookmark_rounded, size: 24, color: colors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your Collections',
                    style: TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      letterSpacing: 0.05,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  label: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Grid
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Large card — 2/3 width
                const Expanded(flex: 2, child: _LargeCollectionCard()),
                const SizedBox(width: 24),
                // Small cards column — 1/3 width
                Expanded(
                  flex: 1,
                  child: Column(
                    children: const [
                      _SmallCollectionCard(
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAC3v1eMG4CvGalJkRpE8CL74G1-nlJXRS5-0HjeOmBApHLFzWWWa6u91fzcrfpdVct5z9vvqvGGsMjgII_iesJRm-I9QaLSqvIrY0syCm-fRuy4jnuaqABEA8zVNk1wg7Czv5sgWtMFZWRF5PGdAQtB2RL1XWjxxfAzGYaOtkMb7OHG280DMh1YS8ES84mAYn_rNMr5SnZf5-roWMqkUZDBp-aOoJyV5HdI-981J2v0AWrQq1Mij2MKw',
                        category: 'Craft',
                        title: 'The Silk Route Weavers',
                        storyCount: '8 Stories saved',
                      ),
                      SizedBox(height: 24),
                      _SmallCollectionCard(
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuC2MEvSOphhRzhHes9JkPSCS2OhKKFtzKOQzziEOMJamNYP4jNj9vLA2JRJ_uCR--2x_hFLIbkmGaQTcP1yJn5_C85OnmxJJ_7R02J-KHsi9UePMOah5Eoc_bw8DmGFZKzWWNehF_XkHd60wWZ4jYE-nEwY5QkLE6MvjYYr586Vl4hmXA166pJePiv9NSngia2UpTsxwcxTYUDP_RW4n9Ai5NOzjPyqPYrkZ3cwqkqOU4DzFVkYJlcXLw',
                        category: 'Science',
                        title: 'Vedic Astronomy',
                        storyCount: '5 Stories saved',
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: const [
                _LargeCollectionCard(),
                SizedBox(height: 24),
                _SmallCollectionCard(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAC3v1eMG4CvGalJkRpE8CL74G1-nlJXRS5-0HjeOmBApHLFzWWWa6u91fzcrfpdVct5z9vvqvGGsMjgII_iesJRm-I9QaLSqvIrY0syCm-fRuy4jnuaqABEA8zVNk1wg7Czv5sgWtMFZWRF5PGdAQtB2RL1XWjxxfAzGYaOtkMb7OHG280DMh1YS8ES84mAYn_rNMr5SnZf5-roWMqkUZDBp-aOoJyV5HdI-981J2v0AWrQq1Mij2MKw',
                  category: 'Craft',
                  title: 'The Silk Route Weavers',
                  storyCount: '8 Stories saved',
                ),
                SizedBox(height: 24),
                _SmallCollectionCard(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC2MEvSOphhRzhHes9JkPSCS2OhKKFtzKOQzziEOMJamNYP4jNj9vLA2JRJ_uCR--2x_hFLIbkmGaQTcP1yJn5_C85OnmxJJ_7R02J-KHsi9UePMOah5Eoc_bw8DmGFZKzWWNehF_XkHd60wWZ4jYE-nEwY5QkLE6MvjYYr586Vl4hmXA166pJePiv9NSngia2UpTsxwcxTYUDP_RW4n9Ai5NOzjPyqPYrkZ3cwqkqOU4DzFVkYJlcXLw',
                  category: 'Science',
                  title: 'Vedic Astronomy',
                  storyCount: '5 Stories saved',
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _LargeCollectionCard extends StatelessWidget {
  const _LargeCollectionCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E2D8)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: const Color(0xFF1E1E1E).withValues(alpha: 0.02),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBxdcOF9qhjHC8h_T8m2m9iv4Gd1AHEjphDuXqrDN7xI1QpQ0w-TnpNc-rbMWihnTFGo-M5DE8G408s3to_bjbSmOOcOd41HeJD0dQEZ9vDsJzZuQVGarNTbPk3_jXwLlP8lqJotUb2cUyrODrGeUC9dfFydnIYMSLV4rQ1DXjH_fZ3905xmR7_qeq6TpTgyuYf89tMAwbhb0bNfAErAHxDLviIEKeogwBNlTIdYTpqbZAgzMx_IyvIvA',
                  fit: BoxFit.cover,
                  height: 256,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 256,
                    color: colors.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(Icons.image_rounded, size: 48),
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x99000000)],
                    ),
                  ),
                ),
              ),
              // "12 Stories" badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xFFE8E2D8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.collections_rounded,
                        size: 16,
                        color: const Color(0xFF755B00),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '12 Stories',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARCHITECTURE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF755B00),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Forgotten Stepwells of Gujarat',
                  style: TextStyle(
                    fontFamily: 'EB Garamond',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A curated journey through the intricate subterranean water temples that served as community hubs.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5F6368),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallCollectionCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String storyCount;

  const _SmallCollectionCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.storyCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E2D8)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: const Color(0xFF1E1E1E).withValues(alpha: 0.02),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image — 1/3 width
          SizedBox(
            width: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colors.surfaceContainerHigh,
                  child: const Center(child: Icon(Icons.image_rounded)),
                ),
              ),
            ),
          ),
          // Content — 2/3 width
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF755B00),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    storyCount,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
