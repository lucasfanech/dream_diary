import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AddDreamScreen extends StatefulWidget {
  const AddDreamScreen({super.key});

  @override
  State<AddDreamScreen> createState() => _AddDreamScreenState();
}

class _AddDreamScreenState extends State<AddDreamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLucid = false;
  double _lucidityLevel = 0.0;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveDream() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implémenter la sauvegarde du rêve
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fonctionnalité en cours de développement'),
          backgroundColor: AppConstants.warningColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.addDreamTitle),
        actions: [
          TextButton(
            onPressed: _saveDream,
            child: const Text(AppConstants.saveButton),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            // Titre du rêve
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre du rêve',
                hintText: AppConstants.dreamTitlePlaceholder,
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez saisir un titre';
                }
                if (value.length > AppConstants.maxTitleLength) {
                  return 'Le titre est trop long';
                }
                return null;
              },
              maxLength: AppConstants.maxTitleLength,
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Contenu du rêve
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Description du rêve',
                hintText: AppConstants.dreamContentPlaceholder,
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              maxLength: AppConstants.maxContentLength,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez décrire votre rêve';
                }
                if (value.length > AppConstants.maxContentLength) {
                  return 'La description est trop longue';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Date du rêve
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.textSecondaryColor),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? 'Date du rêve: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Sélectionner la date du rêve (optionnel)',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? AppConstants.textPrimaryColor
                              : AppConstants.textSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Rêve lucide
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology, color: AppConstants.dreamBlue),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Text(
                            'Rêve lucide',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: _isLucid,
                          onChanged: (value) {
                            setState(() {
                              _isLucid = value;
                              if (!value) _lucidityLevel = 0.0;
                            });
                          },
                          activeColor: AppConstants.dreamBlue,
                        ),
                      ],
                    ),
                    if (_isLucid) ...[
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        'Niveau de lucidité: ${_lucidityLevel.toInt()}%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Slider(
                        value: _lucidityLevel,
                        min: 0.0,
                        max: 100.0,
                        divisions: 10,
                        activeColor: AppConstants.dreamBlue,
                        onChanged: (value) {
                          setState(() {
                            _lucidityLevel = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Bouton d'enregistrement audio
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implémenter l'enregistrement audio
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enregistrement audio en cours de développement'),
                    backgroundColor: AppConstants.warningColor,
                  ),
                );
              },
              icon: const Icon(Icons.mic),
              label: const Text('Enregistrer en audio'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Informations sur l'IA
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(
                  color: AppConstants.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Text(
                      'L\'IA analysera automatiquement votre rêve et générera un titre, un résumé et une image',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontSize: AppConstants.fontSizeSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Bouton de sauvegarde
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveDream,
                icon: const Icon(Icons.save),
                label: const Text(AppConstants.saveButton),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
