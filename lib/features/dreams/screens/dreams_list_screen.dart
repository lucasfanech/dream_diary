import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/dream.dart';
import '../providers/dream_provider.dart';

class DreamsListScreen extends StatefulWidget {
  const DreamsListScreen({super.key});

  @override
  State<DreamsListScreen> createState() => _DreamsListScreenState();
}

class _DreamsListScreenState extends State<DreamsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DreamProvider>(
      builder: (context, dreamProvider, child) {
        final dreams = dreamProvider.dreams;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.dreamsTab),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DreamSearchDelegate(dreamProvider.dreams),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implémenter les filtres
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filtres en cours de développement'),
                      backgroundColor: AppConstants.warningColor,
                    ),
                  );
                },
              ),
            ],
          ),
          body: dreamProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : dreams.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 64,
                            color: AppConstants.textSecondaryColor,
                          ),
                          const SizedBox(height: AppConstants.paddingLarge),
                          Text(
                            'Aucun rêve enregistré',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeXLarge,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            'Commencez par ajouter votre premier rêve !',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => dreamProvider.refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        itemCount: dreams.length,
                        itemBuilder: (context, index) {
                          final dream = dreams[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                                decoration: BoxDecoration(
                                  color: dream.isLucid 
                                      ? AppConstants.dreamBlue.withOpacity(0.1)
                                      : AppConstants.dreamPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                ),
                                child: Icon(
                                  dream.isLucid ? Icons.psychology : Icons.nightlight_round,
                                  color: dream.isLucid ? AppConstants.dreamBlue : AppConstants.dreamPurple,
                                ),
                              ),
                              title: Text(
                                dream.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: AppConstants.paddingSmall),
                                  Text(
                                    dream.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppConstants.textSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.paddingSmall),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: AppConstants.textSecondaryColor,
                                      ),
                                      const SizedBox(width: AppConstants.paddingSmall),
                                      Text(
                                        '${dream.createdAt.day}/${dream.createdAt.month}/${dream.createdAt.year}',
                                        style: const TextStyle(
                                          color: AppConstants.textSecondaryColor,
                                          fontSize: AppConstants.fontSizeSmall,
                                        ),
                                      ),
                                      if (dream.isLucid) ...[
                                        const SizedBox(width: AppConstants.paddingMedium),
                                        Icon(
                                          Icons.psychology,
                                          size: 14,
                                          color: AppConstants.dreamBlue,
                                        ),
                                        const SizedBox(width: AppConstants.paddingSmall),
                                        Text(
                                          'Lucide',
                                          style: TextStyle(
                                            color: AppConstants.dreamBlue,
                                            fontSize: AppConstants.fontSizeSmall,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteDialog(context, dream);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: AppConstants.errorColor),
                                        SizedBox(width: AppConstants.paddingSmall),
                                        Text('Supprimer'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // TODO: Navigation vers les détails du rêve
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Détails du rêve en cours de développement'),
                                    backgroundColor: AppConstants.warningColor,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Dream dream) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rêve'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${dream.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppConstants.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final dreamProvider = Provider.of<DreamProvider>(context, listen: false);
              final success = await dreamProvider.deleteDream(dream.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppConstants.successDreamDeleted),
                    backgroundColor: AppConstants.successColor,
                  ),
                );
              }
            },
            child: const Text(
              AppConstants.deleteButton,
              style: TextStyle(color: AppConstants.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}

class DreamSearchDelegate extends SearchDelegate<Dream?> {
  final List<Dream> dreams;

  DreamSearchDelegate(this.dreams);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredDreams = dreams
        .where((dream) =>
            dream.title.toLowerCase().contains(query.toLowerCase()) ||
            dream.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredDreams.length,
      itemBuilder: (context, index) {
        final dream = filteredDreams[index];
        return ListTile(
          leading: Icon(
            dream.isLucid ? Icons.psychology : Icons.nightlight_round,
            color: dream.isLucid ? AppConstants.dreamBlue : AppConstants.dreamPurple,
          ),
          title: Text(dream.title),
          subtitle: Text(
            dream.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, dream);
          },
        );
      },
    );
  }
}
