import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/user_provider.dart';

/// Écran du profil utilisateur avec design AZEOO
class ProfileScreen extends ConsumerWidget {
  final int userId;

  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D2E5F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: userAsync.when(
        // ✅ DONNÉES CHARGÉES
        data: (user) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userProfileProvider(userId));
          },
          color: const Color(0xFFFF6B35),
          child: Stack(
            children: [
              // Formes géométriques décoratives
              Positioned(
                top: 50,
                right: 20,
                child: Transform.rotate(
                  angle: 0.5,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C42).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Contenu principal
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // AVATAR avec badge
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CachedNetworkImage(
                              imageUrl: user.avatarUrl,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 60,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => const CircleAvatar(
                                radius: 60,
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const CircleAvatar(
                                radius: 60,
                                backgroundColor: Color(0xFFE2E8F0),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // NOM COMPLET
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1B4B),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // USER ID BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2E5F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ID #${user.id}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // SECTION TITLE
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'INFORMATIONS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // CARTES D'INFORMATIONS
                      _buildInfoCard(
                        icon: Icons.email,
                        iconColor: const Color(0xFFFF6B35),
                        title: 'Email',
                        value: user.email ?? 'Non renseigné',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildInfoCard(
                        icon: Icons.location_city,
                        iconColor: const Color(0xFF4A90E2),
                        title: 'Ville',
                        value: user.city ?? 'Non renseigné',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildInfoCard(
                        icon: Icons.flag,
                        iconColor: const Color(0xFF2D2E5F),
                        title: 'Pays',
                        value: user.country ?? 'Non renseigné',
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // BOUTON REFRESH
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.invalidate(userProfileProvider(userId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2E5F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            shadowColor: const Color(0xFF2D2E5F).withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.refresh, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Actualiser les données',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // FOOTER
                      const Text(
                        'PROPULSÉ PAR AZEOO SDK',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // ⏳ CHARGEMENT
        loading: () => Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'Chargement en cours...',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // ❌ ERREUR
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Oups !',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(userProfileProvider(userId));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Réessayer',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget pour afficher une carte d'information avec design AZEOO
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }
}