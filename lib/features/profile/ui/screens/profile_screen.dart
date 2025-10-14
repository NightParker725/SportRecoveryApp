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
      backgroundColor: const Color(0xFF121212), // Fondo oscuro
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSaved) {
              Navigator.pushReplacementNamed(context, '/my_profile');
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
            final saving = state is ProfileSaving;

            return Stack(
              children: [
                // Contenedor inferior con bordes curvos
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F242A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Editar Perfil",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          _buildLabel("Nombre"),
                          _buildTextField(nameCtrl, "Introduce tu nombre"),

                          const SizedBox(height: 16),
                          _buildLabel("Fecha nac. (DD/MM/YYYY)"),
                          _buildTextField(
                            birthCtrl,
                            "Ej: 12/05/2000",
                            keyboard: TextInputType.datetime,
                          ),

                          const SizedBox(height: 16),
                          _buildLabel("Sexo (M/F/O)"),
                          _buildTextField(sexCtrl, "Ej: M"),

                          const SizedBox(height: 16),
                          _buildLabel("Altura (cm)"),
                          _buildTextField(
                            heightCtrl,
                            "Ej: 170",
                            keyboard: TextInputType.number,
                          ),

                          const SizedBox(height: 16),
                          _buildLabel("Peso (kg)"),
                          _buildTextField(
                            weightCtrl,
                            "Ej: 65",
                            keyboard: TextInputType.number,
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saving
                                  ? null
                                  : () {
                                context.read<ProfileBloc>().add(
                                  SaveMyProfile(
                                    name: nameCtrl.text,
                                    birthDate:
                                    _parseDate(birthCtrl.text),
                                    sex: sexCtrl.text,
                                    heightCm:
                                    _parseNum(heightCtrl.text),
                                    weightKg:
                                    _parseNum(weightCtrl.text),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00FFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: saving
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                                  : const Text(
                                "Guardar cambios",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Capa de carga
                if (saving)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00FFFF),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _buildTextField(
      TextEditingController ctrl,
      String hint, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF666666)),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
