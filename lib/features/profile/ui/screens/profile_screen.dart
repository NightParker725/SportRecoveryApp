import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/profile/ui/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameCtrl = TextEditingController();
  final birthCtrl = TextEditingController();
  final sexCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadMyProfile());
  }

  DateTime? _parseDate(String v) {
    if (v.trim().isEmpty) return null;
    try {
      final parts = v.split('/');
      if (parts.length == 3) {
        final d = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final y = int.parse(parts[2]);
        return DateTime(y, m, d);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  double? _parseNum(String v) =>
      v.trim().isEmpty ? null : double.tryParse(v.trim());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSaved) {
              Navigator.pushReplacementNamed(context, '/my_profile');
              return;
            } else if (state is ProfileLoaded) {
              final p = state.profile;
              nameCtrl.text = p.name;
              birthCtrl.text = p.birthDate == null
                  ? ''
                  : "${p.birthDate!.day.toString().padLeft(2, '0')}/"
                        "${p.birthDate!.month.toString().padLeft(2, '0')}/"
                        "${p.birthDate!.year}";
              sexCtrl.text = p.sex ?? '';
              heightCtrl.text = p.heightCm?.toString() ?? '';
              weightCtrl.text = p.weightKg?.toString() ?? '';
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final saving = state is ProfileSaving;
            return ListView(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(label: Text('Nombre')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: birthCtrl,
                  decoration: const InputDecoration(
                    label: Text('Fecha nac. (DD/MM/YYYY)'),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: sexCtrl,
                  decoration: const InputDecoration(
                    label: Text('Sexo (M/F/O)'),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: heightCtrl,
                  decoration: const InputDecoration(label: Text('Altura (cm)')),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: weightCtrl,
                  decoration: const InputDecoration(label: Text('Peso (kg)')),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: saving
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(
                            SaveMyProfile(
                              name: nameCtrl.text,
                              birthDate: _parseDate(birthCtrl.text),
                              sex: sexCtrl.text,
                              heightCm: _parseNum(heightCtrl.text),
                              weightKg: _parseNum(weightCtrl.text),
                            ),
                          );
                        },
                  child: saving
                      ? const CircularProgressIndicator()
                      : const Text('Guardar cambios'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
