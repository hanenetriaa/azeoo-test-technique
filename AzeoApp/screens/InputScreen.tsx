import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
} from 'react-native';
import { useUser } from '../context/UserContext';

export default function InputScreen() {
  const [inputValue, setInputValue] = useState('1');
  const { setUserId } = useUser();

  const handleSave = () => {
    const id = parseInt(inputValue);
    if (isNaN(id) || id <= 0) {
      Alert.alert('Erreur', 'Veuillez entrer un ID valide (1 ou 3)');
      return;
    }
    
    setUserId(id);
    Alert.alert(
      'Succès',
      `UserId ${id} sauvegardé ! Passez à l'onglet Profil.`
    );
  };

  return (
    <View style={styles.container}>
      {/* Formes géométriques décoratives */}
      <View style={styles.hexagon1} />
      <View style={styles.hexagon2} />
      <View style={styles.circle} />

      <View style={styles.content}>
        <View style={styles.header}>
          <View style={styles.iconContainer}>
            <Text style={styles.icon}>👤</Text>
          </View>
          <Text style={styles.title}>Sélectionner un utilisateur</Text>
          <Text style={styles.subtitle}>
            Entrez l'ID pour afficher le profil
          </Text>
        </View>

        <View style={styles.card}>
          <View style={styles.inputWrapper}>
            <View style={styles.inputIconBox}>
              <Text style={styles.inputIcon}>#</Text>
            </View>
            <TextInput
              style={styles.input}
              value={inputValue}
              onChangeText={setInputValue}
              keyboardType="number-pad"
              placeholder="1 ou 3"
              placeholderTextColor="#94A3B8"
            />
          </View>

          <TouchableOpacity 
            style={styles.button} 
            onPress={handleSave}
            activeOpacity={0.8}
          >
            <View style={styles.buttonContent}>
              <Text style={styles.buttonText}>Charger le profil</Text>
              <Text style={styles.buttonArrow}>→</Text>
            </View>
          </TouchableOpacity>
        </View>

        <View style={styles.examplesBox}>
          <Text style={styles.examplesTitle}>Exemples disponibles</Text>
          <View style={styles.examplesList}>
            <TouchableOpacity 
              style={styles.exampleItem}
              onPress={() => setInputValue('1')}
            >
              <View style={styles.exampleDot} />
              <Text style={styles.exampleText}>ID 1 - Samuel Verdier</Text>
            </TouchableOpacity>
            <TouchableOpacity 
              style={styles.exampleItem}
              onPress={() => setInputValue('3')}
            >
              <View style={styles.exampleDot} />
              <Text style={styles.exampleText}>ID 3 - Ana' Ïs</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8F9FA',
    position: 'relative',
  },
  // Formes géométriques décoratives
  hexagon1: {
    position: 'absolute',
    top: 50,
    right: -30,
    width: 80,
    height: 80,
    backgroundColor: '#FF8C4220',
    transform: [{ rotate: '30deg' }],
    borderRadius: 8,
  },
  hexagon2: {
    position: 'absolute',
    bottom: 100,
    left: -20,
    width: 60,
    height: 60,
    backgroundColor: '#4A90E220',
    transform: [{ rotate: '45deg' }],
    borderRadius: 6,
  },
  circle: {
    position: 'absolute',
    top: 200,
    left: 30,
    width: 40,
    height: 40,
    backgroundColor: '#2D2E5F15',
    borderRadius: 20,
  },
  content: {
    flex: 1,
    padding: 24,
    justifyContent: 'center',
    zIndex: 1,
  },
  header: {
    alignItems: 'center',
    marginBottom: 40,
  },
  iconContainer: {
    width: 80,
    height: 80,
    backgroundColor: '#2D2E5F',
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
    shadowColor: '#2D2E5F',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 12,
    elevation: 8,
  },
  icon: {
    fontSize: 40,
  },
  title: {
    fontSize: 26,
    fontWeight: '700',
    color: '#1A1B4B',
    marginBottom: 8,
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 15,
    color: '#64748B',
    letterSpacing: 0.2,
  },
  card: {
    backgroundColor: 'white',
    borderRadius: 20,
    padding: 24,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.08,
    shadowRadius: 12,
    elevation: 4,
    marginBottom: 24,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F8F9FA',
    borderRadius: 16,
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#E2E8F0',
  },
  inputIconBox: {
    width: 50,
    height: 60,
    backgroundColor: '#2D2E5F',
    borderTopLeftRadius: 14,
    borderBottomLeftRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  inputIcon: {
    fontSize: 24,
    color: 'white',
    fontWeight: 'bold',
  },
  input: {
    flex: 1,
    height: 60,
    fontSize: 20,
    fontWeight: '600',
    color: '#1A1B4B',
    paddingHorizontal: 16,
  },
  button: {
    backgroundColor: '#FF6B35',
    borderRadius: 16,
    overflow: 'hidden',
    shadowColor: '#FF6B35',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 6,
  },
  buttonContent: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 18,
    paddingHorizontal: 24,
  },
  buttonText: {
    color: 'white',
    fontSize: 17,
    fontWeight: '700',
    marginRight: 8,
    letterSpacing: 0.5,
  },
  buttonArrow: {
    color: 'white',
    fontSize: 20,
    fontWeight: 'bold',
  },
  examplesBox: {
    backgroundColor: 'white',
    borderRadius: 16,
    padding: 20,
    borderLeftWidth: 4,
    borderLeftColor: '#4A90E2',
  },
  examplesTitle: {
    fontSize: 14,
    fontWeight: '700',
    color: '#1A1B4B',
    marginBottom: 12,
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  examplesList: {
    gap: 12,
  },
  exampleItem: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  exampleDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: '#FF8C42',
    marginRight: 12,
  },
  exampleText: {
    fontSize: 15,
    color: '#475569',
    fontWeight: '500',
  },
});