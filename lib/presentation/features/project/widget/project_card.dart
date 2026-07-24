import 'package:flutter/material.dart';
import '../../../../domain/project/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Choose a rich, cover color based on project ID hash
    final coverColor = _getCoverColor(project.id);
    final goldColor = const Color(0xFFD4A373); // Elegant antique gold

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(3, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: coverColor,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Gold border inset (front cover decoration)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 8, top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: goldColor.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        bottomLeft: Radius.circular(2),
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Spine (left dark strip to look like binding)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 14,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.22),
                    border: Border(
                      right: BorderSide(
                        color: Colors.black.withOpacity(0.28),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) => Container(
                      height: 1.5,
                      width: 14,
                      color: goldColor.withOpacity(0.35),
                    )),
                  ),
                ),
              ),

              // Crease shadow for depth
              Positioned(
                left: 14,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              // Content inside the book cover
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 16, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ornament at the top center
                    Text(
                      '❦',
                      style: TextStyle(
                        color: goldColor,
                        fontSize: 20,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Project Title
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          project.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: theme.textTheme.displayLarge?.fontFamily ?? 'Lora',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: goldColor,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    
                    // Small divider rule
                    Container(
                      width: 32,
                      height: 1,
                      color: goldColor.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),

                    // Project Description (At the bottom half)
                    Expanded(
                      flex: 3,
                      child: Text(
                        project.description ?? 'A chronicle untold...',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 9.5,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.35,
                        ) ?? TextStyle(
                          fontSize: 9.5,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    // Footer details
                    Text(
                      'Opened ${_formatDate(project.lastAccessedAt)}',
                      style: TextStyle(
                        fontSize: 7.5,
                        color: theme.colorScheme.onSurface.withOpacity(0.45),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Banish (Delete) button at top-right
              Positioned(
                top: 2,
                right: 2,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 15,
                      color: theme.colorScheme.error.withOpacity(0.65),
                    ),
                    onPressed: onDelete,
                    tooltip: 'Banish project',
                    splashRadius: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCoverColor(String id) {
    int hash = 0;
    for (int i = 0; i < id.length; i++) {
      hash = id.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // Choose beautiful rich cover color based on ID hash
    final colors = [
      const Color(0xFF5C1D24), // Burgundy
      const Color(0xFF1B3B2B), // Forest Green
      const Color(0xFF1B2E4A), // Indigo Navy
      const Color(0xFF4A341B), // Antique Brown
      const Color(0xFF381B4A), // Deep Plum
      const Color(0xFF2E2E2E), // Charcoal
    ];
    
    return colors[hash.abs() % colors.length];
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${dt.month}/${dt.day}/${dt.year}';
  }
}
