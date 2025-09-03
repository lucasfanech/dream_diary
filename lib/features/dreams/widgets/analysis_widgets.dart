import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Widget de carte d'analyse réutilisable
class AnalysisCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  
  const AnalysisCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.color,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: color ?? AppConstants.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color ?? AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            child,
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher des statistiques avec icône
class StatisticWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  
  const StatisticWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget pour afficher un graphique de progression
class ProgressChart extends StatelessWidget {
  final String title;
  final double value;
  final double maxValue;
  final Color color;
  final String? unit;
  
  const ProgressChart({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.color,
    this.unit,
  });
  
  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}${unit ?? ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Widget pour afficher des tags avec couleurs
class TagChip extends StatelessWidget {
  final String tag;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;
  
  const TagChip({
    super.key,
    required this.tag,
    this.color,
    this.onTap,
    this.isSelected = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppConstants.primaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? chipColor 
              : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: chipColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          tag,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : chipColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher une liste de tags
class TagList extends StatelessWidget {
  final List<String> tags;
  final Color? color;
  final Function(String)? onTagTap;
  final List<String>? selectedTags;
  
  const TagList({
    super.key,
    required this.tags,
    this.color,
    this.onTagTap,
    this.selectedTags,
  });
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.paddingSmall,
      runSpacing: AppConstants.paddingSmall,
      children: tags.map((tag) {
        return TagChip(
          tag: tag,
          color: color,
          onTap: onTagTap != null ? () => onTagTap!(tag) : null,
          isSelected: selectedTags?.contains(tag) ?? false,
        );
      }).toList(),
    );
  }
}

/// Widget pour afficher des émotions avec intensité
class EmotionIndicator extends StatelessWidget {
  final String emotion;
  final int intensity;
  final Color? color;
  final String? contextInfo;
  
  const EmotionIndicator({
    super.key,
    required this.emotion,
    required this.intensity,
    this.color,
    this.contextInfo,
  });
  
  @override
  Widget build(BuildContext context) {
    final emotionColor = color ?? _getEmotionColor(emotion);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: emotionColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: emotionColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emotion,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: emotionColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$intensity/10',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: emotionColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            children: List.generate(10, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: index < intensity 
                      ? emotionColor 
                      : emotionColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          if (contextInfo != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              contextInfo!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: emotionColor.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joie':
      case 'bonheur':
      case 'euphorie':
        return Colors.green;
      case 'tristesse':
      case 'mélancolie':
      case 'dépression':
        return Colors.blue;
      case 'colère':
      case 'rage':
      case 'frustration':
        return Colors.red;
      case 'peur':
      case 'anxiété':
      case 'panique':
        return Colors.orange;
      case 'amour':
      case 'passion':
      case 'tendresse':
        return Colors.pink;
      case 'surprise':
      case 'étonnement':
        return Colors.purple;
      case 'dégoût':
      case 'répulsion':
        return Colors.brown;
      default:
        return AppConstants.primaryColor;
    }
  }
}

/// Widget pour afficher un graphique en barres simple
class SimpleBarChart extends StatelessWidget {
  final Map<String, double> data;
  final Color? color;
  final double? maxHeight;
  
  const SimpleBarChart({
    super.key,
    required this.data,
    this.color,
    this.maxHeight,
  });
  
  @override
  Widget build(BuildContext context) {
    final maxValue = data.values.isNotEmpty ? data.values.reduce((a, b) => a > b ? a : b) : 1.0;
    final chartColor = color ?? AppConstants.primaryColor;
    
    return Container(
      height: maxHeight ?? 200,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data.entries.map((entry) {
                final height = (entry.value / maxValue) * (maxHeight ?? 200 - 40);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        color: chartColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      entry.value.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: chartColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher une timeline d'émotions
class EmotionTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;
  
  const EmotionTimeline({
    super.key,
    required this.timeline,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: timeline.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == timeline.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getEmotionColor(item['emotion'] ?? ''),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: AppConstants.textSecondaryColor.withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['date']?.toString() ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                  Text(
                    item['emotion']?.toString() ?? '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item['context'] != null)
                    Text(
                      item['context'].toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
  
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joie':
      case 'bonheur':
        return Colors.green;
      case 'tristesse':
        return Colors.blue;
      case 'colère':
        return Colors.red;
      case 'peur':
        return Colors.orange;
      case 'amour':
        return Colors.pink;
      default:
        return AppConstants.primaryColor;
    }
  }
}

/// Widget pour afficher des recommandations
class RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  
  const RecommendationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppConstants.warningColor;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: cardColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.textSecondaryColor,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
