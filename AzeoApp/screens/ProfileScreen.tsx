import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  Image,
  StyleSheet,
  ActivityIndicator,
  ScrollView,
  RefreshControl,
  TouchableOpacity,
} from 'react-native';
import { useUser } from '../context/UserContext';

interface User {
  id: number;
  firstName: string;
  lastName: string;
  avatarUrl: string;
  email?: string;
  city?: string;
  country?: string;
}

export default function ProfileScreen() {
  const { userId } = useUser();
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [refreshing, setRefreshing] = useState(false);

  const fetchUser = async () => {
    if (!userId) return;

    setLoading(true);
    setError(null);

    try {
      const response = await fetch('https://api.azeoo.dev/v1/users/me', {
        headers: {
          'Accept-Language': 'fr-FR',
          'X-User-Id': userId.toString(),
          Authorization:
            'Bearer api_474758da8532e795f63bc4e5e6beca7298379993f65bb861f2e8e13c352cc4dcebcc3b10961a5c369edb05fbc0b0053cf63df1c53d9ddd7e4e5d680beb514d20',
        },
      });

      if (!response.ok) {
        throw new Error(`Erreur ${response.status}`);
      }

      const data = await response.json();

      const largeImage = data.picture.find((p: any) => p.label === 'large');

      setUser({
        id: data.id,
        firstName: data.first_name,
        lastName: data.last_name,
        avatarUrl: largeImage?.url || '',
        email: data.email,
        city: data.city?.value,
        country: data.country_code,
      });
    } catch (err: any) {
      setError(err.message || 'Erreur réseau');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    if (userId) {
      fetchUser();
    }
  }, [userId]);

  const onRefresh = () => {
    setRefreshing(true);
    fetchUser();
  };

  if (!userId) {
    return (
      <View style={styles.container}>
        <View style={styles.hexagonEmpty1} />
        <View style={styles.hexagonEmpty2} />
        <View style={styles.emptyState}>
          <View style={styles.emptyIconBox}>
            <Text style={styles.emptyIcon}>👤</Text>
          </View>
          <Text style={styles.emptyTitle}>Aucun profil sélectionné</Text>
          <Text style={styles.emptyText}>
            Passez à l'onglet précédent pour choisir un utilisateur
          </Text>
          <View style={styles.emptyDivider} />
          <Text style={styles.emptyHint}>Swipez vers la gauche →</Text>
        </View>
      </View>
    );
  }

  if (loading && !refreshing) {
    return (
      <View style={styles.container}>
        <View style={styles.hexagonEmpty1} />
        <View style={styles.loadingContainer}>
          <View style={styles.loadingBox}>
            <ActivityIndicator size="large" color="#FF6B35" />
            <Text style={styles.loadingText}>Chargement en cours...</Text>
            <View style={styles.loadingBar}>
              <View style={styles.loadingBarFill} />
            </View>
          </View>
        </View>
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.container}>
        <View style={styles.hexagonEmpty1} />
        <View style={styles.errorContainer}>
          <View style={styles.errorIconBox}>
            <Text style={styles.errorIcon}>⚠️</Text>
          </View>
          <Text style={styles.errorTitle}>Oups !</Text>
          <Text style={styles.errorText}>{error}</Text>
          <TouchableOpacity style={styles.retryButton} onPress={fetchUser}>
            <Text style={styles.retryButtonText}>Réessayer</Text>
          </TouchableOpacity>
          <Text style={styles.errorNote}>
            Note : Cette erreur est normale sur le web (CORS).{'\n'}
            L'app fonctionne parfaitement sur mobile !
          </Text>
        </View>
      </View>
    );
  }

  if (!user) return null;

  return (
    <ScrollView
      style={styles.scrollContainer}
      contentContainerStyle={styles.scrollContent}
      refreshControl={
        <RefreshControl 
          refreshing={refreshing} 
          onRefresh={onRefresh}
          colors={['#FF6B35']}
          tintColor="#FF6B35"
        />
      }
    >
      {/* Formes géométriques décoratives */}
      <View style={styles.hexagonTop} />
      <View style={styles.circleTop} />
      <View style={styles.triangleBottom} />

      {/* Header avec avatar */}
      <View style={styles.header}>
        <View style={styles.avatarContainer}>
          <View style={styles.avatarBorder}>
            <Image source={{ uri: user.avatarUrl }} style={styles.avatar} />
          </View>
          <View style={styles.avatarBadge}>
            <Text style={styles.avatarBadgeText}>✓</Text>
          </View>
        </View>
        
        <Text style={styles.name}>{user.firstName} {user.lastName}</Text>
        
        <View style={styles.idBadge}>
          <Text style={styles.idBadgeText}>ID #{user.id}</Text>
        </View>
      </View>

      {/* Informations */}
      <View style={styles.infoSection}>
        <Text style={styles.sectionTitle}>INFORMATIONS</Text>
        
        {user.email && (
          <View style={styles.infoCard}>
            <View style={[styles.infoIconBox, { backgroundColor: '#FF6B3515' }]}>
              <Text style={styles.infoIconText}>📧</Text>
            </View>
            <View style={styles.infoTextBox}>
              <Text style={styles.infoLabel}>Email</Text>
              <Text style={styles.infoValue}>{user.email}</Text>
            </View>
            <View style={styles.infoArrow}>
              <Text style={styles.infoArrowText}>→</Text>
            </View>
          </View>
        )}

        {user.city && (
          <View style={styles.infoCard}>
            <View style={[styles.infoIconBox, { backgroundColor: '#4A90E215' }]}>
              <Text style={styles.infoIconText}>📍</Text>
            </View>
            <View style={styles.infoTextBox}>
              <Text style={styles.infoLabel}>Ville</Text>
              <Text style={styles.infoValue}>{user.city}</Text>
            </View>
            <View style={styles.infoArrow}>
              <Text style={styles.infoArrowText}>→</Text>
            </View>
          </View>
        )}

        {user.country && (
          <View style={styles.infoCard}>
            <View style={[styles.infoIconBox, { backgroundColor: '#2D2E5F15' }]}>
              <Text style={styles.infoIconText}>🌍</Text>
            </View>
            <View style={styles.infoTextBox}>
              <Text style={styles.infoLabel}>Pays</Text>
              <Text style={styles.infoValue}>{user.country}</Text>
            </View>
            <View style={styles.infoArrow}>
              <Text style={styles.infoArrowText}>→</Text>
            </View>
          </View>
        )}
      </View>

      {/* Bouton refresh */}
      <TouchableOpacity 
        style={styles.refreshButton} 
        onPress={fetchUser}
        activeOpacity={0.8}
      >
        <Text style={styles.refreshIcon}>🔄</Text>
        <Text style={styles.refreshButtonText}>Actualiser les données</Text>
      </TouchableOpacity>

      <View style={styles.footer}>
        <Text style={styles.footerText}>Propulsé par AZEOO SDK</Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8F9FA',
    position: 'relative',
  },
  scrollContainer: {
    flex: 1,
    backgroundColor: '#F8F9FA',
  },
  scrollContent: {
    padding: 24,
    paddingTop: 32,
  },
  // Formes géométriques
  hexagonTop: {
    position: 'absolute',
    top: 50,
    right: 20,
    width: 60,
    height: 60,
    backgroundColor: '#FF8C4220',
    transform: [{ rotate: '30deg' }],
    borderRadius: 8,
  },
  circleTop: {
    position: 'absolute',
    top: 150,
    left: 20,
    width: 40,
    height: 40,
    backgroundColor: '#4A90E220',
    borderRadius: 20,
  },
  triangleBottom: {
    position: 'absolute',
    bottom: 100,
    right: 30,
    width: 0,
    height: 0,
    backgroundColor: 'transparent',
    borderStyle: 'solid',
    borderLeftWidth: 25,
    borderRightWidth: 25,
    borderBottomWidth: 50,
    borderLeftColor: 'transparent',
    borderRightColor: 'transparent',
    borderBottomColor: '#2D2E5F15',
    transform: [{ rotate: '45deg' }],
  },
  hexagonEmpty1: {
    position: 'absolute',
    top: 100,
    right: 40,
    width: 70,
    height: 70,
    backgroundColor: '#FF8C4215',
    transform: [{ rotate: '30deg' }],
    borderRadius: 8,
  },
  hexagonEmpty2: {
    position: 'absolute',
    bottom: 150,
    left: 30,
    width: 50,
    height: 50,
    backgroundColor: '#4A90E215',
    transform: [{ rotate: '45deg' }],
    borderRadius: 6,
  },
  // Header
  header: {
    alignItems: 'center',
    marginBottom: 32,
    zIndex: 1,
  },
  avatarContainer: {
    position: 'relative',
    marginBottom: 20,
  },
  avatarBorder: {
    padding: 6,
    backgroundColor: 'white',
    borderRadius: 70,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.15,
    shadowRadius: 16,
    elevation: 10,
  },
  avatar: {
    width: 120,
    height: 120,
    borderRadius: 60,
    backgroundColor: '#E2E8F0',
  },
  avatarBadge: {
    position: 'absolute',
    bottom: 5,
    right: 5,
    width: 32,
    height: 32,
    backgroundColor: '#FF6B35',
    borderRadius: 16,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 3,
    borderColor: 'white',
  },
  avatarBadgeText: {
    color: 'white',
    fontSize: 14,
    fontWeight: 'bold',
  },
  name: {
    fontSize: 28,
    fontWeight: '800',
    color: '#1A1B4B',
    marginBottom: 12,
    letterSpacing: -0.5,
  },
  idBadge: {
    backgroundColor: '#2D2E5F',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
  },
  idBadgeText: {
    color: 'white',
    fontWeight: '700',
    fontSize: 13,
    letterSpacing: 0.5,
  },
  // Section info
  infoSection: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 12,
    fontWeight: '800',
    color: '#64748B',
    marginBottom: 16,
    letterSpacing: 1.5,
  },
  infoCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'white',
    padding: 16,
    borderRadius: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.06,
    shadowRadius: 8,
    elevation: 2,
  },
  infoIconBox: {
    width: 48,
    height: 48,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  infoIconText: {
    fontSize: 22,
  },
  infoTextBox: {
    flex: 1,
  },
  infoLabel: {
    fontSize: 12,
    color: '#94A3B8',
    marginBottom: 4,
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  infoValue: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1E293B',
  },
  infoArrow: {
    width: 24,
    height: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  infoArrowText: {
    fontSize: 18,
    color: '#CBD5E1',
    fontWeight: 'bold',
  },
  // États vides et erreurs
  emptyState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
    zIndex: 1,
  },
  emptyIconBox: {
    width: 100,
    height: 100,
    backgroundColor: '#2D2E5F',
    borderRadius: 50,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 24,
  },
  emptyIcon: {
    fontSize: 48,
  },
  emptyTitle: {
    fontSize: 22,
    fontWeight: '700',
    color: '#1A1B4B',
    marginBottom: 12,
  },
  emptyText: {
    fontSize: 15,
    color: '#64748B',
    textAlign: 'center',
    lineHeight: 22,
  },
  emptyDivider: {
    width: 60,
    height: 3,
    backgroundColor: '#FF6B35',
    borderRadius: 2,
    marginVertical: 20,
  },
  emptyHint: {
    fontSize: 14,
    color: '#94A3B8',
    fontWeight: '600',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
    zIndex: 1,
  },
  loadingBox: {
    backgroundColor: 'white',
    padding: 40,
    borderRadius: 20,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.1,
    shadowRadius: 12,
    elevation: 5,
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#64748B',
    fontWeight: '600',
  },
  loadingBar: {
    width: 200,
    height: 4,
    backgroundColor: '#E2E8F0',
    borderRadius: 2,
    marginTop: 16,
    overflow: 'hidden',
  },
  loadingBarFill: {
    width: '60%',
    height: '100%',
    backgroundColor: '#FF6B35',
    borderRadius: 2,
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
    zIndex: 1,
  },
  errorIconBox: {
    width: 80,
    height: 80,
    backgroundColor: '#FEE2E2',
    borderRadius: 40,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  errorIcon: {
    fontSize: 40,
  },
  errorTitle: {
    fontSize: 22,
    fontWeight: '700',
    color: '#DC2626',
    marginBottom: 12,
  },
  errorText: {
    fontSize: 15,
    color: '#64748B',
    textAlign: 'center',
    marginBottom: 24,
    lineHeight: 22,
  },
  retryButton: {
    backgroundColor: '#FF6B35',
    paddingHorizontal: 32,
    paddingVertical: 14,
    borderRadius: 12,
    marginBottom: 16,
  },
  retryButtonText: {
    color: 'white',
    fontWeight: '700',
    fontSize: 16,
  },
  errorNote: {
    fontSize: 13,
    color: '#94A3B8',
    textAlign: 'center',
    fontStyle: 'italic',
    lineHeight: 20,
  },
  // Bouton refresh
  refreshButton: {
    flexDirection: 'row',
    backgroundColor: '#2D2E5F',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#2D2E5F',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 6,
    marginBottom: 24,
  },
  refreshIcon: {
    fontSize: 20,
    marginRight: 10,
  },
  refreshButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '700',
    letterSpacing: 0.5,
  },
  footer: {
    alignItems: 'center',
    paddingVertical: 20,
  },
  footerText: {
    fontSize: 12,
    color: '#94A3B8',
    fontWeight: '600',
    letterSpacing: 1,
  },
});