// sos_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/sos_model.dart';
import '../services/sos_service.dart';

class SosScreen extends StatefulWidget {
  final User user;

  const SosScreen({super.key, required this.user});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final SosService _sosService = SosService();
  bool _isLoading = false;
  bool _emergencySent = false;
  List<Emergency> _activeEmergencies = [];
  EmergencyStats? _stats;

  @override
  void initState() {
    super.initState();
    _loadActiveEmergencies();
    _loadStats();
  }

  Future<void> _loadActiveEmergencies() async {
    try {
      final emergencies = await _sosService.getActiveEmergencies();
      setState(() {
        _activeEmergencies = emergencies;
      });
    } catch (e) {
      _showErrorSnackbar('Gagal memuat data emergency aktif');
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _sosService.getEmergencyStats();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      // Ignore error for stats
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _sendEmergencySignal(String type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateSOSRequest(
        type: type,
        details: 'SOS Emergency dari ${widget.user.name ?? "Pengguna"}',
        location: 'Lokasi pengguna',
        needVolunteer: true,
        volunteerCount: 5,
        userId: widget.user.id,
      );

      final emergency = await _sosService.createSOS(request);

      setState(() {
        _emergencySent = true;
        _activeEmergencies.insert(0, emergency);
      });

      _showSuccessSnackbar('SOS Emergency berhasil dikirim!');
      _loadStats();
    } catch (e) {
      _showErrorSnackbar('Gagal mengirim SOS: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _registerAsVolunteer(int emergencyId) async {
    try {
      final request = RegisterVolunteerRequest(
        userId: widget.user.id,
        userName: widget.user.name ?? 'Anonymous',
        skills: 'Pertolongan pertama',
      );

      await _sosService.registerVolunteer(emergencyId, request);
      _showSuccessSnackbar('Berhasil mendaftar sebagai relawan!');
      _loadActiveEmergencies();
    } catch (e) {
      _showErrorSnackbar('Gagal mendaftar sebagai relawan: $e');
    }
  }

  void _showEmergencyDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Kirim SOS Emergency?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipe: $type'),
            const SizedBox(height: 12),
            const Text('Sistem akan:'),
            const SizedBox(height: 8),
            const Text('• Mengirimkan lokasi Anda saat ini'),
            const Text('• Mengirim permintaan bantuan'),
            const Text('• Memberi tahu kontak darurat'),
            const Text('• Mencari relawan terdekat'),
            const SizedBox(height: 12),
            const Text(
              'Gunakan hanya dalam keadaan darurat sesungguhnya!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendEmergencySignal(type);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Kirim SOS'),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Panggilan Darurat'),
        content: Text('Menghubungi $number?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.red),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementasi panggilan telepon
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Hubungi' , style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(
    String title,
    String number,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(number),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.phone, color: Colors.green.shade700, size: 20),
            onPressed: () => _makePhoneCall(number),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyItem(Emergency emergency) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emergency, color: Colors.red, size: 20),
        ),
        title: Text(
          emergency.type,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emergency.details ?? 'Tidak ada deskripsi'),
            const SizedBox(height: 4),
            Text(
              'Lokasi: ${emergency.location ?? 'Tidak diketahui'}',
              style: const TextStyle(fontSize: 12),
            ),
            if (emergency.needVolunteer)
              Text(
                'Butuh ${emergency.volunteerCount} relawan',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        trailing: emergency.needVolunteer
            ? ElevatedButton(
                onPressed: () => _registerAsVolunteer(emergency.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Daftar'),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - Fixed height
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade700, Colors.red.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SOS Emergency',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bantuan Darurat 24 Jam',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  if (_stats != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatItem(_stats!.active.toString(), 'Aktif'),
                        _buildStatItem(_stats!.resolved.toString(), 'Selesai'),
                        _buildStatItem(
                          _stats!.needVolunteers.toString(),
                          'Butuh Relawan',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Content - Expanded dengan SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // SOS Button
                    GestureDetector(
                      onTap: () =>
                          _showEmergencyDialog(context, 'Emergency Umum'),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red.shade300,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade200.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emergency,
                              color: Colors.red.shade700,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'SOS',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            Text(
                              'Tekan untuk darurat',
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Emergency Types
                    const Text(
                      'Jenis Emergency',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildEmergencyTypeButton(
                          'Kecelakaan',
                          Icons.car_crash,
                        ),
                        _buildEmergencyTypeButton(
                          'Kesehatan',
                          Icons.medical_services,
                        ),
                        _buildEmergencyTypeButton(
                          'Kebakaran',
                          Icons.fire_truck,
                        ),
                        _buildEmergencyTypeButton('Keamanan', Icons.security),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // // Active Emergencies Section
                    // if (_activeEmergencies.isNotEmpty) ...[
                    //   const Text(
                    //     'Emergency Aktif',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   const SizedBox(height: 16),
                    //   ..._activeEmergencies.map(_buildEmergencyItem).toList(),
                    //   const SizedBox(height: 16),
                    // ],

                    // Emergency Contacts Section
                    const Text(
                      'Kontak Darurat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildEmergencyContact(
                      'Polisi',
                      '110',
                      Icons.local_police,
                      Colors.blue,
                    ),
                    _buildEmergencyContact(
                      'Ambulans',
                      '118',
                      Icons.medical_services,
                      Colors.red,
                    ),
                    _buildEmergencyContact(
                      'Pemadam Kebakaran',
                      '113',
                      Icons.fire_truck,
                      Colors.orange,
                    ),
                    const SizedBox(height: 20), // Extra padding di bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTypeButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _showEmergencyDialog(context, label),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.shade200),
        ),
      ),
    );
  }
}
