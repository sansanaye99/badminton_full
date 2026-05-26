import 'package:flutter/material.dart';
import '../models/news.dart';

class NewsTile extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const NewsTile({
    super.key,
    required this.news,
    required this.onTap,
  });

  static const Color pink = Color(0xFFE87EA1);
  static const Color pinkLight = Color(0xFFFFD6E7);
  static const Color mint = Color(0xFF5BC8AF);

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}';

    final bool hasImage = news.imageUrl.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: pinkLight, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: hasImage
                    ? Image.network(
                  news.imageUrl,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
                    : _placeholder(),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      news.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: pinkLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            news.category,
                            style: const TextStyle(
                              color: pink,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateText,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios,
                color: pink,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 76,
      height: 76,
      color: pinkLight,
      child: const Icon(
        Icons.campaign_outlined,
        color: pink,
        size: 28,
      ),
    );
  }
}